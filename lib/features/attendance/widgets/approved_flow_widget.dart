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

  const ApprovedFlowWidget({
    super.key,
    required this.provider,
  });

  @override
  State<ApprovedFlowWidget> createState() => _ApprovedFlowWidgetState();
}

class _ApprovedFlowWidgetState extends State<ApprovedFlowWidget> {
  double defaultLat = 28.626251088905114;

  double defaultLng = 77.37557231401667;

  double defaultRadius = 150.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final attendance = widget.provider.todayAttendanceModel;

        final locations = attendance?.assignment?.locations;

        final officeLat = double.tryParse(
              locations?.last.lat ?? "",
            ) ??
            defaultLat;

        final officeLng = double.tryParse(
              locations?.last.lng ?? "",
            ) ??
            defaultLng;

        final radius =
            locations?.first.radiusInMeter.toDouble() ?? defaultRadius;

        await widget.provider.getCurrentLocation(
          officeLat: officeLat,
          officeLng: officeLng,
          radius: radius,
        );

        widget.provider.startLiveTracking(
          officeLat: officeLat,
          officeLng: officeLng,
          radius: radius,
        );

        await widget.provider.getFaceImages();

        widget.provider.resetFaceScanner();
      },
    );
  }

  Future<void> _handlePunch() async {
    if (widget.provider.isPunchLoading) {
      return;
    }

    final attendance = widget.provider.todayAttendanceModel;

    final locations = attendance?.assignment?.locations;

    if (locations == null || locations.isEmpty) {
      AppToast.show(
        "Location not found",
      );

      return;
    }

    final location = locations.last;

    /// =====================
    /// LOCATION REFRESH
    /// =====================

    await widget.provider.getCurrentLocation(
      officeLat: double.parse(
        location.lat,
      ),
      officeLng: double.parse(
        location.lng,
      ),
      radius: location.radiusInMeter.toDouble(),
    );

    if (!widget.provider.isInsideRadius) {
      AppToast.show(
        "Outside attendance area",
      );

      return;
    }

    /// =====================
    /// VERIFY
    /// =====================

    final verified = await widget.provider.verifyFaceAndPunch(
      context,
    );

    if (!verified) {
      AppToast.show(
        widget.provider.instructionText,
      );

      return;
    }

    /// =====================
    /// PUNCH
    /// =====================

    await widget.provider.punchAttendance(
      locationId: location.locationId,
      context: context,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final attendance = widget.provider.todayAttendanceModel;

    final summary = attendance?.attendanceSummary;

    final isPunchIn = summary?.timeline == null ||
        summary!.timeline.isEmpty ||
        summary.timeline.last.type != "In";

    return Padding(
      padding: const EdgeInsets.all(
        14,
      ),
      child: Column(
        children: [
          /// =====================
          /// CAMERA / MAP
          /// =====================

          Expanded(
            child: widget.provider.isInsideRadius
                ? CameraPreviewWidget(
                    provider: widget.provider,
                    showProgress: false,
                  )
                : AttendanceLiveMapWidget(
                    provider: widget.provider,
                    officeLat: double.tryParse(
                          attendance?.assignment?.locations.last.lat ?? "",
                        ) ??
                        defaultLat,
                    officeLng: double.tryParse(
                          attendance?.assignment?.locations.last.lng ?? "",
                        ) ??
                        defaultLng,
                    radius: attendance
                            ?.assignment?.locations.first.radiusInMeter
                            .toDouble() ??
                        defaultRadius,
                  ),
          ),

          const SizedBox(
            height: 15,
          ),

          /// =====================
          /// INFO
          /// =====================

          AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 300,
            ),
            child: widget.provider.isInsideRadius
                ? InfoCardWidget(
                    text: widget.provider.instructionText,
                  )
                : widget.provider.distanceInMeter == 0
                    ? const SizedBox()
                    : LocationStatusCard(
                        isInsideRadius: widget.provider.isInsideRadius,
                        distanceInMeter: widget.provider.distanceInMeter,
                      ),
          ),

          const SizedBox(
            height: 20,
          ),

          /// =====================
          /// BUTTON
          /// =====================

          if (widget.provider.isInsideRadius)
            CustomButton(
              isLoading: widget.provider.isPunchLoading,
              text: isPunchIn ? "Punch In" : "Punch Out",
              gradientColors: isPunchIn
                  ? [
                      const Color(0xFF0128A1),
                      const Color(0xFF404DAB),
                    ]
                  : [
                      const Color(0xFFFF5252),
                      const Color(0xFFFF5252),
                    ],
              onTap: _handlePunch,
            ),
        ],
      ),
    );
  }
}
