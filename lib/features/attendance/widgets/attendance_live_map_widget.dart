import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../provider/attendance_provider.dart';

class AttendanceLiveMapWidget extends StatefulWidget {
  final AttendanceProvider provider;

  final double officeLat;
  final double officeLng;
  final double radius;

  const AttendanceLiveMapWidget({
    super.key,
    required this.provider,
    required this.officeLat,
    required this.officeLng,
    required this.radius,
  });

  @override
  State<AttendanceLiveMapWidget> createState() =>
      _AttendanceLiveMapWidgetState();
}

class _AttendanceLiveMapWidgetState extends State<AttendanceLiveMapWidget> {
  bool _isRecentering = false;

  Future<void> _recenterToCurrentLocation() async {
    try {
      if (_isRecentering) return;

      setState(() {
        _isRecentering = true;
      });

      /// Fresh GPS location
      await widget.provider.getCurrentLocation(
        officeLat: widget.officeLat,
        officeLng: widget.officeLng,
        radius: widget.radius,
      );

      final controller = widget.provider.mapController;
      final pos = widget.provider.currentLatLng;

      if (controller == null || pos == null) {
        return;
      }

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: pos,
            zoom: 19,
            tilt: 45,
            bearing: widget.provider.currentHeading,
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        "RECENTER ERROR => $e",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRecentering = false;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.provider.disposeMap();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provider.currentLatLng == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.provider.currentLatLng!,
              zoom: 17,
            ),
            onMapCreated: (controller) {
              widget.provider.mapController = controller;
            },
            markers: {
              /// OFFICE MARKER
              Marker(
                markerId: const MarkerId("office"),
                position: LatLng(
                  widget.officeLat,
                  widget.officeLng,
                ),
                infoWindow: const InfoWindow(
                  title: "Office",
                ),
              ),

              /// USER MARKER
              Marker(
                markerId: const MarkerId("user"),
                position: widget.provider.currentLatLng!,
                rotation: widget.provider.currentHeading,
                flat: true,
                anchor: const Offset(0.5, 0.5),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
                infoWindow: const InfoWindow(
                  title: "You",
                ),
              ),
            },
            circles: {
              Circle(
                circleId: const CircleId("radius"),
                center: LatLng(
                  widget.officeLat,
                  widget.officeLng,
                ),
                radius: widget.radius,
                fillColor: widget.provider.isInsideRadius
                    ? Colors.green.withOpacity(.2)
                    : Colors.red.withOpacity(.2),
                strokeColor:
                    widget.provider.isInsideRadius ? Colors.green : Colors.red,
                strokeWidth: 3,
              ),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: [
                  widget.provider.currentLatLng!,
                  LatLng(
                    widget.officeLat,
                    widget.officeLng,
                  ),
                ],
                width: 5,
                color: Colors.blue,
              ),
            },
          ),

          /// TOP CARD

          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    widget.provider.isInsideRadius
                        ? Icons.check_circle
                        : Icons.navigation,
                    color: widget.provider.isInsideRadius
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.provider.isInsideRadius
                              ? "You reached attendance area"
                              : "Move towards office location",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Distance : ${widget.provider.distanceInMeter.toStringAsFixed(0)} Meter",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 18,
            bottom: 22,
            child: Material(
              color: Colors.transparent,
              elevation: 10,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _isRecentering ? null : _recenterToCurrentLocation,
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.12),
                        blurRadius: 16,
                        offset: const Offset(
                          0,
                          6,
                        ),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isRecentering
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                            ),
                          )
                        : const Icon(
                            Icons.my_location_rounded,
                            color: Color(
                              0xff1E63FF,
                            ),
                            size: 28,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
