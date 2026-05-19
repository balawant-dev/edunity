// // import 'dart:io';
// //
// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../provider/attendance_provider.dart';
// //
// // class FaceAttendanceScreen
// //     extends StatefulWidget {
// //
// //   const FaceAttendanceScreen({
// //     super.key,
// //   });
// //
// //   @override
// //   State<FaceAttendanceScreen>
// //   createState() =>
// //       _FaceAttendanceScreenState();
// // }
// //
// // class _FaceAttendanceScreenState
// //     extends State<FaceAttendanceScreen> {
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     Future.microtask(() {
// //
// //       context
// //           .read<AttendanceProvider>()
// //           .initialize();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //
// //     return Scaffold(
// //
// //       backgroundColor:
// //       const Color(0xff0D1117),
// //
// //       body:
// //       Consumer<AttendanceProvider>(
// //
// //         builder: (_, provider, __) {
// //
// //           if (provider.isLoading) {
// //
// //             return const Center(
// //               child:
// //               CircularProgressIndicator(),
// //             );
// //           }
// //
// //           if (provider.cameraController ==
// //               null ||
// //               !provider.cameraController!
// //                   .value.isInitialized) {
// //
// //             return const Center(
// //               child: Text(
// //                 "Initializing Camera...",
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             );
// //           }
// //
// //           final faceStatus =
// //               provider.faceStatusModel;
// //
// //           final attendance =
// //               provider.todayAttendanceModel;
// //
// //           final summary =
// //               attendance
// //                   ?.attendanceSummary;
// //           final registrationStatus =
// //               faceStatus?.registrationStatus ?? "none";
// //
// //           final bool showRegistrationFlow =
// //               registrationStatus == "none" ||
// //                   registrationStatus == "rejected";
// //           return SafeArea(
// //
// //             child: Column(
// //
// //               children: [
// //
// //                 /// =========================
// //                 /// APP BAR
// //                 /// =========================
// //
// //                 Padding(
// //                   padding:
// //                   const EdgeInsets.all(16),
// //
// //                   child: Row(
// //
// //                     children: [
// //
// //                       Container(
// //
// //                         height: 45,
// //                         width: 45,
// //
// //                         decoration:
// //                         BoxDecoration(
// //
// //                           color:
// //                           Colors.white10,
// //
// //                           borderRadius:
// //                           BorderRadius.circular(
// //                               14),
// //                         ),
// //
// //                         child:  Icon(
// //                           Icons.lock,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //
// //                       const SizedBox(width: 14),
// //
// //                       const Expanded(
// //                         child: Column(
// //
// //                           crossAxisAlignment:
// //                           CrossAxisAlignment
// //                               .start,
// //
// //                           children: [
// //
// //                             Text(
// //                               "Face Attendance",
// //                               style: TextStyle(
// //                                 color:
// //                                 Colors.white,
// //                                 fontSize: 20,
// //                                 fontWeight:
// //                                 FontWeight.bold,
// //                               ),
// //                             ),
// //
// //                             SizedBox(height: 2),
// //
// //                             Text(
// //                               "AI Powered Smart Verification",
// //                               style: TextStyle(
// //                                 color:
// //                                 Colors.white70,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 if(showRegistrationFlow)
// //
// //                   Container(
// //
// //                     margin: const EdgeInsets.symmetric(horizontal: 20),
// //
// //                     padding: const EdgeInsets.all(14),
// //
// //                     decoration: BoxDecoration(
// //
// //                       color: Colors.white10,
// //
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //
// //                     child: Column(
// //
// //                       children: [
// //
// //                         Row(
// //
// //                           children: [
// //
// //                             provider.primaryImage != null
// //
// //                                 ? ClipRRect(
// //
// //                               borderRadius: BorderRadius.circular(16),
// //
// //                               child: Image.file(
// //
// //                                 provider.primaryImage!,
// //
// //                                 width: 70,
// //                                 height: 70,
// //
// //                                 fit: BoxFit.cover,
// //                               ),
// //                             )
// //
// //                                 : Container(
// //
// //                               width: 70,
// //                               height: 70,
// //
// //                               decoration: BoxDecoration(
// //
// //                                 color: Colors.white12,
// //
// //                                 borderRadius: BorderRadius.circular(16),
// //                               ),
// //
// //                               child: const Icon(
// //                                 Icons.person,
// //                                 color: Colors.white,
// //                                 size: 40,
// //                               ),
// //                             ),
// //
// //                             const SizedBox(width: 14),
// //
// //                             const Expanded(
// //
// //                               child: Column(
// //
// //                                 crossAxisAlignment:
// //                                 CrossAxisAlignment.start,
// //
// //                                 children: [
// //
// //                                   Text(
// //
// //                                     "Primary Face Image",
// //
// //                                     style: TextStyle(
// //
// //                                       color: Colors.white,
// //
// //                                       fontSize: 16,
// //
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //
// //                                   SizedBox(height: 4),
// //
// //                                   Text(
// //
// //                                     "Upload one clear face image",
// //
// //                                     style: TextStyle(
// //
// //                                       color: Colors.white70,
// //
// //                                       fontSize: 12,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //
// //                         const SizedBox(height: 14),
// //
// //                         Row(
// //
// //                           children: [
// //
// //                             Expanded(
// //
// //                               child: ElevatedButton.icon(
// //
// //                                 onPressed: () {
// //
// //                                   provider.capturePrimaryImage();
// //                                 },
// //
// //                                 icon: const Icon(Icons.camera_alt),
// //
// //                                 label: const Text("Camera"),
// //                               ),
// //                             ),
// //
// //                             const SizedBox(width: 12),
// //
// //                             Expanded(
// //
// //                               child: ElevatedButton.icon(
// //
// //                                 onPressed: () {
// //
// //                                   provider
// //                                       .pickPrimaryImageFromGallery();
// //                                 },
// //
// //                                 icon: const Icon(Icons.photo),
// //
// //                                 label: const Text("Gallery"),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //
// //                 /// =========================
// //                 /// CAMERA PREVIEW
// //                 /// =========================
// //
// //                 Expanded(
// //
// //                   child: Stack(
// //
// //                     alignment: Alignment.center,
// //
// //                     children: [
// //
// //                       /// CAMERA
// //                       ClipRRect(
// //
// //                         borderRadius:
// //                         BorderRadius.circular(30),
// //
// //                         child: LayoutBuilder(
// //
// //                           builder: (context, constraints) {
// //
// //                             final size =
// //                             provider.cameraController!
// //                                 .value.previewSize!;
// //
// //                             return FittedBox(
// //
// //                               fit: BoxFit.cover,
// //
// //                               child: SizedBox(
// //
// //                                 width: size.height,
// //                                 height: size.width,
// //
// //                                 child: Transform.scale(
// //
// //                                   scaleX: -1,
// //
// //                                   child: CameraPreview(
// //                                     provider.cameraController!,
// //                                   ),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //
// //                       /// DARK OVERLAY
// //                       Container(
// //
// //                         decoration:
// //                         BoxDecoration(
// //
// //                           borderRadius:
// //                           BorderRadius.circular(
// //                               30),
// //
// //                           color: Colors.black
// //                               .withOpacity(0.25),
// //                         ),
// //                       ),
// //
// //                       /// FACE BORDER
// //
// //                       ClipOval(
// //
// //                         child: Container(
// //
// //                           width: 260,
// //                           height: 340,
// //
// //                           decoration:
// //                           BoxDecoration(
// //
// //                             border: Border.all(
// //
// //                               color:
// //                               provider.isFaceValid
// //                                   ? Colors.greenAccent
// //                                   : Colors.white,
// //
// //                               width: 4,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       /// SCAN ANIMATION
// //                       Positioned(
// //
// //                         child: AnimatedContainer(
// //
// //                           duration:
// //                           const Duration(
// //                               milliseconds: 500),
// //
// //                           width: 250,
// //
// //                           height:
// //                           provider.isCapturing
// //                               ? 4
// //                               : 0,
// //
// //                           decoration:
// //                           BoxDecoration(
// //
// //                             color:
// //                             Colors.greenAccent,
// //
// //                             borderRadius:
// //                             BorderRadius.circular(
// //                                 20),
// //                           ),
// //                         ),
// //                       ),
// //
// //                       /// PROGRESS
// //                       Positioned(
// //
// //                         bottom: 20,
// //
// //                         child: Column(
// //
// //                           children: [
// //
// //                             Text(
// //
// //                               "${provider.captureCount}/20",
// //
// //                               style:
// //                               const TextStyle(
// //
// //                                 color:
// //                                 Colors.white,
// //
// //                                 fontWeight:
// //                                 FontWeight.bold,
// //
// //                                 fontSize: 26,
// //                               ),
// //                             ),
// //
// //                             const SizedBox(
// //                                 height: 6),
// //
// //                             SizedBox(
// //
// //                               width: 220,
// //
// //                               child:
// //                               LinearProgressIndicator(
// //
// //                                 value:
// //                                 provider
// //                                     .captureCount /
// //                                     20,
// //
// //                                 minHeight: 10,
// //
// //                                 borderRadius:
// //                                 BorderRadius.circular(
// //                                     20),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 20),
// //
// //                 /// =========================
// //                 /// INSTRUCTION
// //                 /// =========================
// //
// //                 Container(
// //
// //                   margin:
// //                   const EdgeInsets.symmetric(
// //                     horizontal: 20,
// //                   ),
// //
// //                   padding:
// //                   const EdgeInsets.all(16),
// //
// //                   decoration:
// //                   BoxDecoration(
// //
// //                     color: Colors.white10,
// //
// //                     borderRadius:
// //                     BorderRadius.circular(
// //                         18),
// //                   ),
// //
// //                   child: Row(
// //
// //                     children: [
// //
// //                       const Icon(
// //                         Icons.info_outline,
// //                         color: Colors.white,
// //                       ),
// //
// //                       const SizedBox(width: 12),
// //
// //                       Expanded(
// //
// //                         child: Text(
// //
// //                           provider.instructionText,
// //
// //                           style:
// //                           const TextStyle(
// //
// //                             color:
// //                             Colors.white,
// //
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 20),
// //
// //                 /// =========================
// //                 /// STATUS CARD
// //                 /// =========================
// //
// //                 Container(
// //
// //                   margin:
// //                   const EdgeInsets.symmetric(
// //                     horizontal: 20,
// //                   ),
// //
// //                   padding:
// //                   const EdgeInsets.all(18),
// //
// //                   decoration:
// //                   BoxDecoration(
// //
// //                     gradient:
// //                     const LinearGradient(
// //
// //                       colors: [
// //                         Color(0xff1F2937),
// //                         Color(0xff111827),
// //                       ],
// //                     ),
// //
// //                     borderRadius:
// //                     BorderRadius.circular(
// //                         24),
// //                   ),
// //
// //                   child: Column(
// //
// //                     children: [
// //
// //                       Row(
// //
// //                         children: [
// //
// //                           Expanded(
// //
// //                             child:
// //                             _statusItem(
// //
// //                               title:
// //                               "Registration",
// //
// //                               value:
// //                               faceStatus
// //                                   ?.registrationStatus ??
// //                                   "none",
// //                             ),
// //                           ),
// //
// //                           Expanded(
// //
// //                             child:
// //                             _statusItem(
// //
// //                               title:
// //                               "Attendance",
// //
// //                               value:
// //                               summary?.status ??
// //                                   "--",
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //
// //                       const SizedBox(height: 16),
// //
// //                       Row(
// //
// //                         children: [
// //
// //                           Expanded(
// //
// //                             child:
// //                             _statusItem(
// //
// //                               title:
// //                               "Punches",
// //
// //                               value:
// //                               summary
// //                                   ?.totalPunches
// //                                   .toString() ??
// //                                   "0",
// //                             ),
// //                           ),
// //
// //                           Expanded(
// //
// //                             child:
// //                             _statusItem(
// //
// //                               title:
// //                               "User Type",
// //
// //                               value:
// //                               attendance
// //                                   ?.userType ??
// //                                   "--",
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 24),
// //
// //                 /// =========================
// //                 /// ACTION BUTTON
// //                 /// =========================
// //
// //                 Padding(
// //
// //                   padding:
// //                   const EdgeInsets.symmetric(
// //                     horizontal: 20,
// //                   ),
// //
// //                   child: SizedBox(
// //
// //                     width: double.infinity,
// //
// //                     height: 58,
// //
// //                     child: ElevatedButton(
// //
// //                       style:
// //                       ElevatedButton.styleFrom(
// //
// //                         backgroundColor:
// //                         Colors.greenAccent,
// //
// //                         foregroundColor:
// //                         Colors.black,
// //
// //                         shape:
// //                         RoundedRectangleBorder(
// //
// //                           borderRadius:
// //                           BorderRadius.circular(20),
// //                         ),
// //                       ),
// //
// //
// //                       onPressed: () async {
// //
// //                         final status =
// //                             faceStatus?.registrationStatus ?? "none";
// //
// //                         /// ============================================================
// //                         /// REGISTRATION FLOW
// //                         /// ============================================================
// //
// //                         if (status == "none" ||
// //                             status == "rejected") {
// //
// //                           if (provider.primaryImage == null) {
// //
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //
// //                               const SnackBar(
// //
// //                                 content: Text(
// //                                   "Please select primary image",
// //                                 ),
// //                               ),
// //                             );
// //
// //                             return;
// //                           }
// //
// //                           await provider.startAutoCapture();
// //
// //                           return;
// //                         }
// //
// //                         /// ============================================================
// //                         /// PENDING FLOW
// //                         /// ============================================================
// //
// //                         if (status == "pending") {
// //
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //
// //                             const SnackBar(
// //
// //                               content: Text(
// //                                 "Please wait for admin approval",
// //                               ),
// //                             ),
// //                           );
// //
// //                           return;
// //                         }
// //
// //                         /// ============================================================
// //                         /// APPROVED FLOW
// //                         /// ============================================================
// //
// //                         if (status == "approved") {
// //
// //                           final location =
// //                               attendance?.assignment?.locations.first;
// //
// //                           if (location == null) return;
// //
// //                           await provider.capturePunchImage();
// //
// //                           await provider.punchAttendance(
// //
// //                             locationId: location.locationId,
// //                           );
// //
// //                           if (context.mounted) {
// //
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //
// //                               SnackBar(
// //
// //                                 content: Text(
// //
// //                                   provider.punchResponseModel?.message ??
// //                                       "",
// //                                 ),
// //                               ),
// //                             );
// //                           }
// //                         }
// //                       },
// //                       child:
// //                       provider.isCapturing
// //                           ? Row(
// //
// //                         mainAxisAlignment:
// //                         MainAxisAlignment.center,
// //
// //                         children: [
// //
// //                           const SizedBox(
// //
// //                             height: 20,
// //                             width: 20,
// //
// //                             child:
// //                             CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                             ),
// //                           ),
// //
// //                           const SizedBox(width: 12),
// //
// //                           Text(
// //                             "Capturing ${provider.captureCount}/20",
// //                           ),
// //                         ],
// //                       )
// //
// //                           : provider.isRegistering
// //
// //                           ? const SizedBox(
// //
// //                         height: 22,
// //                         width: 22,
// //
// //                         child:
// //                         CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                         ),
// //                       )
// //
// //                           : Text(
// //
// //                         faceStatus
// //                             ?.registrationStatus ==
// //                             "none"
// //
// //                             ? "Register Face"
// //
// //                             : faceStatus
// //                             ?.registrationStatus ==
// //                             "pending"
// //
// //                             ? "Verification Pending"
// //
// //                             : "Punch Attendance",
// //
// //                         style: const TextStyle(
// //
// //                           fontWeight:
// //                           FontWeight.bold,
// //
// //                           fontSize: 18,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _statusItem({
// //     required String title,
// //     required String value,
// //   }) {
// //
// //     return Column(
// //
// //       crossAxisAlignment:
// //       CrossAxisAlignment.start,
// //
// //       children: [
// //
// //         Text(
// //
// //           title,
// //
// //           style: const TextStyle(
// //
// //             color: Colors.white54,
// //
// //             fontSize: 12,
// //           ),
// //         ),
// //
// //         const SizedBox(height: 6),
// //
// //         Text(
// //
// //           value,
// //
// //           style: const TextStyle(
// //
// //             color: Colors.white,
// //
// //             fontSize: 16,
// //
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
//
// import 'package:camera/camera.dart';
// import 'package:edunity/common/widgets/custom_appbar.dart';
// import 'package:edunity/core/constants/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
//
// import '../../../core/constants/app_images.dart';
// import '../../../core/routes/app_routes.dart';
// import '../provider/attendance_provider.dart';
//
// class FaceAttendanceScreen extends StatefulWidget {
//   const FaceAttendanceScreen({super.key});
//
//   @override
//   State<FaceAttendanceScreen> createState() =>
//       _FaceAttendanceScreenState();
// }
//
// class _FaceAttendanceScreenState
//     extends State<FaceAttendanceScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.microtask(() {
//       context
//           .read<AttendanceProvider>()
//           .initialize();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       backgroundColor: AppColors.white,
//       appBar: CustomAppBar(title:  "Face Attendance"),
//
//       body: Consumer<AttendanceProvider>(
//
//         builder: (_, provider, __) {
//
//           if (provider.isLoading) {
//
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           if (provider.cameraController == null ||
//               !provider.cameraController!
//                   .value
//                   .isInitialized) {
//
//             return const Center(
//
//               child: Text(
//
//                 "Initializing Camera...",
//
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             );
//           }
//
//           final faceStatus =
//               provider.faceStatusModel;
//
//           final attendance =
//               provider.todayAttendanceModel;
//
//           final summary =
//               attendance?.attendanceSummary;
//
//           final registrationStatus =
//               faceStatus?.registrationStatus ?? "none";
//
//           final bool showRegistrationFlow =
//               registrationStatus == "none" ||
//                   registrationStatus == "rejected";
//
//           final bool showPendingFlow =
//               registrationStatus == "pending";
//
//           final bool showApprovedFlow =
//               registrationStatus == "approved";
//
//           return SafeArea(
//
//             child: Column(
//
//               children: [
//
//
//
//                 /// =========================================================
//                 /// REGISTRATION FLOW
//                 /// =========================================================
//
//                 if (showRegistrationFlow)
//                   Expanded(
//
//                     child: SingleChildScrollView(
//
//                       padding:
//                       const EdgeInsets.symmetric(
//                         horizontal: 20,
//                       ),
//
//                       child: Column(
//
//                         children: [
//
//                           /// PRIMARY IMAGE
//                           // PRIMARY IMAGE SECTION
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.black12,
//                               borderRadius: BorderRadius.circular(24),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // Clickable Circle Avatar
//                                 GestureDetector(
//                                   onTap: () => _showImagePickerSheet(context, provider), // Bottom Sheet Call
//                                   child: Stack(
//                                     children: [
//                                       CircleAvatar(
//
//                                         radius: 40,
//                                         backgroundColor:AppColors.white,
//                                         backgroundImage: provider.primaryImage != null
//                                             ? FileImage(provider.primaryImage!)
//                                             : null,
//                                         child: provider.primaryImage == null
//                                             ? const Icon(Icons.person, color: AppColors.grey, size: 50)
//                                             : null,
//                                       ),
//                                       // Edit icon overlay
//                                       Positioned(
//                                         bottom: 0,
//                                         right: 0,
//                                         child: Container(
//                                           padding: const EdgeInsets.all(4),
//                                           decoration: const BoxDecoration(
//                                             color: AppColors.deepPrimary, // Aapka primary theme color
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: const Icon(Icons.add_a_photo, size: 16, color: Colors.white),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 const Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Primary Face Image",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         "Tap to upload a clear image for verification",
//                                         style: TextStyle(color: Colors.black, fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // Container(
//                           //
//                           //   padding:
//                           //   const EdgeInsets.all(16),
//                           //
//                           //   decoration: BoxDecoration(
//                           //
//                           //     color: Colors.white10,
//                           //
//                           //     borderRadius:
//                           //     BorderRadius.circular(24),
//                           //   ),
//                           //
//                           //   child: Column(
//                           //
//                           //     children: [
//                           //
//                           //       Row(
//                           //
//                           //         children: [
//                           //
//                           //           provider.primaryImage != null
//                           //
//                           //               ? ClipRRect(
//                           //
//                           //             borderRadius:
//                           //             BorderRadius.circular(16),
//                           //
//                           //             child: Image.file(
//                           //
//                           //               provider.primaryImage!,
//                           //
//                           //               width: 75,
//                           //               height: 75,
//                           //
//                           //               fit: BoxFit.cover,
//                           //             ),
//                           //           )
//                           //
//                           //               : Container(
//                           //
//                           //             width: 75,
//                           //             height: 75,
//                           //
//                           //             decoration: BoxDecoration(
//                           //
//                           //               color: Colors.white12,
//                           //
//                           //               borderRadius:
//                           //               BorderRadius.circular(16),
//                           //             ),
//                           //
//                           //             child: const Icon(
//                           //
//                           //               Icons.person,
//                           //
//                           //               color: Colors.white,
//                           //
//                           //               size: 40,
//                           //             ),
//                           //           ),
//                           //
//                           //           const SizedBox(width: 14),
//                           //
//                           //           const Expanded(
//                           //
//                           //             child: Column(
//                           //
//                           //               crossAxisAlignment:
//                           //               CrossAxisAlignment.start,
//                           //
//                           //               children: [
//                           //
//                           //                 Text(
//                           //
//                           //                   "Primary Face Image",
//                           //
//                           //                   style: TextStyle(
//                           //
//                           //                     color: Colors.white,
//                           //
//                           //                     fontWeight: FontWeight.bold,
//                           //
//                           //                     fontSize: 16,
//                           //                   ),
//                           //                 ),
//                           //
//                           //                 SizedBox(height: 6),
//                           //
//                           //                 Text(
//                           //
//                           //                   "Upload one clear image for verification",
//                           //
//                           //                   style: TextStyle(
//                           //
//                           //                     color: Colors.white70,
//                           //
//                           //                     fontSize: 12,
//                           //                   ),
//                           //                 ),
//                           //               ],
//                           //             ),
//                           //           ),
//                           //         ],
//                           //       ),
//                           //
//                           //       const SizedBox(height: 16),
//                           //
//                           //       Row(
//                           //
//                           //         children: [
//                           //
//                           //           Expanded(
//                           //
//                           //             child: ElevatedButton.icon(
//                           //               style: ElevatedButton.styleFrom(
//                           //                 backgroundColor: AppColors.deepPrimary,
//                           //                 foregroundColor: Colors.white,
//                           //                 shape: RoundedRectangleBorder(
//                           //                   borderRadius: BorderRadius.circular(12),
//                           //                 ),
//                           //               ),
//                           //
//                           //
//                           //
//                           //               onPressed: () {
//                           //                 provider
//                           //                     .capturePrimaryImage();
//                           //               },
//                           //
//                           //               icon: const Icon(
//                           //                 Icons.camera_alt,
//                           //               ),
//                           //
//                           //               label:
//                           //               const Text("Camera"),
//                           //             ),
//                           //           ),
//                           //
//                           //           const SizedBox(width: 12),
//                           //
//                           //           Expanded(
//                           //
//                           //             child: ElevatedButton.icon(
//                           //               style: ElevatedButton.styleFrom(
//                           //                 backgroundColor: AppColors.deepPrimary,
//                           //                 foregroundColor: Colors.white,
//                           //                 shape: RoundedRectangleBorder(
//                           //                   borderRadius: BorderRadius.circular(12),
//                           //                 ),
//                           //               ),
//                           //
//                           //               onPressed: () {
//                           //                 provider
//                           //                     .pickPrimaryImageFromGallery();
//                           //               },
//                           //
//                           //               icon: const Icon(
//                           //                 Icons.photo,
//                           //               ),
//                           //
//                           //               label:
//                           //               const Text("Gallery"),
//                           //             ),
//                           //           ),
//                           //         ],
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),
//
//                           const SizedBox(height: 20),
//
//                           /// CAMERA
//
//                           Container(
//
//                             height: 420,
//
//                             decoration: BoxDecoration(
//
//                               borderRadius:
//                               BorderRadius.circular(30),
//                             ),
//
//                             child: Stack(
//
//                               alignment: Alignment.center,
//
//                               children: [
//
//                                 ClipRRect(
//
//                                   borderRadius:
//                                   BorderRadius.circular(30),
//
//                                   child: LayoutBuilder(
//
//                                     builder: (_, constraints) {
//
//                                       final size =
//                                       provider.cameraController!
//                                           .value.previewSize!;
//
//                                       return FittedBox(
//
//                                         fit: BoxFit.cover,
//
//                                         child: SizedBox(
//
//                                           width: size.height,
//                                           height: size.width,
//
//                                           child: Transform.scale(
//
//                                             scaleX: -1,
//
//                                             child: CameraPreview(
//                                               provider.cameraController!,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//
//                                 Container(
//
//                                   decoration: BoxDecoration(
//
//                                     borderRadius:
//                                     BorderRadius.circular(30),
//
//                                     color: Colors.black
//                                         .withOpacity(.25),
//                                   ),
//                                 ),
//
//                                 ClipOval(
//
//                                   child: Container(
//
//                                     width: 260,
//                                     height: 340,
//
//                                     decoration: BoxDecoration(
//
//                                       border: Border.all(
//
//                                         color: provider.isFaceValid
//                                             ? AppColors.deepPrimary
//                                             : Colors.white,
//
//                                         width: 4,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 Positioned(
//
//                                   child: AnimatedContainer(
//
//                                     duration:
//                                     const Duration(milliseconds: 500),
//
//                                     width: 250,
//
//                                     height:
//                                     provider.isCapturing
//                                         ? 4
//                                         : 0,
//
//                                     decoration: BoxDecoration(
//
//                                       color:AppColors.deepPrimary,
//
//                                       borderRadius:
//                                       BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                 ),
//
//                                 Positioned(
//
//                                   bottom: 20,
//
//                                   child: Column(
//
//                                     children: [
//
//                                       Text(
//
//                                         "${provider.captureCount}/20",
//
//                                         style: const TextStyle(
//
//                                           color: Colors.white,
//
//                                           fontWeight: FontWeight.bold,
//
//                                           fontSize: 28,
//                                         ),
//                                       ),
//
//                                       const SizedBox(height: 8),
//
//                                       SizedBox(
//
//                                         width: 220,
//
//                                         child:
//                                         LinearProgressIndicator(
//
//                                           value:
//                                           provider.captureCount / 20,
//
//                                           minHeight: 10,
//
//                                           borderRadius:
//                                           BorderRadius.circular(20),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           /// INFO
//
//                           _infoCard(
//                             provider.instructionText,
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           /// BUTTON
//
//                           SizedBox(
//
//                             width: double.infinity,
//                             height: 50,
//
//                             child: ElevatedButton(
//
//                               style:
//                               ElevatedButton.styleFrom(
//
//                                 backgroundColor:
//                                 AppColors.primary,
//
//                                 foregroundColor:
//                                 AppColors.white,
//
//                                 shape:
//                                 RoundedRectangleBorder(
//
//                                   borderRadius:
//                                   BorderRadius.circular(14),
//                                 ),
//                               ),
//
//                               onPressed: () async {
//
//                                 if (provider.primaryImage == null) {
//
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(
//
//                                     const SnackBar(
//
//                                       content: Text(
//                                         "Please select primary image",
//                                       ),
//                                     ),
//                                   );
//
//                                   return;
//                                 }
//
//                                 await provider.startAutoCapture();
//                               },
//
//                               child: provider.isCapturing
//
//                                   ? Row(
//
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//
//                                 children: [
//
//                                   const SizedBox(
//
//                                     height: 20,
//                                     width: 20,
//
//                                     child:
//                                     CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                     ),
//                                   ),
//
//                                   const SizedBox(width: 12),
//
//                                   Text(
//                                     "Capturing ${provider.captureCount}/20",
//                                   ),
//                                 ],
//                               )
//
//                                   : provider.isRegistering
//
//                                   ? const CircularProgressIndicator()
//
//                                   : const Text(
//
//                                 "Register Face",
//
//                                 style: TextStyle(
//
//                                   fontWeight: FontWeight.bold,
//
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 /// =========================================================
//                 /// PENDING FLOW
//                 /// =========================================================
//
//                 if (showPendingFlow)
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//
//                           Image.asset(
//                             AppImages.illustration,
//                             scale: 5,
//                             //height: 200,
//                             fit: BoxFit.contain,
//                           ),
//                           const SizedBox(height: 40),
//                           const Text(
//                             "Verification Under Review",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 26,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: 0.8,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             "We are currently reviewing your face verification. This usually takes a few hours. We'll notify you once it's done.",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black.withOpacity(0.6), // Light grey feel on dark theme
//                               fontSize: 15,
//                               height: 1.5, // Better readability for multiline text
//                             ),
//                           ),
//                           const SizedBox(height: 50),
//                           // Ek secondary "Got it" ya "Refresh" button bhi de sakte hain professional feel ke liye
//                           OutlinedButton(
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: AppColors.primary,
//                               side: const BorderSide(color: AppColors.primary),
//                               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             onPressed: () {
//                               //ye same screen hi reload hoga ok
//                               Navigator.pushReplacementNamed(context, AppRoutes.faceAttendance);
//                             },
//                             child: const Text("Check Status"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                 /// =========================================================
//                 /// APPROVED FLOW
//                 /// =========================================================
//
//                 if (showApprovedFlow)
//                   Expanded(
//
//                     child: Padding(
//
//                       padding:
//                       const EdgeInsets.symmetric(
//                         horizontal: 20,
//                       ),
//
//                       child: Column(
//
//                         children: [
//
//                           /// VERIFIED CARD
//
//                           Container(
//
//                             width: double.infinity,
//
//                             padding:
//                             const EdgeInsets.all(16),
//
//                             decoration: BoxDecoration(
//
//                               color:
//                               Colors.green.withOpacity(.12),
//
//                               borderRadius:
//                               BorderRadius.circular(20),
//
//                               border: Border.all(
//                                 color: AppColors.deepPrimary,
//                               ),
//                             ),
//
//                             child: const Row(
//
//                               children: [
//
//                                 Icon(
//
//                                   Icons.verified,
//
//                                   color: AppColors.deepPrimary,
//                                 ),
//
//                                 SizedBox(width: 12),
//
//                                 Expanded(
//
//                                   child: Text(
//
//                                     "Face verified successfully. You can mark attendance now.",
//
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           /// CAMERA
//
//                           Expanded(
//
//                             child: ClipRRect(
//
//                               borderRadius:
//                               BorderRadius.circular(30),
//
//                               child: LayoutBuilder(
//
//                                 builder: (_, constraints) {
//
//                                   final size =
//                                   provider.cameraController!
//                                       .value.previewSize!;
//
//                                   return FittedBox(
//
//                                     fit: BoxFit.cover,
//
//                                     child: SizedBox(
//
//                                       width: size.height,
//                                       height: size.width,
//
//                                       child: Transform.scale(
//
//                                         scaleX: -1,
//
//                                         child: CameraPreview(
//                                           provider.cameraController!,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           _infoCard(
//                             provider.instructionText,
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           /// PUNCH BUTTON
//                           SizedBox(
//                             width: double.infinity,
//                             height: 50,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.deepPrimary,
//                                 foregroundColor: AppColors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                               ),
//                               // Button hamesha clickable hai, sirf loading par disable hoga
//                               onPressed: provider.isPunchLoading
//                                   ? null
//                                   : () async {
//                                 final location = attendance?.assignment?.locations.first;
//                                 if (location == null) return;
//
//                                 await provider.capturePunchImage();
//                                 if (provider.punchImage == null) return;
//
//                                 await provider.punchAttendance(
//                                   locationId: location.locationId,
//                                 );
//
//                                 if (context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         provider.punchResponseModel?.message ?? "Success",
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: provider.isPunchLoading
//                                   ? const CircularProgressIndicator(color: Colors.white)
//                                   : Text(
//                                 // Logic: Agar list null ya empty hai -> "Punch In"
//                                 // Agar list mein data hai -> Check last type
//                                 (summary?.timeline == null || summary!.timeline.isEmpty)
//                                     ? "Punch In"
//                                     : (summary.timeline.last.type == "In" ? "Punch Out" : "Punch In"),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                   color: AppColors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _infoCard(String text) {
//
//     return Container(
//
//       width: double.infinity,
//
//       padding: const EdgeInsets.all(16),
//
//       decoration: BoxDecoration(
//
//         color: Colors.black12,
//
//         borderRadius: BorderRadius.circular(18),
//       ),
//
//       child: Row(
//
//         children: [
//
//           const Icon(
//             Icons.info_outline,
//             color: Colors.black,
//           ),
//
//           const SizedBox(width: 12),
//
//           Expanded(
//
//             child: Text(
//
//               text,
//
//               style: const TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showImagePickerSheet(BuildContext context, dynamic provider) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.white, // Dark Background
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Choose Primary Image",
//                 style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//             // Camera Button with Gradient
//               Row(
//                 children: [
//                   // Camera Button with Gradient
//                   Expanded(
//                     child: _buildGradientButton(
//                       onTap: () {
//                         Navigator.pop(context);
//                         provider.capturePrimaryImage();
//                       },
//                       icon: Icons.camera_alt,
//                       label: "Camera",
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   // Gallery Button with Gradient
//                   Expanded(
//                     child: _buildGradientButton(
//                       onTap: () {
//                         Navigator.pop(context);
//                         provider.pickPrimaryImageFromGallery();
//                       },
//                       icon: Icons.photo,
//                       label: "Gallery",
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
// // Reusable Gradient Button Helper
//   Widget _buildGradientButton({
//     required VoidCallback onTap,
//     required IconData icon,
//     required String label
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         // Padding aur Spacing ka dhyaan rakha gaya hai
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//         decoration: BoxDecoration(
//           color: Colors.black12,
//           // gradient: const LinearGradient(
//           //   colors: [Color(0xFF1F7A5C), Color(0xFF38B38D)],
//           //   begin: Alignment.topLeft,
//           //   end: Alignment.bottomRight,
//           // ),
//           borderRadius: BorderRadius.circular(16), // Rounded corners for tile look
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.black.withOpacity(0.2),
//           //     blurRadius: 8,
//           //     offset: const Offset(0, 4),
//           //   ),
//           // ],
//         ),
//         child: Column( // Row ki jagah Column use kiya hai "Tile" feel ke liye
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: Colors.black,
//               size: 28, // Thoda bada icon
//             ),
//             const SizedBox(height: 10), // Icon aur Text ke beech space
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_appbar.dart';
import '../provider/attendance_provider.dart';
import '../widgets/approved_flow_widget.dart';
import '../widgets/pending_flow_widget.dart';
import '../widgets/registration_flow_widget.dart';

class FaceAttendanceScreen extends StatefulWidget {
  final bool isBack;
  const FaceAttendanceScreen({super.key,required this.isBack});

  @override
  State<FaceAttendanceScreen> createState() =>
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

      backgroundColor: Colors.white,

     appBar: CustomAppBar(title:  "Face Attendance",showBack: false,),

      body: Consumer<AttendanceProvider>(

        builder: (_, provider, __) {

          if (provider.isLoading) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.cameraController == null ||
              !provider.cameraController!
                  .value
                  .isInitialized) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final status =
              provider.faceStatusModel
                  ?.registrationStatus ??
                  "none";

          /// ===============================
          /// REGISTRATION FLOW
          /// ===============================

          if (status == "none" ||
              status == "rejected") {

            return RegistrationFlowWidget(
              provider: provider,
            );
          }

          /// ===============================
          /// PENDING FLOW
          /// ===============================

          if (status == "pending") {

            return const PendingFlowWidget();
          }

          /// ===============================
          /// APPROVED FLOW
          /// ===============================

          return ApprovedFlowWidget(
            provider: provider,
          );
        },
      ),
    );
  }
}