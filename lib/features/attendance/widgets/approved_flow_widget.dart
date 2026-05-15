// import 'package:flutter/material.dart';
//
// import '../../../common/widgets/custom_button.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/utils/app_toast.dart';
// import '../provider/attendance_provider.dart';
// import 'camera_preview_widget.dart';
// import 'info_card_widget.dart';
//
// class ApprovedFlowWidget extends StatelessWidget {
//
//   final AttendanceProvider provider;
//
//   const ApprovedFlowWidget({
//     super.key,
//     required this.provider,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     final attendance =
//         provider.todayAttendanceModel;
//
//     final summary =
//         attendance?.attendanceSummary;
//
//     return Padding(
//
//       padding: const EdgeInsets.all(20),
//
//       child: Column(
//
//         children: [
//
//           /// VERIFIED CARD
//
//           Container(
//
//             width: double.infinity,
//
//             padding: const EdgeInsets.all(16),
//
//             decoration: BoxDecoration(
//
//               color: Colors.green.shade50,
//
//               borderRadius:
//               BorderRadius.circular(20),
//
//               border: Border.all(
//                 color: Colors.green,
//               ),
//             ),
//
//             child: const Row(
//
//               children: [
//
//                 Icon(
//                   Icons.verified,
//                   color: Colors.green,
//                 ),
//
//                 SizedBox(width: 10),
//
//                 Expanded(
//
//                   child: Text(
//
//                     "Face verified successfully. You can mark attendance now.",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// CAMERA
//
//           Expanded(
//
//             child: CameraPreviewWidget(
//               provider: provider,
//               showProgress: false,
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// INFO
//
//           InfoCardWidget(
//             text: provider.instructionText,
//           ),
//
//           const SizedBox(height: 20),
//           CustomButton(
//
//             isLoading: provider.isPunchLoading,
//
//             text:
//             (summary?.timeline == null ||
//                 summary!.timeline.isEmpty)
//
//                 ? "Punch In"
//
//                 : (summary.timeline.last.type == "In"
//
//                 ? "Punch Out"
//
//                 : "Punch In"),
//
//               onTap: () async {
//
//                 print("Start Image scan1");
//
//                 final locations =
//                     attendance
//                         ?.assignment
//                         ?.locations;
//
//                 /// SAFE CHECK
//                 if(
//                 locations == null ||
//                     locations.isEmpty
//                 ){
//
//                   AppToast.show(
//                     "Location not found",
//                   );
//
//                   return;
//                 }
//
//                 final location =
//                     locations.first;
//
//                 print("Start Image scan2");
//
//                 /// FACE CAPTURE
//                 final success =
//                 await provider.capturePunchImage();
//
//                 print("Start Image scan3");
//
//                 print(success);
//
//                 print("Start Image scan4");
//
//                 if(!success){
//
//                   AppToast.show(
//                     "Face capture failed",
//                   );
//
//                   return;
//                 }
//
//                 print(
//                     "################Punch Module Send data "
//                         "locationId: ${location.locationId}, "
//                         "lat: ${location.lat} "
//                         "lng: ${location.lng} "
//                         "radiusInMeter: ${location.radiusInMeter}"
//                 );
//                 /// LOCATION CHECK
//                 await provider.getCurrentLocation(
//                   officeLat: double.parse(location.lat),
//                   officeLng: double.parse(location.lng),
//                   radius: location.radiusInMeter.toDouble(),
//                 );
//
//                 /// OUTSIDE RADIUS
//                 if(!provider.isInsideRadius){
//
//                   AppToast.show(
//                     "You are outside attendance area",
//                   );
//
//                   return;
//                 }
//                 /// API HIT
//                 await provider.punchAttendance(
//
//                   locationId:
//                   location.locationId,
//                 );
//
//                 if(context.mounted){
//
//                   AppToast.show(
//
//                     provider
//                         .punchResponseModel
//                         ?.message ??
//
//                         "Attendance Updated",
//                   );
//                 }
//               }
//           ),
//
//           /// BUTTON
//           // CustomButton(onTap: () async {
//           //
//           //   final location =
//           //       attendance
//           //           ?.assignment
//           //           ?.locations
//           //           .first;
//           //
//           //   if (location == null) {
//           //     return;
//           //   }
//           //
//           //   /// ONLY ONE IMAGE
//           //   await provider.capturePunchImage();
//           //
//           //   await provider.punchAttendance(
//           //     locationId: location.locationId,
//           //   );
//           //
//           //   if (context.mounted) {
//           //     AppToast.show(
//           //       provider
//           //           .punchResponseModel
//           //           ?.message ??
//           //           "",
//           //     );
//           //
//           //     // ScaffoldMessenger.of(context)
//           //     //     .showSnackBar(
//           //
//           //       // SnackBar(
//           //       //
//           //       //   content: Text(
//           //       //
//           //       //     provider
//           //       //         .punchResponseModel
//           //       //         ?.message ??
//           //       //         "",
//           //       //   ),
//           //       // ),
//           //     // );
//           //   }
//           // },isLoading: provider.isPunchLoading,text:  (summary?.timeline == null ||
//           //     summary!.timeline.isEmpty)
//           //
//           //     ? "Punch In"
//           //
//           //     : (summary.timeline.last.type ==
//           //     "In"
//           //
//           //     ? "Punch Out"
//           //
//           //     : "Punch In"),),
//
//           // SizedBox(
//           //
//           //   width: double.infinity,
//           //   height: 55,
//           //
//           //   child: ElevatedButton(
//           //                                   style: ElevatedButton.styleFrom(
//           //                       backgroundColor: AppColors.deepPrimary,
//           //                       foregroundColor: AppColors.white,
//           //                       shape: RoundedRectangleBorder(
//           //                         borderRadius: BorderRadius.circular(16),
//           //                       ),
//           //                     ),
//           //
//           //     onPressed:
//           //     provider.isPunchLoading
//           //
//           //         ? null
//           //
//           //         : () async {
//           //
//           //       final location =
//           //           attendance
//           //               ?.assignment
//           //               ?.locations
//           //               .first;
//           //
//           //       if (location == null) {
//           //         return;
//           //       }
//           //
//           //       /// ONLY ONE IMAGE
//           //       await provider.capturePunchImage();
//           //
//           //       await provider.punchAttendance(
//           //         locationId: location.locationId,
//           //       );
//           //
//           //       if (context.mounted) {
//           //
//           //         ScaffoldMessenger.of(context)
//           //             .showSnackBar(
//           //
//           //           SnackBar(
//           //
//           //             content: Text(
//           //
//           //               provider
//           //                   .punchResponseModel
//           //                   ?.message ??
//           //                   "",
//           //             ),
//           //           ),
//           //         );
//           //       }
//           //     },
//           //
//           //     child:
//           //     provider.isPunchLoading
//           //
//           //         ? const CircularProgressIndicator()
//           //
//           //         : Text(
//           //
//           //       (summary?.timeline == null ||
//           //           summary!.timeline.isEmpty)
//           //
//           //           ? "Punch In"
//           //
//           //           : (summary.timeline.last.type ==
//           //           "In"
//           //
//           //           ? "Punch Out"
//           //
//           //           : "Punch In"),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_toast.dart';
import '../provider/attendance_provider.dart';

