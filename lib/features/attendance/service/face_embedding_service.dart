// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';
//
// class FaceEmbeddingService {
//   static final FaceEmbeddingService _instance =
//   FaceEmbeddingService._internal();
//
//   factory FaceEmbeddingService() => _instance;
//
//   FaceEmbeddingService._internal();
//
//   Interpreter? _interpreter;
//
//   Future<void> loadModel() async {
//     _interpreter ??=
//     await Interpreter.fromAsset('assets/models/mobilefacenet.tflite');
//   }
//
//   Future<List<double>> getEmbedding(img.Image image) async {
//     final resized = img.copyResize(image, width: 112, height: 112);
//
//     var input = List.generate(
//       1,
//           (_) => List.generate(
//         112,
//             (y) => List.generate(
//           112,
//               (x) {
//             final pixel = resized.getPixel(x, y);
//
//             return [
//               (pixel.r - 128) / 128,
//               (pixel.g - 128) / 128,
//               (pixel.b - 128) / 128,
//             ];
//           },
//         ),
//       ),
//     );
//
//     var output = List.generate(1, (_) => List.filled(192, 0.0));
//
//     _interpreter!.run(input, output);
//
//     return List<double>.from(output.first);
//   }
// }