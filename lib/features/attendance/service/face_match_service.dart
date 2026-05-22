// import 'dart:io';
// import 'dart:math';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';
//
// class FaceMatchService {
//
//   Interpreter? interpreter;
//
//   bool isModelLoaded = false;
//
//   Future<void> loadModel() async {
//
//     if (isModelLoaded) return;
//
//     interpreter = await Interpreter.fromAsset(
//       'assets/models/mobile_face_net.tflite',
//     );
//
//     isModelLoaded = true;
//   }
//
//   Future<List<double>> getEmbedding(
//       File imageFile,
//       ) async {
//
//     if (interpreter == null) {
//       throw Exception("Model not loaded");
//     }
//
//     final bytes = await imageFile.readAsBytes();
//
//     img.Image? image = img.decodeImage(bytes);
//
//     image = img.copyResize(
//       image!,
//       width: 112,
//       height: 112,
//     );
//
//     var input = List.generate(
//       1,
//           (_) => List.generate(
//         112,
//             (_) => List.generate(
//           112,
//               (_) => List.filled(3, 0.0),
//         ),
//       ),
//     );
//
//     for (int y = 0; y < 112; y++) {
//       for (int x = 0; x < 112; x++) {
//
//         final pixel = image.getPixel(x, y);
//
//         input[0][y][x][0] =
//             (pixel.r - 128) / 128;
//
//         input[0][y][x][1] =
//             (pixel.g - 128) / 128;
//
//         input[0][y][x][2] =
//             (pixel.b - 128) / 128;
//       }
//     }
//
//     var output = List.generate(
//       1,
//           (_) => List.filled(192, 0.0),
//     );
//
//     interpreter!.run(input, output);
//
//     return output[0];
//   }
//
//   double cosineSimilarity(
//       List<double> e1,
//       List<double> e2,
//       ) {
//
//     double dot = 0;
//
//     double norm1 = 0;
//
//     double norm2 = 0;
//
//     for (int i = 0; i < e1.length; i++) {
//
//       dot += e1[i] * e2[i];
//
//       norm1 += e1[i] * e1[i];
//
//       norm2 += e2[i] * e2[i];
//     }
//
//     return dot /
//         (sqrt(norm1) * sqrt(norm2));
//   }
//
//   Future<bool> matchFaces(
//       File capturedImage,
//       List<File> registeredImages,
//       ) async {
//
//     final capturedEmbedding =
//     await getEmbedding(capturedImage);
//
//     for (final image in registeredImages) {
//
//       final embedding =
//       await getEmbedding(image);
//
//       final similarity =
//       cosineSimilarity(
//         capturedEmbedding,
//         embedding,
//       );
//
//       print(
//           "FACE SIMILARITY => $similarity");
//
//       /// 0.70-0.80 good range
//       if (similarity > 0.75) {
//         return true;
//       }
//     }
//
//     return false;
//   }
// }