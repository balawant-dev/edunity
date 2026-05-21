import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../core/routes/app_routes.dart';
import '../model/faceImagesModel.dart';
import '../model/face_registration_model.dart';
import '../model/face_status_model.dart';
import '../model/punch_response_model.dart';
import '../model/today_attendance_model.dart';
import '../repo/attendance_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/success_attendance_dialog.dart';
class AttendanceProvider extends ChangeNotifier {

  final AttendanceRepo repo = AttendanceRepo();

  final ImagePicker picker = ImagePicker();

  bool isProcessingFrame = false;

  Timer? captureTimer;

  bool isLoading = false;

  bool isRegistering = false;

  bool isPunchLoading = false;

  FaceStatusModel? faceStatusModel;
  FaceImagesModel? faceImagesModel;
  FaceRegistrationModel? faceRegistrationModel;

  TodayAttendanceModel? todayAttendanceModel;

  PunchResponseModel? punchResponseModel;

  CameraController? cameraController;

  List<CameraDescription> cameras = [];

  late FaceDetector faceDetector;
  ///Map section ka code hai
  GoogleMapController? mapController;
  StreamSubscription<Position>? positionStream;
  LatLng? currentLatLng;

  bool isInsideRadius = false;
  double currentHeading = 0;
  double distanceInMeter = 0;

  Future<void> getCurrentLocation({
    required double officeLat,
    required double officeLng,
    required double radius,
  }) async {

    try {

      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if(!serviceEnabled){
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if(permission == LocationPermission.denied){

        permission =
        await Geolocator.requestPermission();
      }

      if(permission == LocationPermission.deniedForever){
        return;
      }

      final position =
      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      currentLatLng = LatLng(
        position.latitude,
        position.longitude,
      );

      distanceInMeter =
          Geolocator.distanceBetween(
            officeLat,
            officeLng,
            position.latitude,
            position.longitude,
          );

      isInsideRadius =
          distanceInMeter <= radius;

      notifyListeners();

    } catch (e) {

      debugPrint(e.toString());
    }
  }
  void startLiveTracking({
    required double officeLat,
    required double officeLng,
    required double radius,
  }) {

    Geolocator.getPositionStream(

      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,//2
      ),

    ).listen((position) async {

      currentLatLng = LatLng(
        position.latitude,
        position.longitude,
      );

      currentHeading = position.heading;

      distanceInMeter =
          Geolocator.distanceBetween(
            officeLat,
            officeLng,
            position.latitude,
            position.longitude,
          );

      isInsideRadius =
          distanceInMeter <= radius;

      /// AUTO CAMERA MOVE

      if(mapController != null){

        mapController!.animateCamera(

          CameraUpdate.newCameraPosition(

            CameraPosition(

              target: currentLatLng!,

              zoom: 18,

              tilt: 45,

              bearing: currentHeading,
            ),
          ),
        );
      }

      notifyListeners();
    });
  }
  ///Map section ka code hai End

  /// ============================================================
  /// PRIMARY IMAGE
  /// ============================================================

  File? primaryImage;

  /// ============================================================
  /// FACE IMAGES
  /// ============================================================

  List<File> croppedFaceImages = [];

  int captureCount = 0;

  bool isFaceValid = false;

  bool isCapturing = false;

  String instructionText = "Align your face properly";

  File? punchImage;
  int currentAngleIndex = 0;
  // List<String> angleInstructions = [
  //   "Look Straight",
  //   "Slowly Turn Left",
  //   "Slowly Turn Right",
  //   "Slightly Look Up",
  //   "Slightly Look Down",
  // ];

  List<String> angleInstructions = [
    "Look Straight",
    "Turn Face Left",
    "Turn Face Right",
    "Lift Chin Slightly Up",
    "Lower Chin Slightly Down",
  ];

