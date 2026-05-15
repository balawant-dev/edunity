import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../provider/attendance_provider.dart';

class AttendanceLiveMapWidget extends StatelessWidget {

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
  Widget build(BuildContext context) {

    if(provider.currentLatLng == null){

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

            myLocationButtonEnabled: true,

            zoomControlsEnabled: false,

            compassEnabled: true,

            mapToolbarEnabled: false,

            initialCameraPosition: CameraPosition(

              target: provider.currentLatLng!,

              zoom: 17,
            ),

            onMapCreated: (controller) {

              provider.mapController = controller;
            },

            markers: {

              /// OFFICE MARKER
              Marker(

                markerId: const MarkerId("office"),

                position: LatLng(
                  officeLat,
                  officeLng,
                ),

                infoWindow: const InfoWindow(
                  title: "Office",
                ),
              ),

              /// USER MARKER
              Marker(

                markerId: const MarkerId("user"),

                position: provider.currentLatLng!,

                rotation: provider.currentHeading,

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
                  officeLat,
                  officeLng,
                ),

                radius: radius,

                fillColor:

                provider.isInsideRadius

                    ? Colors.green.withOpacity(.2)

                    : Colors.red.withOpacity(.2),

                strokeColor:

                provider.isInsideRadius

                    ? Colors.green

                    : Colors.red,

                strokeWidth: 3,
              ),
            },

            polylines: {

              Polyline(

                polylineId: const PolylineId("route"),

                points: [

                  provider.currentLatLng!,

                  LatLng(
                    officeLat,
                    officeLng,
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

                    provider.isInsideRadius

                        ? Icons.check_circle

                        : Icons.navigation,

                    color:

                    provider.isInsideRadius

                        ? Colors.green

                        : Colors.orange,
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(

                          provider.isInsideRadius

                              ? "You reached attendance area"

                              : "Move towards office location",

                          style: const TextStyle(

                            fontWeight:
                            FontWeight.bold,

                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(

                          "Distance : ${provider.distanceInMeter.toStringAsFixed(0)} Meter",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}