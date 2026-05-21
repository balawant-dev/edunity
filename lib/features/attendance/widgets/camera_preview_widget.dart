



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

  @override
  Widget build(BuildContext context) {
    if (provider.cameraController == null ||
        !provider.cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // CAMERA PREVIEW (Fixed Mirror)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: provider.cameraController!.value.previewSize!.height,
                  height: provider.cameraController!.value.previewSize!.width,
                  child: Transform.scale(
                    scaleX: -1, // Natural mirror for front camera (Best way)
                    child: CameraPreview(provider.cameraController!),
                  ),
                ),
              ),
            ),

            // Dark Overlay
            Container(color: Colors.black.withOpacity(0.4)),

            // Face Guide Oval
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 240,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: provider.isFaceValid ? Colors.greenAccent : Colors.white,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (provider.isFaceValid ? Colors.green : Colors.black.withOpacity(0.4))
                        .withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),

            // Top Instruction
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    provider.instructionText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Capture Count
            if (showProgress)
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(30),
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

            // Progress Bar + Indicators
            if (showProgress)
              Positioned(
                bottom: 20,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    // Progress Line
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 6,
                          width: MediaQuery.of(context).size.width * 0.72 * (provider.captureCount / 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(colors: [Color(0xff00E676), Color(0xff69F0AE)]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Angle Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isActive = index < provider.captureCount;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: isActive ? const Color(0xff00E676) : Colors.white38,
                          ),
                        );
                      }),
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