  Future<void> startPunchFlow(BuildContext context, String locationId) async {
    try {
      isPunchLoading = true;
      instructionText = "Starting face scan...";
      notifyListeners();

      // 1. fetch face
      await getFaceImages();

      if (faceImagesModel == null ||
          faceImagesModel!.primaryImages == null ||
          faceImagesModel!.primaryImages!.isEmpty) {
        instructionText = "No registered face found";
        return;
      }

      // 2. start capture immediately (NO UI WAIT)
      final ok = await capturePunchImage();

      if (!ok || punchImage == null) {
        instructionText = "Face capture failed";
        return;
      }

      instructionText = "Matching face...";
      notifyListeners();

      final oldImageUrl = faceImagesModel!.primaryImages!.first.url!;
      final oldFile = await downloadImage(oldImageUrl);

      final response = await repo.newFaceMatchApi(
        oldImage: oldFile,
        newImage: punchImage!,
      );

      if (response.status == true && response.match == true) {

        // 🔥 SHOW DIALOG IMMEDIATELY
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SuccessAttendanceDialog(
              onHomePressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
            ),
          );
        }

        await punchAttendance(locationId: locationId);
      } else {
        instructionText = "Face not matched";
      }

    } catch (e) {
      instructionText = "Error during punch";
    } finally {
      isPunchLoading = false;
      notifyListeners();
    }
  }

  String getCurrentAngleInstruction() => angleInstructions[currentAngleIndex];
  /// ============================================================
  /// INIT
  /// ============================================================

  Future<void> initialize() async {
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableContours: false,
        enableClassification: false,
        enableLandmarks: false,
        enableTracking: true,
        minFaceSize: 0.15,
      ),
    );

    await initCamera();
    await getFaceStatus();
    await getTodayAttendance();
  }

  /// ============================================================
  /// CAMERA
  /// ============================================================

  Future<void> initCamera() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController?.initialize();
    await cameraController?.setFlashMode(FlashMode.off);
    notifyListeners();
  }

  /// ============================================================
  /// PICK PRIMARY IMAGE FROM CAMERA
  /// ============================================================

  /// ============================================================
  /// PICK PRIMARY IMAGE FROM CAMERA
  /// ============================================================
  ///
  // ============================================================
  // START AUTO CAPTURE - FASTER
  // ============================================================

  Future<void> startAutoCapture() async {
    if (primaryImage == null) {
      instructionText = "Please select primary image first";
      notifyListeners();
      return;
    }

    if (isCapturing) return;

    isCapturing = true;
    captureCount = 0;
    currentAngleIndex = 0;
    croppedFaceImages.clear();

    notifyListeners();

    captureTimer?.cancel();
    captureTimer = Timer.periodic(const Duration(milliseconds: 220), (timer) async {  // Faster
      if (captureCount >= 5) {
        timer.cancel();
        isCapturing = false;
        notifyListeners();
        await registerFace();
        return;
      }

      if (isProcessingFrame) return;
      isProcessingFrame = true;
      await captureAndValidateFace();
      isProcessingFrame = false;
    });
  }

  Future<void> capturePrimaryImage() async {

    try {

      /// image_picker camera open karega
      /// user manually click karega

      final XFile? image = await picker.pickImage(

        source: ImageSource.camera,

        imageQuality: 85,

        preferredCameraDevice:
        CameraDevice.front,
      );

      if (image != null) {

        primaryImage = File(image.path);

        notifyListeners();
      }

    } catch (e) {

      debugPrint(
        "PRIMARY CAMERA ERROR : $e",
      );
    }
  }
  /// ============================================================
  /// PICK PRIMARY IMAGE FROM GALLERY
  /// ============================================================

  Future<void> pickPrimaryImageFromGallery() async {

    try {

      final XFile? image = await picker.pickImage(

        source: ImageSource.gallery,
      );

      if (image != null) {

        primaryImage = File(image.path);

        notifyListeners();
      }

    } catch (e) {

      debugPrint("PRIMARY GALLERY ERROR : $e");
    }
  }

  /// ============================================================
  /// FACE STATUS
  /// ============================================================

  Future<void> getFaceStatus() async {

    try {

      isLoading = true;

      notifyListeners();

      faceStatusModel = await repo.getFaceStatus();

    } catch (e) {

      debugPrint("FACE STATUS ERROR : $e");
    }

    isLoading = false;

    notifyListeners();
  }  Future<void> getFaceImages() async {

    try {

      // isLoading = true;

      notifyListeners();

      faceImagesModel = await repo.getFaceImages();
      print(faceImagesModel!.primaryImages);

    } catch (e) {

      debugPrint("FACE STATUS ERROR : $e");
    }

    // isLoading = false;

    notifyListeners();
  }

  /// ============================================================
  /// TODAY ATTENDANCE
  /// ============================================================

  Future<void> getTodayAttendance() async {

    try {

      isLoading = true;

      notifyListeners();

      todayAttendanceModel =
      await repo.getTodayAttendance();

    } catch (e) {

      debugPrint("TODAY ATTENDANCE ERROR : $e");
    }

    isLoading = false;

    notifyListeners();
  }


  /// ============================================================
  /// CAPTURE FACE
  /// ============================================================
  // Improved Face Capture with Angle Guidance
