import 'package:flutter/material.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../core/utils/app_toast.dart';

import '../provider/attendance_provider.dart';

import '../service/face_recognition_service.dart';
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

        await widget.provider.getCurrentLocation(
          officeLat: defaultLat,
          officeLng: defaultLng,
          radius: defaultRadius,
        );

        if (widget.provider.currentLatLng != null &&
            locations != null &&
            locations.isNotEmpty) {
          final nearest = widget.provider.getNearestLocation(
            locations,
            widget.provider.currentLatLng!,
          );

          if (nearest != null) {
            final officeLat = double.parse(
              nearest.lat,
            );

            final officeLng = double.parse(
              nearest.lng,
            );

            final radius = nearest.radiusInMeter.toDouble();

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

            widget.provider.isAttendanceReady = true;
            widget.provider.notifyListeners();
          }
        }

        await widget.provider.getFaceImages();

        final saved =
            await FaceRecognitionService.instance.getSavedEmbeddings();

        if (saved == null || saved.isEmpty) {
          await widget.provider.prepareLocalEmbeddingsFromServer();
        }

        debugPrint(
          "RESTORED COUNT => ${saved?.length}",
        );

        widget.provider.resetFaceScanner();
        // final attendance = widget.provider.todayAttendanceModel;
        //
        // final locations = attendance?.assignment?.locations;
        //
        // final officeLat = double.tryParse(
        //       locations?.last.lat ?? "",
        //     ) ??
        //     defaultLat;
        //
        // final officeLng = double.tryParse(
        //       locations?.last.lng ?? "",
        //     ) ??
        //     defaultLng;
        //
        // final radius =
        //     locations?.first.radiusInMeter.toDouble() ?? defaultRadius;
        //
        // await widget.provider.getCurrentLocation(
        //   officeLat: officeLat,
        //   officeLng: officeLng,
        //   radius: radius,
        // );
        //
        // widget.provider.startLiveTracking(
        //   officeLat: officeLat,
        //   officeLng: officeLng,
        //   radius: radius,
        // );
        //
        // await widget.provider.getFaceImages();
        //
        // widget.provider.resetFaceScanner();
      },
    );
  }

  Future<void> _handlePunch(
    String action,
  ) async {
    try {
      widget.provider.loadingAction = action;

      widget.provider.notifyListeners();
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

      if (widget.provider.currentLatLng == null) {
        return;
      }

      final location = widget.provider.getNearestLocation(
        locations,
        widget.provider.currentLatLng!,
      );

      if (location == null) {
        return;
      }

      /// =====================
      /// LOCATION REFRESH
      /// =====================

      final isFieldStaff = attendance?.assignment?.isFieldStaff ?? false;

      if (!isFieldStaff) {
        await widget.provider.getCurrentLocation(
          officeLat: double.parse(location.lat),
          officeLng: double.parse(location.lng),
          radius: location.radiusInMeter.toDouble(),
        );

        if (!widget.provider.isInsideRadius) {
          AppToast.show(
            "Outside attendance area",
          );
          return;
        }
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
      String breakId = "";

      if (action == "Start Break") {
        if (!mounted) {
          return;
        }

        final selectedBreak = await _showBreakBottomSheet();

        if (!mounted) {
          return;
        }

        if (selectedBreak == null) {
          return;
        }

        breakId = selectedBreak;
      }
      await widget.provider.punchAttendance(
        locationId: location.locationId,
        context: context,
        action: action,
        breakId: breakId,
      );
    } finally {
      widget.provider.loadingAction = null;

      widget.provider.notifyListeners();
    }
  }

  Future<String?> _showBreakBottomSheet() async {
    final breaks =
        widget.provider.todayAttendanceModel?.assignment?.shiftBreaks ?? [];

    final shift = widget.provider.todayAttendanceModel?.assignment?.shift;
    if (!mounted) {
      return null;
    }
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// HANDLE
                  Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  /// HEADER CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xffF5F7FB,
                      ),
                      borderRadius: BorderRadius.circular(
                        18,
                      ),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xffEAF0FF,
                            ),
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                          ),
                          child: const Icon(
                            Icons.schedule_rounded,
                            color: Color(
                              0xff2647D8,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Shift",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                shift?.name ?? "Break Selection",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  /// NO BREAK
                  if (breaks.isEmpty)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 34,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Text(
                          "No Break Assigned",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No break has been assigned to your shift.\nBreak time may affect your attendance, salary or payroll calculation.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xff2647D8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                            child: const Text(
                              "Got it",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  /// BREAK LIST
                  else
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select Break",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ...breaks.map(
                          (e) => Container(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                18,
                              ),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    .04,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xffEEF2FF,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.free_breakfast_rounded,
                                  color: Color(
                                    0xff2647D8,
                                  ),
                                ),
                              ),
                              title: Text(
                                e.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                ),
                                child: Text(
                                  "${e.hour}h ${e.minute}m Break",
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  e.shiftBreakId.toString(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (!mounted) {
      return null;
    }

    return result;
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
    final isFieldStaff = attendance?.assignment?.isFieldStaff ?? false;
    final locations = attendance?.assignment?.locations;

    final nearestLocation = widget.provider.currentLatLng != null &&
            locations != null &&
            locations.isNotEmpty
        ? widget.provider.getNearestLocation(
            locations,
            widget.provider.currentLatLng!,
          )
        : null;

    final actions = widget.provider.getAvailableActions();
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
            child: !widget.provider.isAttendanceReady
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : isFieldStaff
                    ? CameraPreviewWidget(
                        provider: widget.provider,
                        showProgress: false,
                      )
                    : widget.provider.showCamera
                        ? CameraPreviewWidget(
                            provider: widget.provider,
                            showProgress: false,
                          )
                        : AttendanceLiveMapWidget(
                            provider: widget.provider,
                            officeLat: double.tryParse(
                                  nearestLocation?.lat ?? "",
                                ) ??
                                defaultLat,
                            officeLng: double.tryParse(
                                  nearestLocation?.lng ?? "",
                                ) ??
                                defaultLng,
                            radius: nearestLocation?.radiusInMeter.toDouble() ??
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: actions.map(
                (action) {
                  final isOut = action == "Out";

                  final isBreak = action.contains(
                    "Break",
                  );

                  return SizedBox(
                    width: actions.length > 1
                        ? (MediaQuery.of(context).size.width - 40) / 2
                        : double.infinity,
                    child: CustomButton(
                      isLoading: widget.provider.loadingAction == action,
                      text: action == "In"
                          ? "Punch In"
                          : action == "Out"
                              ? "Punch Out"
                              : action,
                      gradientColors: isOut
                          ? [
                              Colors.red,
                              Colors.redAccent,
                            ]
                          : isBreak
                              ? [
                                  Colors.orange,
                                  Colors.deepOrange,
                                ]
                              : [
                                  const Color(
                                    0xFF0128A1,
                                  ),
                                  const Color(
                                    0xFF404DAB,
                                  ),
                                ],
                      onTap: () => _handlePunch(
                        action,
                      ),
                    ),
                  );
                },
              ).toList(),
            )
          // Column(
          //   children: actions.map(
          //     (action) {
          //       final isOut = action == "Out";
          //
          //       final isBreak = action.contains(
          //         "Break",
          //       );
          //
          //       return Padding(
          //         padding: const EdgeInsets.only(
          //           bottom: 12,
          //         ),
          //         child: CustomButton(
          //           isLoading: widget.provider.isPunchLoading,
          //           text: action == "In"
          //               ? "Punch In"
          //               : action == "Out"
          //                   ? "Punch Out"
          //                   : action,
          //           gradientColors: isOut
          //               ? [
          //                   Colors.red,
          //                   Colors.redAccent,
          //                 ]
          //               : isBreak
          //                   ? [
          //                       Colors.orange,
          //                       Colors.deepOrange,
          //                     ]
          //                   : [
          //                       const Color(0xFF0128A1),
          //                       const Color(0xFF404DAB),
          //                     ],
          //           onTap: () => _handlePunch(
          //             action,
          //           ),
          //         ),
          //       );
          //     },
          //   ).toList(),
          // ),
        ],
      ),
    );
  }
}