import 'attendance_live_map_widget.dart';
import 'attendance_map_widget.dart';
import 'camera_preview_widget.dart';
import 'info_card_widget.dart';

class ApprovedFlowWidget extends StatefulWidget {
  final AttendanceProvider provider;

  const ApprovedFlowWidget({super.key, required this.provider});

  @override
  State<ApprovedFlowWidget> createState() => _ApprovedFlowWidgetState();
}

class _ApprovedFlowWidgetState extends State<ApprovedFlowWidget> {
   double defaultLat = 28.626251088905114;
   double defaultLng = 77.37557231401667;
   double defaultRadius = 150.0; // Default 100 meters
   @override
   void initState() {
     super.initState();

     WidgetsBinding.instance.addPostFrameCallback((_) async {
       final attendance = widget.provider.todayAttendanceModel;
       final locations = attendance?.assignment?.locations;

       // Fallback logic: agar location null hai to default use karein
       final double officeLat = double.tryParse(locations?.last.lat ?? "") ?? defaultLat;
       final double officeLng = double.tryParse(locations?.last.lng ?? "") ?? defaultLng;
       final double radius = locations?.first.radiusInMeter.toDouble() ?? defaultRadius;

       /// FIRST TIME LOCATION FETCH
       await widget.provider.getCurrentLocation(
         officeLat: officeLat,
         officeLng: officeLng,
         radius: radius,
       );

       /// LIVE TRACKING
       widget.provider.startLiveTracking(
         officeLat: officeLat,
         officeLng: officeLng,
         radius: radius,
       );
     });
   }