// ============================================================
  // IMPROVED FACE CAPTURE WITH MIRROR FIX
  // ============================================================

  Future<void> captureAndValidateFace() async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) return;

      final XFile image = await cameraController!.takePicture();
      final file = File(image.path);
      final inputImage = InputImage.fromFile(file);

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        instructionText = "Face not detected";
        isFaceValid = false;
        notifyListeners();
        return;
      }

      if (faces.length > 1) {
        instructionText = "Only one face allowed";
        isFaceValid = false;
        notifyListeners();
        return;
      }

      final face = faces.first;
      final headY = face.headEulerAngleY ?? 0;   // Yaw (Left-Right)
      final headX = face.headEulerAngleX ?? 0;   // Pitch (Up-Down)
      final faceWidth = face.boundingBox.width;

      // Basic Validation
      if (faceWidth < 95) {
        instructionText = "Move closer to camera";
        isFaceValid = false;
        notifyListeners();
        return;
      }

      // Allow head movement for Up/Down angles
      if (currentAngleIndex <= 2 && headX.abs() > 18) {
        instructionText = "Keep your head straight";
        isFaceValid = false;
        notifyListeners();
        return;
      }

      // if (headX.abs() > 18) {
      //   instructionText = "Keep your head straight (no tilt)";
      //   isFaceValid = false;
      //   notifyListeners();
      //   return;
      // }

      // === MIRROR FIX - Inverted Logic for Left/Right ===
      bool isGoodAngle = false;

      switch (currentAngleIndex) {
        case 0: // Straight
          isGoodAngle = headY.abs() < 9;
          break;
        case 1: // Slowly Turn Left → Because of mirror, we check positive Y
          isGoodAngle = headY > 13;
          break;
        case 2: // Slowly Turn Right
          isGoodAngle = headY < -13;
          break;
        case 3: // Up
          isGoodAngle = headX < -7;
          break;

        case 4: // Down
          isGoodAngle = headX > 7;
          break;
      }

      if (!isGoodAngle) {
        instructionText = getCurrentAngleInstruction();
        isFaceValid = false;
        notifyListeners();
        return;
      }

      // SUCCESS
      instructionText = "Perfect! Hold...";
      isFaceValid = true;
      captureCount++;
      croppedFaceImages.add(file);

      if (captureCount < 5) {
        currentAngleIndex++;
        instructionText = getCurrentAngleInstruction();
      }

      notifyListeners();

    } catch (e) {
      debugPrint("FACE CAPTURE ERROR: $e");
    }
  }



  /// ============================================================
  /// REGISTER FACE
  /// ============================================================

  Future<void> registerFace() async {

    try {

      isRegistering = true;

      notifyListeners();

      faceRegistrationModel =
      await repo.registerFace(

        primaryImages: [primaryImage!],

        images: croppedFaceImages,
      );

      await getFaceStatus();
      // ✅ RESET UI HERE
      resetFaceScanner();

    } catch (e) {

      debugPrint("REGISTER ERROR : $e");
    }

    isRegistering = false;

    notifyListeners();
  }

  /// ============================================================
  /// PUNCH IMAGE
  /// ============================================================
  /// ============================================================
  /// AUTO PUNCH FACE SCAN
  /// ============================================================
  ///
  /// ============================================================
  /// FAST PUNCH IMAGE CAPTURE (Single Good Image)
  /// ============================================================
  Future<bool> capturePunchImage() async {
    try {
      if (cameraController == null ||
          !cameraController!.value.isInitialized ||
          isProcessingFrame) {
        return false;
      }

      isProcessingFrame = true;

      instructionText = "Scanning face...";
      isFaceValid = false;
      notifyListeners();

      // Small delay for camera stability
      await Future.delayed(const Duration(milliseconds: 120));

      final XFile image = await cameraController!.takePicture();

      final file = File(image.path);

      final inputImage = InputImage.fromFile(file);

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        instructionText = "Face not detected";
        isFaceValid = false;
        notifyListeners();
        isProcessingFrame = false;
        return false;
      }

      if (faces.length > 1) {
        instructionText = "Only one face allowed";
        isFaceValid = false;
        notifyListeners();
        isProcessingFrame = false;
        return false;
      }

      final face = faces.first;

      final headX = face.headEulerAngleX ?? 0;
      final headY = face.headEulerAngleY ?? 0;

      final faceWidth = face.boundingBox.width;

      // Relax validation थोड़ा
      if (faceWidth < 80) {
        instructionText = "Move closer";
        isFaceValid = false;
        notifyListeners();
        isProcessingFrame = false;
        return false;
      }

      if (headX.abs() > 18 || headY.abs() > 18) {
        instructionText = "Keep face straight";
        isFaceValid = false;
        notifyListeners();
        isProcessingFrame = false;
        return false;
      }

      // SUCCESS
      punchImage = file;

      isFaceValid = true;

      instructionText = "Face detected";

      notifyListeners();

      isProcessingFrame = false;

      return true;

    } catch (e) {

      debugPrint("PUNCH ERROR => $e");

      isProcessingFrame = false;

      return false;
    }
  }

  // Future<bool> capturePunchImage() async {
  //   try {
  //     if (cameraController == null || !cameraController!.value.isInitialized) {
  //       return false;
  //     }
  //
  //     isFaceValid = false;
  //     instructionText = "Align your face properly";
  //     notifyListeners();
  //
  //     int attempts = 0;
  //     const maxAttempts = 8; // Safety limit
  //
  //     while (attempts < maxAttempts) {
  //       attempts++;
  //
  //       final XFile image = await cameraController!.takePicture();
  //       final file = File(image.path);
  //       final inputImage = InputImage.fromFile(file);
  //
  //       final faces = await faceDetector.processImage(inputImage);
  //
  //       if (faces.isEmpty) {
  //         instructionText = "Face not detected";
  //         isFaceValid = false;
  //         notifyListeners();
  //         await Future.delayed(const Duration(milliseconds: 150));
  //         continue;
  //       }
  //
  //       if (faces.length > 1) {
  //         instructionText = "Only one face allowed";
  //         isFaceValid = false;
  //         notifyListeners();
  //         await Future.delayed(const Duration(milliseconds: 150));
  //         continue;
  //       }
  //
  //       final face = faces.first;
  //       final headX = face.headEulerAngleX ?? 0;
  //       final headY = face.headEulerAngleY ?? 0;
  //       final faceWidth = face.boundingBox.width;
  //
  //       if (faceWidth < 100) {
  //         instructionText = "Move closer to camera";
  //         isFaceValid = false;
  //         notifyListeners();
  //         await Future.delayed(const Duration(milliseconds: 150));
  //         continue;
  //       }
  //
  //       if (headX.abs() > 12 || headY.abs() > 12) {
  //         instructionText = "Keep face straight";
  //         isFaceValid = false;
  //         notifyListeners();
  //         await Future.delayed(const Duration(milliseconds: 150));
  //         continue;
  //       }
  //
  //       // ✅ SUCCESS - One good image is enough
  //       instructionText = "Face captured";
  //       isFaceValid = true;
  //       punchImage = file;
  //
  //       notifyListeners();
  //       return true;
  //     }
  //
  //     instructionText = "Failed to capture good face";
  //     return false;
  //   } catch (e) {
  //     debugPrint("FAST PUNCH SCAN ERROR: $e");
  //     return false;
  //   }
  // }

  // Future<bool> capturePunchImage() async {
  //
  //   try {
  //
  //     if (cameraController == null ||
  //         !cameraController!.value.isInitialized) {
  //       return false;
  //     }
  //
  //     isPunchLoading = true;
  //
  //     isFaceValid = false;
  //
  //     instructionText =
  //     "Align your face properly";
  //
  //     notifyListeners();
  //
  //     int successCount = 0;
  //
  //     List<File> validImages = [];
  //
  //     while (successCount < 2) {
  //
  //       final XFile image =
  //       await cameraController!.takePicture();
  //
  //       final file = File(image.path);
  //
  //       final inputImage =
  //       InputImage.fromFile(file);
  //
  //       final faces =
  //       await faceDetector.processImage(
  //         inputImage,
  //       );
  //
  //       /// NO FACE
  //       if (faces.isEmpty) {
  //
  //         instructionText =
  //         "Face not detected";
  //
  //         isFaceValid = false;
  //
  //         notifyListeners();
  //
  //         await Future.delayed(
  //           const Duration(milliseconds: 300),
  //         );
  //
  //         continue;
  //       }
  //
  //       /// MULTIPLE FACE
  //       if (faces.length > 1) {
  //
  //         instructionText =
  //         "Only one face allowed";
  //
  //         isFaceValid = false;
  //
  //         notifyListeners();
  //
  //         await Future.delayed(
  //           const Duration(milliseconds: 300),
  //         );
  //
  //         continue;
  //       }
  //
  //       final face = faces.first;
  //
  //       /// HEAD STRAIGHT CHECK
  //
  //       final headX =
  //           face.headEulerAngleX ?? 0;
  //
  //       final headY =
  //           face.headEulerAngleY ?? 0;
  //
  //       /// STRICT ANGLE
  //
  //       if (headX.abs() > 10 ||
  //           headY.abs() > 10) {
  //
  //         instructionText =
  //         "Keep face straight";
  //
  //         isFaceValid = false;
  //
  //         notifyListeners();
  //
  //         await Future.delayed(
  //           const Duration(milliseconds: 300),
  //         );
  //
  //         continue;
  //       }
  //
  //       /// FACE SIZE CHECK
  //
  //       final faceWidth =
  //           face.boundingBox.width;
  //
  //       if (faceWidth < 100) {
  //
  //         instructionText =
  //         "Move closer to camera";
  //
  //         isFaceValid = false;
  //
  //         notifyListeners();
  //
  //         await Future.delayed(
  //           const Duration(milliseconds: 300),
  //         );
  //
  //         continue;
  //       }
  //
  //       /// SUCCESS
  //
  //       instructionText =
  //       "Face detected successfully";
  //
  //       isFaceValid = true;
  //
  //       validImages.add(file);
  //
  //       successCount++;
  //
  //       notifyListeners();
  //
  //       await Future.delayed(
  //         const Duration(milliseconds: 250),
  //       );
  //     }
  //
  //     /// BEST IMAGE
  //
  //     punchImage = validImages.first;
  //
  //     instructionText =
  //     "Face scan completed";
  //
  //     notifyListeners();
  //
  //     return true;
  //
  //   } catch (e) {
  //
  //     debugPrint(
  //       "PUNCH SCAN ERROR : $e",
  //     );
  //
  //     return false;
  //
  //   } finally {
  //
  //     isPunchLoading = false;
  //
  //     notifyListeners();
  //   }
  // }


  /// ============================================================
  /// PUNCH ATTENDANCE
  /// ============================================================

  Future<void> punchAttendance({
    required String locationId,
  }) async {

    try {

      if (punchImage == null) return;

      // isPunchLoading = true;

      notifyListeners();

      final userType =
          todayAttendanceModel?.userType ?? "";

      if (userType == "employee") {

        punchResponseModel =
        await repo.employeePunch(

          locationId: locationId,

          punchImage: punchImage!,
        );

      } else {

        punchResponseModel =
        await repo.studentPunch(

          locationId: locationId,

          punchImage: punchImage!,
        );
      }

      await getTodayAttendance();
      // ✅ RESET UI HERE
      resetFaceScanner();

    } catch (e) {

      debugPrint("PUNCH ERROR : $e");
    }

    // isPunchLoading = false;

    notifyListeners();
  }

  /// VERIFY FACE & PUNCH (Optimized)
  /// ============================================================

  Future<bool> verifyFaceAndPunch(BuildContext context) async {
    try {
      isPunchLoading = true;
      instructionText = "Verifying face...";
      // instructionText = "Verifying face...";
      notifyListeners();

      // await getFaceImages();

      if (faceImagesModel == null ||
          faceImagesModel!.primaryImages == null ||
          faceImagesModel!.primaryImages!.isEmpty) {
        instructionText = "No registered face found";
        return false;
      }

      // Fast Capture (Only 1 good image)
      final captureSuccess = await capturePunchImage();

      if (!captureSuccess || punchImage == null) {
        instructionText = "Face capture failed";
        return false;
      }

      instructionText = "Matching face...";
      notifyListeners();

      // Download registered image
      final oldImageUrl = faceImagesModel!.primaryImages!.first.url ?? "";
      final oldImageFile = await downloadImage(oldImageUrl);

      // Face Match API
      final response = await repo.newFaceMatchApi(
        oldImage: oldImageFile,
        newImage: punchImage!,
      );






      if (response.status == true && (response.match ?? false)) {
        instructionText = "Face matched successfully";
        notifyListeners();
        // Show Success Dialog
  // Make sure you pass context
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (context.mounted) {
  //           showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (context) => SuccessAttendanceDialog(
  //               onHomePressed: () {
  //                 Navigator.pushReplacementNamed(
  //                   context,
  //                   AppRoutes.home,
  //                 );
  //               },
  //             ),
  //           );
  //         }
  //       });

        return true;
      } else {
        instructionText = "Face not matched";
        return false;
      }
    } catch (e) {
      debugPrint("VERIFY FACE ERROR => $e");
      instructionText = "Face verification failed";
      return false;
    } finally {
      isPunchLoading = false;
      notifyListeners();
    }
  }

  // Future<bool> verifyFaceAndPunch() async {
  //
  //   try {
  //     isPunchLoading = true;
  //     instructionText = "Verifying face...";
  //     notifyListeners();                    // ←←← Important
  //
  //     await getFaceImages();
  //
  //     if (faceImagesModel == null ||
  //         faceImagesModel!.primaryImages == null ||
  //         faceImagesModel!.primaryImages!.isEmpty) {
  //
  //       instructionText = "No registered face found";
  //       notifyListeners();
  //       return false;
  //     }
  //
  //     /// LIVE FACE
  //     final captureSuccess = await capturePunchImage();
  //
  //     if (!captureSuccess || punchImage == null) {
  //
  //       instructionText = "Face capture failed";
  //       notifyListeners();
  //       return false;
  //     }
  //
  //     /// GET URL
  //     final oldImageUrl =
  //         faceImagesModel!.primaryImages!.first.url ?? "";
  //
  //     /// 🔥 DOWNLOAD OLD IMAGE (IMPORTANT FIX)
  //     final oldImageFile = await downloadImage(oldImageUrl);
  //
  //     // Face Match API Call
  //     instructionText = "Matching face...";
  //     notifyListeners();
  //
  //     /// FACE MATCH API (FILE + FILE)
  //     final response = await repo.newFaceMatchApi(
  //       oldImage: oldImageFile,   // ✅ File pass karo
  //       newImage: punchImage!,
  //     );
  //     if (response.status == true && (response.match ?? false)) {
  //       print("✅ Face Match Successful");
  //       instructionText = "Face matched successfully";
  //       return true;
  //     } else {
  //       instructionText = "Face not matched";
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint("VERIFY FACE ERROR => $e");
  //     instructionText = "Face verification failed";
  //     return false;
  //   } finally {
  //     isPunchLoading = false;
  //     notifyListeners();
  //   }
  // }
  Future<File> downloadImage(String url) async {
    try {
      final dio = Dio();

      // temp directory
      final dir = await getTemporaryDirectory();

      // local file path
      final filePath = '${dir.path}/old_face.jpg';

      // download image
      await dio.download(url, filePath);

      // return local file
      return File(filePath);
    } catch (e) {
      debugPrint("DOWNLOAD IMAGE ERROR => $e");
      rethrow;
    }
  }

  void resetFaceScanner() {
    isFaceValid = false;
    isCapturing = false;
    isProcessingFrame = false;

    captureCount = 0;
    currentAngleIndex = 0;

    instructionText = "Align your face properly";

    croppedFaceImages.clear();
    punchImage = null;

    notifyListeners();
  }
  @override
  void dispose() {
    captureTimer?.cancel();
    positionStream?.cancel();
    cameraController?.dispose();
    faceDetector.close();
    super.dispose();
  }
}