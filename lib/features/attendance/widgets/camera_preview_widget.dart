import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../provider/attendance_provider.dart';

class CameraPreviewWidget extends StatelessWidget {
  final AttendanceProvider provider;
  final bool showProgress;

  const CameraPreviewWidget({
    super.key,
    required this.provider,
    required this.showProgress,
  });

  Color getBorderColor() {
    if (provider.isFaceValid) {
      return Colors.greenAccent;
    }

    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    if (provider.cameraController == null ||
        !provider.cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.25,
            ),
            blurRadius: 30,
            offset: const Offset(
              0,
              15,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          30,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// =======================
            /// CAMERA
            /// =======================

            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: provider.cameraController!.value.previewSize!.height,
                  height: provider.cameraController!.value.previewSize!.width,
                  child: Transform.scale(
                    scaleX: -1,
                    child: CameraPreview(
                      provider.cameraController!,
                    ),
                  ),
                ),
              ),
            ),

            /// =======================
            /// DARK MASK
            /// =======================

            Container(
              color: Colors.black.withOpacity(
                0.18,
              ),
            ),

            /// =======================
            /// FACE OVAL
            /// =======================

            AnimatedContainer(
              duration: const Duration(
                milliseconds: 250,
              ),
              width: 250,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  999,
                ),
                border: Border.all(
                  color: getBorderColor(),
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: getBorderColor().withOpacity(
                      0.35,
                    ),
                    blurRadius: 25,
                  ),
                ],
              ),
            ),

            /// =======================
            /// MAIN INSTRUCTION
            /// =======================

            Positioned(
              top: 16,
              left: 12,
              right: 12,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  child: Text(
                    provider.instructionText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            /// =======================
            /// LIVENESS
            /// =======================

            if (provider.livenessInstruction.isNotEmpty)
              Positioned(
                top: 75,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    provider.livenessInstruction,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            /// =======================
            /// BRIGHTNESS
            /// =======================

            // Positioned(
            //   left: 16,
            //   bottom: 120,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 14,
            //       vertical: 8,
            //     ),
            //     decoration: BoxDecoration(
            //       color: Colors.black87,
            //       borderRadius: BorderRadius.circular(
            //         20,
            //       ),
            //     ),
            //     child: Text(
            //       "Light ${provider.latestBrightness.toStringAsFixed(0)}",
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 12,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),

            /// =======================
            /// PROGRESS
            /// =======================

            if (showProgress)
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  child: Text(
                    "${provider.captureCount}/5",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            /// =======================
            /// PROGRESS BAR
            /// =======================

            if (showProgress)
              Positioned(
                bottom: 22,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 250,
                          ),
                          height: 6,
                          width: MediaQuery.of(context).size.width *
                              0.72 *
                              (provider.captureCount / 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff00E676),
                                Color(0xff69F0AE),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) {
                          final active = index < provider.captureCount;

                          return AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 220,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            width: active ? 28 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                100,
                              ),
                              color: active
                                  ? const Color(0xff00E676)
                                  : Colors.white38,
                            ),
                          );
                        },
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