  @override
  Widget build(BuildContext context) {
    final attendance = widget.provider.todayAttendanceModel;

    final summary = attendance?.attendanceSummary;

    return Padding(
      padding: const EdgeInsets.all(14),

      child: Column(
        children: [
          // /// VERIFIED CARD
          //
          // Container(
          //
          //   width: double.infinity,
          //
          //   padding: const EdgeInsets.all(16),
          //
          //   decoration: BoxDecoration(
          //
          //     color: Colors.green.shade50,
          //
          //     borderRadius:
          //     BorderRadius.circular(20),
          //
          //     border: Border.all(
          //       color: Colors.green,
          //     ),
          //   ),
          //
          //   child: const Row(
          //
          //     children: [
          //
          //       Icon(
          //         Icons.verified,
          //         color: Colors.green,
          //       ),
          //
          //       SizedBox(width: 10),
          //
          //       Expanded(
          //
          //         child: Text(
          //
          //           "Face verified successfully. You can mark attendance now.",
          //
          //           style: TextStyle(
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(height: 20),

          /// LIVE CAMERA
          ///
          Expanded(
            child: widget.provider.isInsideRadius
                ? CameraPreviewWidget(
                    provider: widget.provider,
                    showProgress: false,
                  )
                : AttendanceLiveMapWidget(
                    provider: widget.provider,

              officeLat: double.tryParse(attendance?.assignment?.locations.last.lat ?? "") ?? defaultLat,
              officeLng: double.tryParse(attendance?.assignment?.locations.last.lng ?? "") ?? defaultLng,
              radius: attendance?.assignment?.locations.first.radiusInMeter.toDouble() ?? defaultRadius,
                  ),
          ),

          // Expanded(
          //
          //   child: CameraPreviewWidget(
          //     provider: widget.provider,
          //     showProgress: false,
          //   ),
          // ),
          const SizedBox(height: 15),

          /// INFO CARD
          widget.provider.isInsideRadius
              ? InfoCardWidget(text: widget.provider.instructionText)
              : Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: widget.provider.isInsideRadius
                        ? Colors.green.shade50
                        : Colors.red.shade50,

                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(
                      color: widget.provider.isInsideRadius
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        widget.provider.isInsideRadius
                            ? Icons.location_on
                            : Icons.location_off,

                        color: widget.provider.isInsideRadius
                            ? Colors.green
                            : Colors.red,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              widget.provider.isInsideRadius
                                  ? "Inside Attendance Area"
                                  : "Outside Attendance Area",

                              style: TextStyle(
                                fontWeight: FontWeight.w600,

                                color: widget.provider.isInsideRadius
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Distance : ${widget.provider.distanceInMeter.toStringAsFixed(2)} Meter",

                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      // GestureDetector(
                      //
                      //   onTap: () {
                      //
                      //     final location =
                      //         attendance
                      //             ?.assignment
                      //             ?.locations
                      //             .last;
                      //
                      //     if(location == null){
                      //       return;
                      //     }
                      //
                      //     Navigator.push(
                      //
                      //       context,
                      //
                      //       MaterialPageRoute(
                      //
                      //         builder: (_) =>
                      //             AttendanceMapScreen(
                      //
                      //               officeLat:
                      //               double.parse(
                      //                 location.lat,
                      //               ),
                      //
                      //               officeLng:
                      //               double.parse(
                      //                 location.lng,
                      //               ),
                      //
                      //               radius:
                      //               location
                      //                   .radiusInMeter
                      //                   .toDouble(),
                      //             ),
                      //       ),
                      //     );
                      //   },
                      //
                      //   child: Container(
                      //
                      //     padding:
                      //     const EdgeInsets.symmetric(
                      //
                      //       horizontal: 14,
                      //       vertical: 10,
                      //     ),
                      //
                      //     decoration: BoxDecoration(
                      //
                      //       color: AppColors.deepPrimary,
                      //
                      //       borderRadius:
                      //       BorderRadius.circular(12),
                      //     ),
                      //
                      //     child: const Row(
                      //
                      //       children: [
                      //
                      //         Icon(
                      //           Icons.map,
                      //           color: Colors.white,
                      //           size: 18,
                      //         ),
                      //
                      //         SizedBox(width: 6),
                      //
                      //         Text(
                      //
                      //           "View Map",
                      //
                      //           style: TextStyle(
                      //
                      //             color: Colors.white,
                      //
                      //             fontWeight:
                      //             FontWeight.w600,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

          const SizedBox(height: 15),

          /// LOCATION STATUS CARD
          const SizedBox(height: 20),

          /// PUNCH BUTTON
          CustomButton(
            isLoading: widget.provider.isPunchLoading,

            text: (summary?.timeline == null || summary!.timeline.isEmpty)
                ? "Punch In"
                : (summary.timeline.last.type == "In"
                      ? "Punch Out"
                      : "Punch In"),

            onTap: () async {
              print("Start Image scan1");

              final locations = attendance?.assignment?.locations;

              /// LOCATION CHECK

              if (locations == null || locations.isEmpty) {
                AppToast.show("Location not found");

                return;
              }

              final location = locations.last;

              /// GET CURRENT LOCATION

              await widget.provider.getCurrentLocation(
                officeLat: double.parse(location.lat),

                officeLng: double.parse(location.lng),

                radius: location.radiusInMeter.toDouble(),
              );

              /// OUTSIDE RADIUS

              if (!widget.provider.isInsideRadius) {
                AppToast.show("You are outside attendance area");

                return;
              }

              print("Start Image scan2");

              /// FACE CAPTURE

              final success = await widget.provider.capturePunchImage();

              print("Start Image scan3");

              print(success);

              print("Start Image scan4");

              if (!success) {
                AppToast.show("Face capture failed");

                return;
              }

              print(
                "################Punch Module Send data "
                "locationId: ${location.locationId}, "
                "lat: ${location.lat} "
                "lng: ${location.lng} "
                "radiusInMeter: ${location.radiusInMeter}",
              );

              /// API HIT

              await widget.provider.punchAttendance(
                locationId: location.locationId,
              );

              if (context.mounted) {
                AppToast.show(
                  widget.provider.punchResponseModel?.message ??
                      "Attendance Updated",
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
