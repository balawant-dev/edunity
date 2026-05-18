// import 'package:edunity/common/widgets/custom_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/attendance_provider.dart';
//
// class AttendanceMapScreen extends StatefulWidget {
//
//   final double officeLat;
//   final double officeLng;
//   final double radius;
//
//   const AttendanceMapScreen({
//     super.key,
//     required this.officeLat,
//     required this.officeLng,
//     required this.radius,
//   });
//
//   @override
//   State<AttendanceMapScreen> createState() =>
//       _AttendanceMapScreenState();
// }
//
// class _AttendanceMapScreenState
//     extends State<AttendanceMapScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.microtask(() {
//
//       final provider =
//       context.read<AttendanceProvider>();
//
//       provider.getCurrentLocation(
//
//         officeLat: widget.officeLat,
//         officeLng: widget.officeLng,
//         radius: widget.radius,
//       );
//
//       // provider.startLiveTracking(
//       //
//       //   officeLat: widget.officeLat,
//       //   officeLng: widget.officeLng,
//       //   radius: widget.radius,
//       // );
//     });
//   }
//   @override
//   void dispose() {
//
//     final provider =
//     context.read<AttendanceProvider>();
//
//     provider.mapController?.dispose();
//
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     final provider =
//     context.watch<AttendanceProvider>();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       appBar: CustomAppBar(
//         title: "Attendance Area",
//       ),
//
//       body: provider.currentLatLng == null
//
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//
//           : Stack(
//
//         children: [
//
//           GoogleMap(
//
//             initialCameraPosition: CameraPosition(
//
//               target: LatLng(
//                 widget.officeLat,
//                 widget.officeLng,
//               ),
//
//               zoom: 17,
//             ),
//
//             myLocationEnabled: true,
//
//             myLocationButtonEnabled: true,
//
//             circles: {
//
//               Circle(
//
//                 circleId:
//                 const CircleId("office"),
//
//                 center: LatLng(
//                   widget.officeLat,
//                   widget.officeLng,
//                 ),
//
//                 radius: widget.radius,
//
//                 fillColor:
//
//                 provider.isInsideRadius
//
//                     ? Colors.green.withOpacity(.25)
//
//                     : Colors.red.withOpacity(.25),
//
//                 strokeWidth: 2,
//
//                 strokeColor:
//
//                 provider.isInsideRadius
//
//                     ? Colors.green
//
//                     : Colors.red,
//               ),
//             },
//
//             markers: {
//
//               Marker(
//
//                 markerId:
//                 const MarkerId("office"),
//
//                 position: LatLng(
//                   widget.officeLat,
//                   widget.officeLng,
//                 ),
//
//                 infoWindow:
//                 const InfoWindow(
//                   title: "Office Location",
//                 ),
//               ),
//
//               Marker(
//
//                 markerId:
//                 const MarkerId("current"),
//
//                 position:
//                 provider.currentLatLng!,
//
//                 infoWindow:
//                 const InfoWindow(
//                   title: "You",
//                 ),
//               ),
//             },
//
//             onMapCreated: (controller) {
//
//               provider.mapController =
//                   controller;
//             },
//           ),
//
//           Positioned(
//
//             left: 16,
//             right: 16,
//             bottom: 20,
//
//             child: Container(
//
//               padding:
//               const EdgeInsets.all(18),
//
//               decoration: BoxDecoration(
//
//                 color: Colors.white,
//
//                 borderRadius:
//                 BorderRadius.circular(20),
//
//                 boxShadow: const [
//
//                   BoxShadow(
//                     blurRadius: 10,
//                     color: Colors.black12,
//                   ),
//                 ],
//               ),
//
//               child: Column(
//
//                 mainAxisSize:
//                 MainAxisSize.min,
//
//                 children: [
//
//                   Row(
//
//                     children: [
//
//                       Icon(
//
//                         provider.isInsideRadius
//
//                             ? Icons.check_circle
//
//                             : Icons.cancel,
//
//                         color:
//                         provider.isInsideRadius
//
//                             ? Colors.green
//
//                             : Colors.red,
//                       ),
//
//                       const SizedBox(width: 10),
//
//                       Expanded(
//
//                         child: Text(
//
//                           provider.isInsideRadius
//
//                               ? "You are inside office attendance area"
//
//                               : "You are outside office area",
//
//                           style: const TextStyle(
//
//                             fontWeight:
//                             FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   Row(
//
//                     children: [
//
//                       const Text(
//                         "Distance : ",
//                       ),
//
//                       Text(
//
//                         "${provider.distanceInMeter.toStringAsFixed(2)} Meter",
//
//                         style: const TextStyle(
//                           fontWeight:
//                           FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }