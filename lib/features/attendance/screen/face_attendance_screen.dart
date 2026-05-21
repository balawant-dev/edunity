





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

  // @override
  // void initState() {
  //   super.initState();
  //
  //   Future.microtask(() {
  //     context
  //         .read<AttendanceProvider>()
  //         .initialize();
  //   });
  // }

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