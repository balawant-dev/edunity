


import 'package:flutter/material.dart';

import '../../../common/widgets/custom_button.dart';

import '../../../core/utils/app_toast.dart';
import '../provider/attendance_provider.dart';

import 'attendance_live_map_widget.dart';

import 'camera_preview_widget.dart';
import 'info_card_widget.dart';
import 'location_status_card.dart';

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
       widget.provider.getFaceImages();
       widget.provider.resetFaceScanner();
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: widget.provider.isInsideRadius
                ? InfoCardWidget(text: widget.provider.instructionText):widget.provider.distanceInMeter==0?SizedBox():LocationStatusCard(
              isInsideRadius: widget.provider.isInsideRadius,
              distanceInMeter: widget.provider.distanceInMeter,
            ),

          ),

          const SizedBox(height: 15),

          /// LOCATION STATUS CARD
          const SizedBox(height: 20),

          // Punch Button
          widget.provider.isInsideRadius
              ?    CustomButton(
            gradientColors:
            (summary?.timeline == null || summary!.timeline.isEmpty)
                ? [
              const Color(0xFF0128A1),
              const Color(0xFF404DAB),
            ]
                : (summary.timeline.last.type == "In"
                ? [
              // const Color(0xFFFF8A80),
              const Color(0xFFFF5252),
              const Color(0xFFFF5252),
            ]
                : [
              const Color(0xFF0128A1),
              const Color(0xFF404DAB),
            ]),


            isLoading: widget.provider.isPunchLoading,
            text: (summary?.timeline == null || summary!.timeline.isEmpty)
                ? "Punch In"
                : (summary.timeline.last.type == "In" ? "Punch Out" : "Punch In"),
            onTap: () async {
              if (widget.provider.isPunchLoading) return;

              final locations = attendance?.assignment?.locations;
              if (locations == null || locations.isEmpty) {
                AppToast.show("Location not found");
                return;
              }

              final location = locations.last;

              // Refresh location
              await widget.provider.getCurrentLocation(
                officeLat: double.parse(location.lat),
                officeLng: double.parse(location.lng),
                radius: location.radiusInMeter.toDouble(),
              );

              if (!widget.provider.isInsideRadius) {
                AppToast.show("You are outside attendance area");
                return;
              }
              widget.provider.isProcessingFrame = false;
              // === Main Flow ===
              final success = await widget.provider.verifyFaceAndPunch(context);

              if (!success) {
                AppToast.show(widget.provider.instructionText);
                return;
              }


              print("Kya success pop proper show ho rha ahi ki nhi >>>>>>>>>>>>>>>>>>>>>>>>>>>>");


              // Face matched successfully → Now Punch
              await widget.provider.punchAttendance(locationId: location.locationId);



            },
          ):SizedBox(),


        ],
      ),
    );
  }
}
