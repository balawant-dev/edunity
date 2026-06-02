import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  FaceRecognitionService._();

  static final FaceRecognitionService instance = FaceRecognitionService._();

  static const int inputSize = 112;
  static const int embeddingSize = 192;

  /// Enterprise tuned
  static const double bestThreshold = 0.74;
  static const double avgThreshold = 0.68;

  late Interpreter _interpreter;

  bool _initialized = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> init() async {
    if (_initialized) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/models/mobilefacenet.tflite',
    );

    _initialized = true;
  }

  void _ensureInit() {
    if (!_initialized) {
      throw Exception(
        "FaceRecognitionService not initialized",
      );
    }
  }

  Future<void> clearEmbeddings() async {
    await _storage.delete(
      key: 'face_embeddings',
    );
  }

  Future<List<double>> extractEmbedding(
    File imageFile,
    Face face,
  ) async {
    _ensureInit();

    final bytes = await imageFile.readAsBytes();

    final original = img.decodeImage(bytes);

    if (original == null) {
      throw Exception("Image decode failed");
    }

    final cropped = _cropFaceEnterprise(original, face.boundingBox);

    final resized = img.copyResize(
      cropped,
      width: inputSize,
      height: inputSize,
    );

    final input = _imageToInput(resized);

    final output = List.generate(
      1,
      (_) => List.filled(
        embeddingSize,
        0.0,
      ),
    );

    _interpreter.run(
      input,
      output,
    );

    final embedding = List<double>.from(output.first);

    return _l2Normalize(
      embedding,
    );
  }

  img.Image _cropFaceEnterprise(
    img.Image image,
    Rect rect,
  ) {
    final padX = (rect.width * 0.25).toInt();

    final padY = (rect.height * 0.35).toInt();

    int x = max(
      0,
      rect.left.toInt() - padX,
    );

    int y = max(
      0,
      rect.top.toInt() - padY,
    );

    int w = min(
      image.width - x,
      rect.width.toInt() + (padX * 2),
    );

    int h = min(
      image.height - y,
      rect.height.toInt() + (padY * 2),
    );

    return img.copyCrop(
      image,
      x: x,
      y: y,
      width: w,
      height: h,
    );
  }

  Future<List<List<double>>> generateEmbeddingsFromFiles(
    List<File> files,
  ) async {
    _ensureInit();

    final detector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableLandmarks: false,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    List<List<double>> embeddings = [];

    try {
      for (final file in files) {
        final inputImage = InputImage.fromFile(
          file,
        );

        final faces = await detector.processImage(
          inputImage,
        );

        if (faces.isEmpty) {
          continue;
        }

        /// reuse existing method
        final embedding = await extractEmbedding(
          file,
          faces.first,
        );

        embeddings.add(
          embedding,
        );
      }
    } finally {
      detector.close();
    }

    return embeddings;
  }

  Future<bool> verifyFaceAgainstEmbeddings(
    List<double> currentEmbedding,
    List<List<double>> referenceEmbeddings,
  ) async {
    if (referenceEmbeddings.isEmpty) {
      return false;
    }

    double best = 0;
    double sum = 0;

    for (final emb in referenceEmbeddings) {
      final similarity = cosineSimilarity(
        emb,
        currentEmbedding,
      );

      if (similarity > best) {
        best = similarity;
      }

      sum += similarity;
    }

    final avg = sum / referenceEmbeddings.length;

    final hybrid = (best * .7) + (avg * .3);

    debugPrint(
      "BEST=$best AVG=$avg HYBRID=$hybrid",
    );

    return best >= 0.74 && hybrid >= 0.72;
  }

  List<List<List<List<double>>>> _imageToInput(
    img.Image image,
  ) {
    return [
      List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final p = image.getPixel(x, y);

            return [
              (p.r - 127.5) / 127.5,
              (p.g - 127.5) / 127.5,
              (p.b - 127.5) / 127.5,
            ];
          },
        ),
      ),
    ];
  }

  List<double> _l2Normalize(
    List<double> emb,
  ) {
    double sum = 0;

    for (final e in emb) {
      sum += e * e;
    }

    final norm = sqrt(sum);

    if (norm == 0) return emb;

    return emb.map((e) => e / norm).toList();
  }

  double cosineSimilarity(
    List<double> a,
    List<double> b,
  ) {
    double dot = 0;
    double normA = 0;
    double normB = 0;

    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    final denom = sqrt(normA) * sqrt(normB);

    if (denom == 0) {
      return 0;
    }

    return dot / denom;
  }

  Future<void> saveEmbeddings(
    List<List<double>> embeddings,
  ) async {
    await _storage.write(
      key: 'face_embeddings',
      value: jsonEncode(
        embeddings,
      ),
    );
  }

  Future<List<List<double>>?> getSavedEmbeddings() async {
    final data = await _storage.read(
      key: 'face_embeddings',
    );

    if (data == null) {
      return null;
    }

    final decoded = jsonDecode(data) as List;

    return decoded
        .map(
          (e) => List<double>.from(e),
        )
        .toList();
  }

  Future<bool> verifyFace(
    List<double> currentEmbedding,
  ) async {
    final saved = await getSavedEmbeddings();

    if (saved == null || saved.isEmpty) {
      return false;
    }

    double best = 0;
    double sum = 0;

    for (final emb in saved) {
      final sim = cosineSimilarity(
        emb,
        currentEmbedding,
      );

      if (sim > best) {
        best = sim;
      }

      sum += sim;

      debugPrint(
        "SIM => $sim",
      );
    }

    final avg = sum / saved.length;

    final hybrid = (best * 0.7) + (avg * 0.3);

    debugPrint(
      "BEST => $best",
    );

    debugPrint(
      "AVG => $avg",
    );

    debugPrint(
      "HYBRID => $hybrid",
    );

    debugPrint("BEST => $best");
    debugPrint("AVG => $avg");
    debugPrint("HYBRID => $hybrid");

    // final passed = best >= bestThreshold && hybrid >= 0.72;
    final passed = best >= bestThreshold && hybrid >= 0.72;

    return passed;
  }

  bool isValidFace(
    Face face,
  ) {
    final left = face.leftEyeOpenProbability ?? 0;

    final right = face.rightEyeOpenProbability ?? 0;

    final width = face.boundingBox.width;

    final height = face.boundingBox.height;

    final yaw = (face.headEulerAngleY ?? 0).abs();

    final pitch = (face.headEulerAngleX ?? 0).abs();

    return width >= 140 &&
        height >= 140 &&
        yaw < 15 &&
        pitch < 15 &&
        left > 0.45 &&
        right > 0.45;
  }

  void dispose() {
    if (_initialized) {
      _interpreter.close();
      _initialized = false;
    }
  }
}
