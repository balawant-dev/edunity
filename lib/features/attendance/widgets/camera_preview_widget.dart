// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// import '../provider/attendance_provider.dart';
//
// class CameraPreviewWidget extends StatelessWidget {
//
//   final AttendanceProvider provider;
//
//   final bool showProgress;
//
//   const CameraPreviewWidget({
//     super.key,
//     required this.provider,
//     required this.showProgress,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     final size =
//     provider.cameraController!
//         .value
//         .previewSize!;
//
//     return Container(
//
//       height: 420,
//
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//       ),
//
//       child: Stack(
//
//         alignment: Alignment.center,
//
//         children: [
//
//           ClipRRect(
//
//             borderRadius:
//             BorderRadius.circular(30),
//
//             child: FittedBox(
//
//               fit: BoxFit.cover,
//
//               child: SizedBox(
//
//                 width: size.height,
//                 height: size.width,
//
//                 child: Transform.scale(
//
//                   scaleX: -1,
//
//                   child: CameraPreview(
//                     provider.cameraController!,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           Container(
//
//             decoration: BoxDecoration(
//
//               borderRadius:
//               BorderRadius.circular(30),
//
//               color:
//               Colors.black.withOpacity(.2),
//             ),
//           ),
//
//           ClipOval(
//
//             child: Container(
//
//               width: 260,
//               height: 340,
//
//               decoration: BoxDecoration(
//
//                 border: Border.all(
//
//                   color:
//                   provider.isFaceValid
//
//                       ? Colors.green
//
//                       : Colors.white,
//
//                   width: 4,
//                 ),
//               ),
//             ),
//           ),
//
//           if (showProgress)
//             Positioned(
//
//               bottom: 20,
//
//               child: Column(
//
//                 children: [
//
//                   Text(
//
//                     "${provider.captureCount}/20",
//
//                     style: const TextStyle(
//
//                       color: Colors.white,
//
//                       fontSize: 28,
//
//                       fontWeight:
//                       FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   SizedBox(
//
//                     width: 220,
//
//                     child:
//                     LinearProgressIndicator(
//
//                       value:
//                       provider.captureCount / 20,
//
//                       minHeight: 10,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../provider/attendance_provider.dart';

class CameraPreviewWidget
    extends StatelessWidget {

  final AttendanceProvider provider;

  final bool showProgress;

  const CameraPreviewWidget({
    super.key,
    required this.provider,
    required this.showProgress,
  });

  @override
  Widget build(BuildContext context) {

    if (provider.cameraController == null ||
        !provider
            .cameraController!
            .value
            .isInitialized) {

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final size =
    provider.cameraController!
        .value
        .previewSize!;

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),

      decoration: BoxDecoration(

        borderRadius:
        BorderRadius.circular(30),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(.15),

            blurRadius: 20,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: ClipRRect(

        borderRadius:
        BorderRadius.circular(30),

        child: Stack(

          alignment: Alignment.center,

          children: [

            /// CAMERA

            SizedBox.expand(

              child: FittedBox(

                fit: BoxFit.cover,

                child: SizedBox(

                  width: size.height,

                  height: size.width,

                  child: Transform(

                    alignment: Alignment.center,

                    transform:
                    Matrix4.rotationY(3.14159),

                    child: CameraPreview(
                      provider.cameraController!,
                    ),
                  ),
                ),
              ),
            ),

            /// DARK OVERLAY

            Container(
              color: Colors.black.withOpacity(.35),
            ),

            /// FACE AREA

            AnimatedContainer(

              duration:
              const Duration(
                milliseconds: 250,
              ),

              width: 230,
              height: 300,
              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.circular(200),

                border: Border.all(

                  color:
                  provider.isFaceValid

                      ? Colors.greenAccent

                      : Colors.white,

                  width: 4,
                ),

                // boxShadow: [
                //
                //   BoxShadow(
                //
                //     color:
                //     provider.isFaceValid
                //
                //         ? Colors.greenAccent
                //         .withOpacity(.5)
                //
                //         : Colors.white
                //         .withOpacity(.3),
                //
                //     blurRadius: 18,
                //   ),
                // ],
              ),
            ),

            /// TOP TEXT

            Positioned(

              top: 5,

              child: Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(

                  color: Colors.black54,

                  borderRadius:
                  BorderRadius.circular(30),
                ),

                child: Text(

                  provider.instructionText,

                  style: const TextStyle(

                    color: Colors.white,

                    fontWeight:
                    FontWeight.w600,

                    fontSize: 14,
                  ),
                ),
              ),
            ),          if (showProgress)  Positioned(

              right: 5,
              top: 5,

              child: Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),

                decoration: BoxDecoration(

                  color: Colors.black54,

                  borderRadius:
                  BorderRadius.circular(30),
                ),

                child: Text(

                  "${provider.captureCount}/20",

                  style: const TextStyle(

                    color: Colors.white,

                    fontWeight:
                    FontWeight.w600,

                    fontSize: 14,
                  ),
                ),
              ),
            ),

            /// PROGRESS

            /// PROGRESS

            if (showProgress)
            /// SCAN STATUS

              // if (showProgress)

                Positioned(

                  bottom: 5,
                  left: 24,
                  right: 24,

                  child: Column(

                    children: [

                      /// PROGRESS TEXT

                      // Row(
                      //
                      //   mainAxisAlignment:
                      //   MainAxisAlignment.spaceBetween,
                      //
                      //   children: [
                      //
                      //     Text(
                      //
                      //       provider.instructionText,
                      //
                      //       style: TextStyle(
                      //
                      //         color: Colors.white.withOpacity(.95),
                      //
                      //         fontSize: 14,
                      //
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //
                      //     Text(
                      //
                      //       "${provider.captureCount}/20",
                      //
                      //       style: const TextStyle(
                      //
                      //         color: Colors.white,
                      //
                      //         fontSize: 15,
                      //
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 14),

                      /// PROGRESS LINE

                      Stack(

                        children: [

                          /// BG LINE

                          Container(

                            height: 5,

                            decoration: BoxDecoration(

                              color: Colors.white.withOpacity(.15),

                              borderRadius:
                              BorderRadius.circular(100),
                            ),
                          ),

                          /// ACTIVE LINE

                          AnimatedContainer(

                            duration:
                            const Duration(milliseconds: 250),

                            height: 5,

                            width:
                            MediaQuery.of(context)
                                .size
                                .width *
                                0.75 *
                                (provider.captureCount / 20),

                            decoration: BoxDecoration(

                              borderRadius:
                              BorderRadius.circular(100),

                              gradient: const LinearGradient(

                                colors: [

                                  Color(0xff00E676),
                                  Color(0xff69F0AE),
                                ],
                              ),

                              boxShadow: [

                                BoxShadow(

                                  color: Color(0xff00E676)
                                      .withOpacity(.45),

                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// MINI SCAN INDICATORS

                      SizedBox(

                        height: 10,

                        child: ListView.separated(

                          shrinkWrap: true,

                          scrollDirection: Axis.horizontal,

                          itemBuilder: (_, index) {

                            final active =
                                index <
                                    provider.captureCount;

                            return AnimatedContainer(

                              duration:
                              const Duration(milliseconds: 250),

                              width: active ? 22 : 8,

                              height: 8,

                              decoration: BoxDecoration(

                                borderRadius:
                                BorderRadius.circular(100),

                                color: active

                                    ? const Color(0xff00E676)

                                    : Colors.white24,
                              ),
                            );
                          },

                          separatorBuilder:
                              (_, __) =>
                          const SizedBox(width: 6),

                          itemCount: 20,
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}