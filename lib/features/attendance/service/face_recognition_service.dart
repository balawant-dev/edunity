import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  FaceRecognitionService._();

  static final FaceRecognitionService instance =
  FaceRecognitionService._();

  /// =========================
  /// CONFIG
  /// =========================
  static const int inputSize = 112;
  static const int embeddingSize = 192;

  /// Tunable thresholds (production-safe)
  static const double matchThreshold = 0.86;
  static const double minFaceSize = 90;

  /// =========================
  /// DEPENDENCIES
  /// =========================
  late Interpreter _interpreter;
  bool _isInitialized = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// =========================
  /// INIT
  /// =========================
  Future<void> init() async {
    if (_isInitialized) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/models/mobilefacenet.tflite',
    );

    _isInitialized = true;
  }

  /// =========================
  /// EMBEDDING EXTRACTION
  /// =========================
  Future<List<double>> extractEmbedding(
      File imageFile,
      Face face,
      ) async {
    _ensureInit();

    final imageBytes = await imageFile.readAsBytes();
    final original = img.decodeImage(imageBytes);

    if (original == null) {
      throw Exception("Image decode failed");
    }

    final cropped = _safeCrop(original, face.boundingBox);

    final resized = img.copyResize(
      cropped,
      width: inputSize,
      height: inputSize,
    );

    final input = _imageToInput(resized);

    final output = List.generate(
      1,
          (_) => List.filled(embeddingSize, 0.0),
    );

    _interpreter.run(input, output);

    final embedding = List<double>.from(output.first);

    return _l2Normalize(embedding);
  }

  /// =========================
  /// SAFE CROP (FIX BACKGROUND ISSUE)
  /// =========================
  // img.Image _safeCrop(img.Image image, Rect rect) {
  //   final padding = (rect.width * 0.10).toInt();
  //
  //   final centerX = (rect.left + rect.width / 2).toInt();
  //   final centerY = (rect.top + rect.height / 2).toInt();
  //
  //   final size = max(rect.width, rect.height).toInt() + padding * 2;
  //
  //   final x = (centerX - size ~/ 2).clamp(0, image.width - 1);
  //   final y = (centerY - size ~/ 2).clamp(0, image.height - 1);
  //
  //   final w = min(size, image.width - x);
  //   final h = min(size, image.height - y);
  //
  //   return img.copyCrop(
  //     image,
  //     x: x,
  //     y: y,
  //     width: w,
  //     height: h,
  //   );
  // }
  img.Image _safeCrop(img.Image image, Rect rect) {

    final paddingX = (rect.width * 0.18).toInt();
    final paddingY = (rect.height * 0.28).toInt();

    int x = max(0, rect.left.toInt() - paddingX);
    int y = max(0, rect.top.toInt() - paddingY);

    int w = min(
      image.width - x,
      rect.width.toInt() + (paddingX * 2),
    );

    int h = min(
      image.height - y,
      rect.height.toInt() + (paddingY * 2),
    );

    return img.copyCrop(
      image,
      x: x,
      y: y,
      width: w,
      height: h,
    );
  }
  /// =========================
  /// IMAGE PREPROCESS
  /// =========================
  List<List<List<List<double>>>> _imageToInput(img.Image image) {
    return [
      List.generate(
        inputSize,
            (y) => List.generate(
          inputSize,
              (x) {
            final pixel = image.getPixel(x, y);

            return [
              (pixel.r.toDouble() - 127.5) / 127.5,
              (pixel.g.toDouble() - 127.5) / 127.5,
              (pixel.b.toDouble() - 127.5) / 127.5,
            ];
          },
        ),
      ),
    ];
  }

  /// =========================
  /// NORMALIZATION
  /// =========================
  List<double> _l2Normalize(List<double> v) {
    double sum = 0;

    for (final e in v) {
      sum += e * e;
    }

    final norm = sqrt(sum);

    if (norm == 0) return v;

    return v.map((e) => e / norm).toList();
  }

  /// =========================
  /// COSINE SIMILARITY
  /// =========================
  double cosineSimilarity(List<double> a, List<double> b) {
    double dot = 0;
    double normA = 0;
    double normB = 0;

    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    final denom = sqrt(normA) * sqrt(normB);
    if (denom == 0) return 0;

    return dot / denom;
  }

  /// =========================
  /// SAVE MULTIPLE EMBEDDINGS
  /// =========================
  // Future<void> saveEmbeddings(List<List<double>> embeddings) async {
  //   await _storage.write(
  //     key: 'face_embeddings',
  //     value: jsonEncode(embeddings),
  //   );
  // }

  Future<void> saveSingleEmbedding(
      List<double> embedding,
      ) async {

    await _storage.write(
      key: 'face_embedding',
      value: jsonEncode(embedding),
    );
  }

  // Future<List<List<double>>?> getSavedEmbeddings() async {
  //   final data = await _storage.read(key: 'face_embeddings');
  //
  //   if (data == null) return null;
  //
  //   final decoded = jsonDecode(data) as List;
  //
  //   return decoded
  //       .map((e) => List<double>.from(e))
  //       .toList();
  // }


  Future<List<double>?> getSavedEmbedding() async {

    final data =
    await _storage.read(
      key: 'face_embedding',
    );

    if (data == null) return null;

    return List<double>.from(
      jsonDecode(data),
    );
  }
  /// =========================
  /// VERIFY FACE (HYBRID SCORING)
  /// =========================
  // Future<bool> verifyFace(List<double> currentEmbedding) async {
  //   final saved = await getSavedEmbeddings();
  //
  //   if (saved == null || saved.isEmpty) {
  //     return false;
  //   }
  //
  //   double sum = 0;
  //   double best = 0;
  //
  //   for (final emb in saved) {
  //     final score = cosineSimilarity(emb, currentEmbedding);
  //
  //     if (score > best) best = score;
  //     sum += score;
  //   }
  //
  //   final avg = sum / saved.length;
  //
  //   final finalScore = (best * 0.7) + (avg * 0.3);
  //
  //   debugPrint("BEST: $best");
  //   debugPrint("AVG: $avg");
  //   debugPrint("FINAL: $finalScore");
  //
  //   return finalScore > matchThreshold;
  // }

  /// =========================
  /// SAVE MULTIPLE EMBEDDINGS
  /// =========================
  Future<void> saveEmbeddings(
      List<List<double>> embeddings,
      ) async {

    await _storage.write(
      key: 'face_embeddings',
      value: jsonEncode(embeddings),
    );
  }

  /// =========================
  /// GET MULTIPLE EMBEDDINGS
  /// =========================
  Future<List<List<double>>?> getSavedEmbeddings() async {

    final data = await _storage.read(
      key: 'face_embeddings',
    );

    if (data == null) {
      return null;
    }

    final decoded = jsonDecode(data) as List;

    return decoded.map((e) {
      return List<double>.from(e);
    }).toList();
  }

  List<double> averageEmbeddings(
      List<List<double>> embeddings,
      ) {

    final avg = List.filled(192, 0.0);

    for (final emb in embeddings) {
      for (int i = 0; i < emb.length; i++) {
        avg[i] += emb[i];
      }
    }

    for (int i = 0; i < avg.length; i++) {
      avg[i] /= embeddings.length;
    }

    return _l2Normalize(avg);
  }

  // Future<bool> verifyFace(
  //     List<double> currentEmbedding,
  //     ) async {
  //
  //   final saved = await getSavedEmbeddings();
  //
  //   if (saved == null || saved.isEmpty) {
  //     return false;
  //   }
  //
  //   double best = 0;
  //   double sum = 0;
  //
  //   for (final emb in saved) {
  //     final sim = cosineSimilarity(
  //       emb,
  //       currentEmbedding,
  //     );
  //     debugPrint("SIM => $sim");
  //     if (sim > best) {
  //       best = sim;
  //     }
  //
  //     sum += sim;
  //
  //   }
  //
  //   final avg = sum / saved.length;
  //
  //
  //
  //   debugPrint("BEST = $best");
  //   debugPrint("AVG = $avg");
  //
  //   return best > 0.80 && avg > 0.76;
  // }
  Future<bool> verifyFace(
      List<double> currentEmbedding,
      ) async {

    final saved =
    await getSavedEmbedding();

    if (saved == null) {
      return false;
    }

    final similarity =
    cosineSimilarity(
      saved,
      currentEmbedding,
    );

    debugPrint(
      "SIMILARITY => $similarity",
    );

    return similarity > 0.84;
  }
  // Future<bool> verifyFace(
  //     List<double> currentEmbedding,
  //     ) async {
  //
  //   final saved =
  //   await getSavedEmbedding();
  //
  //   if (saved == null) {
  //     return false;
  //   }
  //
  //   final similarity =
  //   cosineSimilarity(
  //     saved,
  //     currentEmbedding,
  //   );
  //
  //   debugPrint(
  //     "SIMILARITY => $similarity",
  //   );
  //
  //   return similarity >= matchThreshold;
  // }

  /// =========================
  /// QUALITY FILTER HELPERS
  /// =========================
  bool isValidFace(Face face) {

    final leftEye = face.leftEyeOpenProbability;
    final rightEye = face.rightEyeOpenProbability;

    final widthOk =
        face.boundingBox.width >= 140;

    final heightOk =
        face.boundingBox.height >= 140;

    final headStraight =
        (face.headEulerAngleY ?? 0).abs() < 10;

    return widthOk &&
        heightOk &&
        headStraight &&
        leftEye != null &&
        rightEye != null;
  }
  /// =========================
  /// SAFETY
  /// =========================
  void _ensureInit() {
    if (!_isInitialized) {
      throw Exception("FaceRecognitionService not initialized");
    }
  }

  /// =========================
  /// DISPOSE
  /// =========================
  void dispose() {
    if (_isInitialized) {
      _interpreter.close();
      _isInitialized = false;
    }
  }
}
