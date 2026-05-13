import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../provider/attendance_provider.dart';

class FaceAttendanceScreen
    extends StatefulWidget {

  const FaceAttendanceScreen({
    super.key,
  });

  @override
  State<FaceAttendanceScreen>
  createState() =>
      _FaceAttendanceScreenState();
}

class _FaceAttendanceScreenState
    extends State<FaceAttendanceScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      context
          .read<AttendanceProvider>()
          .initialize();
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      const Color(0xff0D1117),

      body:
      Consumer<AttendanceProvider>(

        builder: (_, provider, __) {

          if (provider.isLoading) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (provider.cameraController ==
              null ||
              !provider.cameraController!
                  .value.isInitialized) {

            return const Center(
              child: Text(
                "Initializing Camera...",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final faceStatus =
              provider.faceStatusModel;

          final attendance =
              provider.todayAttendanceModel;

          final summary =
              attendance
                  ?.attendanceSummary;
          final registrationStatus =
              faceStatus?.registrationStatus ?? "none";

          final bool showRegistrationFlow =
              registrationStatus == "none" ||
                  registrationStatus == "rejected";
          return SafeArea(

            child: Column(

              children: [

                /// =========================
                /// APP BAR
                /// =========================

                Padding(
                  padding:
                  const EdgeInsets.all(16),

                  child: Row(

                    children: [

                      Container(

                        height: 45,
                        width: 45,

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.white10,

                          borderRadius:
                          BorderRadius.circular(
                              14),
                        ),

                        child:  Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(
                              "Face Attendance",
                              style: TextStyle(
                                color:
                                Colors.white,
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 2),

                            Text(
                              "AI Powered Smart Verification",
                              style: TextStyle(
                                color:
                                Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if(showRegistrationFlow)

                  Container(

                    margin: const EdgeInsets.symmetric(horizontal: 20),

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(

                      color: Colors.white10,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(

                      children: [

                        Row(

                          children: [

                            provider.primaryImage != null

                                ? ClipRRect(

                              borderRadius: BorderRadius.circular(16),

                              child: Image.file(

                                provider.primaryImage!,

                                width: 70,
                                height: 70,

                                fit: BoxFit.cover,
                              ),
                            )

                                : Container(

                              width: 70,
                              height: 70,

                              decoration: BoxDecoration(

                                color: Colors.white12,

                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),

                            const SizedBox(width: 14),

                            const Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    "Primary Face Image",

                                    style: TextStyle(

                                      color: Colors.white,

                                      fontSize: 16,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(

                                    "Upload one clear face image",

                                    style: TextStyle(

                                      color: Colors.white70,

                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Row(

                          children: [

                            Expanded(

                              child: ElevatedButton.icon(

                                onPressed: () {

                                  provider.capturePrimaryImage();
                                },

                                icon: const Icon(Icons.camera_alt),

                                label: const Text("Camera"),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(

                              child: ElevatedButton.icon(

                                onPressed: () {

                                  provider
                                      .pickPrimaryImageFromGallery();
                                },

                                icon: const Icon(Icons.photo),

                                label: const Text("Gallery"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                /// =========================
                /// CAMERA PREVIEW
                /// =========================

                Expanded(

                  child: Stack(

                    alignment: Alignment.center,

                    children: [

                      /// CAMERA
                      ClipRRect(

                        borderRadius:
                        BorderRadius.circular(30),

                        child: LayoutBuilder(

                          builder: (context, constraints) {

                            final size =
                            provider.cameraController!
                                .value.previewSize!;

                            return FittedBox(

                              fit: BoxFit.cover,

                              child: SizedBox(

                                width: size.height,
                                height: size.width,

                                child: Transform.scale(

                                  scaleX: -1,

                                  child: CameraPreview(
                                    provider.cameraController!,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      /// DARK OVERLAY
                      Container(

                        decoration:
                        BoxDecoration(

                          borderRadius:
                          BorderRadius.circular(
                              30),

                          color: Colors.black
                              .withOpacity(0.25),
                        ),
                      ),

                      /// FACE BORDER

                      ClipOval(

                        child: Container(

                          width: 260,
                          height: 340,

                          decoration:
                          BoxDecoration(

                            border: Border.all(

                              color:
                              provider.isFaceValid
                                  ? Colors.greenAccent
                                  : Colors.white,

                              width: 4,
                            ),
                          ),
                        ),
                      ),
                      /// SCAN ANIMATION
                      Positioned(

                        child: AnimatedContainer(

                          duration:
                          const Duration(
                              milliseconds: 500),

                          width: 250,

                          height:
                          provider.isCapturing
                              ? 4
                              : 0,

                          decoration:
                          BoxDecoration(

                            color:
                            Colors.greenAccent,

                            borderRadius:
                            BorderRadius.circular(
                                20),
                          ),
                        ),
                      ),

                      /// PROGRESS
                      Positioned(

                        bottom: 20,

                        child: Column(

                          children: [

                            Text(

                              "${provider.captureCount}/20",

                              style:
                              const TextStyle(

                                color:
                                Colors.white,

                                fontWeight:
                                FontWeight.bold,

                                fontSize: 26,
                              ),
                            ),

                            const SizedBox(
                                height: 6),

                            SizedBox(

                              width: 220,

                              child:
                              LinearProgressIndicator(

                                value:
                                provider
                                    .captureCount /
                                    20,

                                minHeight: 10,

                                borderRadius:
                                BorderRadius.circular(
                                    20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// =========================
                /// INSTRUCTION
                /// =========================

                Container(

                  margin:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  padding:
                  const EdgeInsets.all(16),

                  decoration:
                  BoxDecoration(

                    color: Colors.white10,

                    borderRadius:
                    BorderRadius.circular(
                        18),
                  ),

                  child: Row(

                    children: [

                      const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 12),

                      Expanded(

                        child: Text(

                          provider.instructionText,

                          style:
                          const TextStyle(

                            color:
                            Colors.white,

                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// =========================
                /// STATUS CARD
                /// =========================

                Container(

                  margin:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  padding:
                  const EdgeInsets.all(18),

                  decoration:
                  BoxDecoration(

                    gradient:
                    const LinearGradient(

                      colors: [
                        Color(0xff1F2937),
                        Color(0xff111827),
                      ],
                    ),

                    borderRadius:
                    BorderRadius.circular(
                        24),
                  ),

                  child: Column(

                    children: [

                      Row(

                        children: [

                          Expanded(

                            child:
                            _statusItem(

                              title:
                              "Registration",

                              value:
                              faceStatus
                                  ?.registrationStatus ??
                                  "none",
                            ),
                          ),

                          Expanded(

                            child:
                            _statusItem(

                              title:
                              "Attendance",

                              value:
                              summary?.status ??
                                  "--",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(

                        children: [

                          Expanded(

                            child:
                            _statusItem(

                              title:
                              "Punches",

                              value:
                              summary
                                  ?.totalPunches
                                  .toString() ??
                                  "0",
                            ),
                          ),

                          Expanded(

                            child:
                            _statusItem(

                              title:
                              "User Type",

                              value:
                              attendance
                                  ?.userType ??
                                  "--",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// =========================
                /// ACTION BUTTON
                /// =========================

                Padding(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: SizedBox(

                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton(

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.greenAccent,

                        foregroundColor:
                        Colors.black,

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),


                      onPressed: () async {

                        final status =
                            faceStatus?.registrationStatus ?? "none";

                        /// ============================================================
                        /// REGISTRATION FLOW
                        /// ============================================================

                        if (status == "none" ||
                            status == "rejected") {

                          if (provider.primaryImage == null) {

                            ScaffoldMessenger.of(context).showSnackBar(

                              const SnackBar(

                                content: Text(
                                  "Please select primary image",
                                ),
                              ),
                            );

                            return;
                          }

                          await provider.startAutoCapture();

                          return;
                        }

                        /// ============================================================
                        /// PENDING FLOW
                        /// ============================================================

                        if (status == "pending") {

                          ScaffoldMessenger.of(context).showSnackBar(

                            const SnackBar(

                              content: Text(
                                "Please wait for admin approval",
                              ),
                            ),
                          );

                          return;
                        }

                        /// ============================================================
                        /// APPROVED FLOW
                        /// ============================================================

                        if (status == "approved") {

                          final location =
                              attendance?.assignment?.locations.first;

                          if (location == null) return;

                          await provider.capturePunchImage();

                          await provider.punchAttendance(

                            locationId: location.locationId,
                          );

                          if (context.mounted) {

                            ScaffoldMessenger.of(context).showSnackBar(

                              SnackBar(

                                content: Text(

                                  provider.punchResponseModel?.message ??
                                      "",
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child:
                      provider.isCapturing
                          ? Row(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          const SizedBox(

                            height: 20,
                            width: 20,

                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Text(
                            "Capturing ${provider.captureCount}/20",
                          ),
                        ],
                      )

                          : provider.isRegistering

                          ? const SizedBox(

                        height: 22,
                        width: 22,

                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )

                          : Text(

                        faceStatus
                            ?.registrationStatus ==
                            "none"

                            ? "Register Face"

                            : faceStatus
                            ?.registrationStatus ==
                            "pending"

                            ? "Verification Pending"

                            : "Punch Attendance",

                        style: const TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusItem({
    required String title,
    required String value,
  }) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          title,

          style: const TextStyle(

            color: Colors.white54,

            fontSize: 12,
          ),
        ),

        const SizedBox(height: 6),

        Text(

          value,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 16,

            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}