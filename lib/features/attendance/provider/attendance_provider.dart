import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
// import 'package:face_verification/face_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/routes/app_routes.dart';
import '../../home/model/home_model.dart';
import '../../profile/provider/profile_provider.dart';
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

import '../service/face_recognition_service.dart';
import '../widgets/success_attendance_dialog.dart';
import 'package:image/image.dart' as img;
import 'dart:math';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceRepo repo = AttendanceRepo();
  final Random _random = Random();

  final ImagePicker picker = ImagePicker();

  bool isProcessingFrame = false;

  bool isCapturing = false;

  bool isLivenessPassed = false;

  bool isFaceCentered = false;

  bool isBrightnessGood = false;

  bool isBlurGood = false;

  bool isEyesOpen = false;

  double latestBrightness = 0;

  String livenessInstruction = "";

  int livenessStep = 0;

  Timer? captureTimer;

  bool isLoading = false;

  bool isRegistering = false;

  bool isPunchLoading = false;

  FaceStatusModel? faceStatusModel;
  FaceImagesModel? faceImagesModel;
  FaceRegistrationModel? faceRegistrationModel;

  TodayAttendanceModel? managerTodayAttendanceModel;

  TodayAttendanceModel? todayAttendanceModel;

  PunchResponseModel? punchResponseModel;

  CameraController? cameraController;

  List<CameraDescription> cameras = [];

  late FaceDetector faceDetector;

  List<List<double>> managerEmployeeEmbeddings = [];

  ///Map section ka code hai
  GoogleMapController? mapController;
  StreamSubscription<Position>? positionStream;
  LatLng? currentLatLng;

  bool isLocationLoading = true;
  bool isInsideRadius = false;
  double currentHeading = 0;
  double distanceInMeter = 0;

  bool showCamera = false;

  bool isAttendanceReady = false;

  bool _embeddingsPrepared = false;

  Future<void> prepareLocalEmbeddingsFromServer() async {
    try {
      debugPrint("RESTORE START");

      await FaceRecognitionService.instance.init();

      if (faceImagesModel == null) {
        debugPrint("FACE IMAGES NULL -> FETCH");
        await getFaceImages();
      }

      debugPrint(
        "PRIMARY=${faceImagesModel?.primaryImages?.length} "
        "REF=${faceImagesModel?.referenceImages?.length}",
      );

      List<File> files = [];

      for (final image in faceImagesModel?.primaryImages ?? []) {
        debugPrint("DOWNLOAD PRIMARY => ${image.url}");
        final file = await downloadImage(image.url!);
        debugPrint("DOWNLOADED => ${file.path}");
        files.add(file);
      }

      for (final image in faceImagesModel?.referenceImages ?? []) {
        debugPrint("DOWNLOAD REF => ${image.url}");
        final file = await downloadImage(image.url!);
        debugPrint("DOWNLOADED => ${file.path}");
        files.add(file);
      }

      debugPrint("FILES => ${files.length}");

      final embeddings = await FaceRecognitionService.instance
          .generateEmbeddingsFromFiles(files);

      debugPrint("EMBEDDINGS => ${embeddings.length}");

      await FaceRecognitionService.instance.saveEmbeddings(
        embeddings,
      );
      _embeddingsPrepared = true;

      debugPrint(
        "LOCAL EMBEDDINGS RESTORED => ${embeddings.length}",
      );
      final saved = await FaceRecognitionService.instance.getSavedEmbeddings();

      debugPrint(
        "LOCAL EMBEDDINGS RESTORED => ${saved?.length}",
      );
    } catch (e) {
      debugPrint("RESTORE ERROR => $e");
    }
  }

  Future<void> prepareManagerEmployeeEmbeddings() async {
    try {
      managerEmployeeEmbeddings = [];

      if (faceImagesModel == null || faceImagesModel!.primaryImages == null) {
        return;
      }

      List<File> files = [];

      /// PRIMARY
      for (final image in faceImagesModel!.primaryImages!) {
        if (image.url == null) {
          continue;
        }

        final file = await downloadImage(
          image.url!,
        );

        files.add(
          file,
        );
      }

      /// OTHER IMAGES
      if (faceImagesModel!.referenceImages != null) {
        for (final image in faceImagesModel!.referenceImages!) {
          if (image.url == null) {
            continue;
          }

          final file = await downloadImage(
            image.url!,
          );

          files.add(
            file,
          );
        }
      }

      managerEmployeeEmbeddings =
          await FaceRecognitionService.instance.generateEmbeddingsFromFiles(
        files,
      );

      debugPrint(
        "EMPLOYEE EMBEDDINGS => ${managerEmployeeEmbeddings.length}",
      );
    } catch (e) {
      debugPrint(
        "EMBED BUILD ERROR $e",
      );
    }
  }

  LocationModel? getNearestLocation(
    List<LocationModel> locations,
    LatLng userLatLng,
  ) {
    if (locations.isEmpty) {
      return null;
    }

    LocationModel nearest = locations.first;

    double nearestDistance = double.infinity;

    for (final location in locations) {
      final lat = double.tryParse(
        location.lat,
      );

      final lng = double.tryParse(
        location.lng,
      );

      if (lat == null || lng == null) {
        continue;
      }

      final distance = Geolocator.distanceBetween(
        userLatLng.latitude,
        userLatLng.longitude,
        lat,
        lng,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;

        nearest = location;
      }
    }

    debugPrint(
      "NEAREST LOCATION => ${nearest.name} | ${nearest.locationId} | ${nearestDistance.toStringAsFixed(2)} m",
    );

    return nearest;
  }

  Future<void> getCurrentLocation({
    required double officeLat,
    required double officeLng,
    required double radius,
  }) async {
    try {
      isLocationLoading = true;
      notifyListeners();
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      currentLatLng = LatLng(
        position.latitude,
        position.longitude,
      );

      distanceInMeter = Geolocator.distanceBetween(
        officeLat,
        officeLng,
        position.latitude,
        position.longitude,
      );

      debugPrint("===== LOCATION CHECK =====");
      debugPrint("OFFICE LAT=$officeLat LNG=$officeLng");
      debugPrint("USER LAT=${position.latitude} LNG=${position.longitude}");
      debugPrint("RADIUS=$radius");
      debugPrint("DISTANCE=$distanceInMeter");
      debugPrint("INSIDE=$isInsideRadius");

      isInsideRadius = distanceInMeter <= radius;
      isLocationLoading = false;

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLocationLoading = false;
      notifyListeners();
    }
  }

  bool _stepHapticTriggered = false;

  Future<void> triggerStepSuccessHaptic() async {
    try {
      if (_stepHapticTriggered) return;

      _stepHapticTriggered = true;

      HapticFeedback.lightImpact();

      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          duration: 70,
          amplitude: 120,
        );
      }
    } catch (_) {}
  }

  Future<void> triggerWarningHaptic() async {
    try {
      HapticFeedback.mediumImpact();

      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          duration: 140,
          amplitude: 180,
        );
      }
    } catch (_) {}
  }

  Future<void> triggerFinalSuccessHaptic() async {
    try {
      HapticFeedback.heavyImpact();

      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          pattern: [0, 90, 50, 140],
        );
      }
    } catch (_) {}
  }

  void resetStepHaptic() {
    _stepHapticTriggered = false;
  }

  // void startLiveTracking({
  //   required double officeLat,
  //   required double officeLng,
  //   required double radius,
  // }) {
  //   Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.bestForNavigation,
  //       distanceFilter: 5, //2
  //     ),
  //   ).listen((position) async {
  //     currentLatLng = LatLng(
  //       position.latitude,
  //       position.longitude,
  //     );
  //
  //     currentHeading = position.heading;
  //
  //     distanceInMeter = Geolocator.distanceBetween(
  //       officeLat,
  //       officeLng,
  //       position.latitude,
  //       position.longitude,
  //     );
  //
  //     isInsideRadius = distanceInMeter <= radius;
  //
  //     /// AUTO CAMERA MOVE
  //
  //     if (mapController != null) {
  //       mapController!.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: currentLatLng!,
  //             zoom: 18,
  //             tilt: 45,
  //             bearing: currentHeading,
  //           ),
  //         ),
  //       );
  //     }
  //
  //     notifyListeners();
  //   });
  // }
  void startLiveTracking({
    required double officeLat,
    required double officeLng,
    required double radius,
  }) {
    /// avoid duplicate listeners
    positionStream?.cancel();

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 8,
      ),
    ).listen(
      (position) async {
        currentLatLng = LatLng(
          position.latitude,
          position.longitude,
        );

        currentHeading = position.heading;

        distanceInMeter = Geolocator.distanceBetween(
          officeLat,
          officeLng,
          position.latitude,
          position.longitude,
        );

        isInsideRadius = distanceInMeter <= radius;

        debugPrint("===== LIVE TRACK =====");
        debugPrint("OFFICE=$officeLat,$officeLng");
        debugPrint("USER=${position.latitude},${position.longitude}");
        debugPrint("DIST=${distanceInMeter.toStringAsFixed(2)}");
        debugPrint("RADIUS=$radius");
        debugPrint("INSIDE=$isInsideRadius");

        showCamera = distanceInMeter <= radius;

        /// SAFE CAMERA MOVE
        final controller = mapController;

        if (controller != null) {
          try {
            await controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: currentLatLng!,
                  zoom: 18,
                  tilt: 45,
                  bearing: currentHeading,
                ),
              ),
            );
          } catch (e) {
            debugPrint(
              "MAP CAMERA IGNORE => $e",
            );
          }
        }

        notifyListeners();
      },
    );
  }

  void disposeMap() {
    mapController = null;

    positionStream?.cancel();

    positionStream = null;
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
  int _poseStableCount = 0;
  void resetPoseStability() {
    _poseStableCount = 0;
  }

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
      // await getFaceImages();

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

      // final oldImageUrl = faceImagesModel!.primaryImages!.first.url!;
      // final oldFile = await downloadImage(oldImageUrl);
      //
      // final response = await repo.newFaceMatchApi(
      //   oldImage: oldFile,
      //   newImage: punchImage!,
      // );
      //
      // if (response.status == true && response.match == true) {
      //
      //   // 🔥 SHOW DIALOG IMMEDIATELY
      //   if (context.mounted) {
      //     showDialog(
      //       context: context,
      //       barrierDismissible: false,
      //       builder: (_) => SuccessAttendanceDialog(
      //         onHomePressed: () {
      //           Navigator.pushReplacementNamed(context, AppRoutes.home);
      //         },
      //       ),
      //     );
      //   }
      //
      //   await punchAttendance(locationId: locationId);
      // } else {
      //   instructionText = "Face not matched";
      // }

      final matched = await verifyFaceAndPunch(
        context,
      );

      if (matched) {
        final actions = getAvailableActions();

        if (actions.isEmpty) {
          instructionText = "No attendance action available";

          notifyListeners();

          return;
        }

        String action = actions.first;

        String breakId = "";

        /// START BREAK
        if (action == "Start Break") {
          instructionText = "Select break";

          notifyListeners();

          return;
        }

        await punchAttendance(
          locationId: locationId,
          action: action,
          breakId: breakId,
          context: context,
        );
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

  void generateLivenessChallenge() {
    livenessStep = _random.nextInt(3);

    switch (livenessStep) {
      case 0:
        livenessInstruction = "Blink both eyes";
        break;

      case 1:
        livenessInstruction = "Turn face left";
        break;

      case 2:
        livenessInstruction = "Turn face right";
        break;
    }

    notifyListeners();
  }

  bool validateFaceEnterprise(
    Face face,
    img.Image image,
  ) {
    final yaw = face.headEulerAngleY ?? 0;
    final pitch = face.headEulerAngleX ?? 0;

    final width = face.boundingBox.width;
    final height = face.boundingBox.height;

    final leftEye = face.leftEyeOpenProbability ?? 0;
    final rightEye = face.rightEyeOpenProbability ?? 0;

    if (width < 140 || height < 140) {
      instructionText = "Move closer";
      return false;
    }

    /// SMART ANGLE QUALITY
    switch (currentAngleIndex) {
      /// Straight
      case 0:
        if (yaw.abs() > 15 || pitch.abs() > 15) {
          instructionText = "Keep face straight";
          return false;
        }
        break;

      /// Left
      case 1:
        if (yaw < 10) {
          instructionText = "Turn face left";
          return false;
        }
        break;

      /// Right
      case 2:
        if (yaw > -10) {
          instructionText = "Turn face right";
          return false;
        }
        break;

      /// Up
      case 3:
        if (pitch < 6) {
          instructionText = "Lift chin slightly";
          return false;
        }
        break;

      /// Down
      case 4:
        if (pitch > -6) {
          instructionText = "Lower chin slightly";
          return false;
        }
        break;
    }

    if (leftEye < 0.30 || rightEye < 0.30) {
      instructionText = "Keep eyes open";
      return false;
    }

    final centerX = face.boundingBox.center.dx;
    final imageCenter = image.width / 2;

    if ((centerX - imageCenter).abs() > 110) {
      instructionText = "Center your face";
      return false;
    }

    return true;
  }

  double calculateBrightness(
    img.Image image,
  ) {
    double total = 0;

    for (int y = 0; y < image.height; y += 4) {
      for (int x = 0; x < image.width; x += 4) {
        final p = image.getPixel(x, y);

        total += (0.299 * p.r) + (0.587 * p.g) + (0.114 * p.b);
      }
    }

    final brightness = total / ((image.width / 4) * (image.height / 4));

    latestBrightness = brightness;

    return brightness;
  }

  bool validateBrightness(
    double value,
  ) {
    if (value < 65) {
      instructionText = "Too dark";
      return false;
    }

    if (value > 250) {
      instructionText = "Too bright";
      return false;
    }

    return true;
  }

  bool validateBlur(
    img.Image image,
  ) {
    double diff = 0;

    for (int y = 1; y < image.height - 1; y += 5) {
      for (int x = 1; x < image.width - 1; x += 5) {
        final p1 = image.getPixel(
          x,
          y,
        );

        final p2 = image.getPixel(
          x + 1,
          y,
        );

        diff += (p1.r - p2.r).abs();
      }
    }

    if (diff < 50000) {
      instructionText = "Image blurry";
      return false;
    }

    return true;
  }

  /// ============================================================
  /// INIT
  /// ============================================================

  Future<void> initialize() async {
    faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableContours: false,
        enableClassification: true,
        enableLandmarks: true,
        enableTracking: true,
        minFaceSize: 0.15,
      ),
    );
    await FaceRecognitionService.instance.init();

    await initCamera();
    await getFaceStatus();
    await getFaceImages();
    final saved = await FaceRecognitionService.instance.getSavedEmbeddings();

    if (saved == null || saved.isEmpty) {
      await prepareLocalEmbeddingsFromServer();
    } else {
      _embeddingsPrepared = true;
      debugPrint("USING LOCAL FACE PROFILE");
    }
    await getTodayAttendance();
  }

  /// ============================================================
  /// CAMERA
  /// ============================================================

  // Future<void> initCamera() async {
  //   cameras = await availableCameras();
  //   final frontCamera = cameras.firstWhere(
  //     (camera) => camera.lensDirection == CameraLensDirection.front,
  //   );
  //
  //   cameraController = CameraController(
  //     frontCamera,
  //     ResolutionPreset.high,
  //     enableAudio: false,
  //     imageFormatGroup: ImageFormatGroup.yuv420,
  //   );
  //
  //   await cameraController?.initialize();
  //   await cameraController?.setFlashMode(FlashMode.off);
  //   notifyListeners();
  // }

  Future<void> initCamera() async {
    cameras = await availableCameras();

    final front = cameras.firstWhere(
      (e) => e.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(
      front,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await cameraController!.initialize();

    await cameraController!.setFlashMode(
      FlashMode.off,
    );

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
      instructionText = "Select primary image";

      notifyListeners();
      return;
    }

    if (isCapturing) return;

    isCapturing = true;

    captureCount = 0;

    currentAngleIndex = 0;

    croppedFaceImages.clear();

    instructionText = getCurrentAngleInstruction();

    notifyListeners();

    captureTimer?.cancel();

    captureTimer = Timer.periodic(
      const Duration(
        milliseconds: 350,
      ),
      (timer) async {
        if (isProcessingFrame) {
          return;
        }

        if (captureCount >= 5) {
          timer.cancel();

          isCapturing = false;

          await triggerFinalSuccessHaptic();

          notifyListeners();

          /// SELF / MANAGER SWITCH
          if (isManagerFlow) {
            debugPrint(
              "MANAGER FLOW REGISTER",
            );

            return;
          }

          debugPrint(
            "SELF FLOW REGISTER",
          );

          await registerFace();

          return;
        }

        isProcessingFrame = true;

        await captureAndValidateFace();

        isProcessingFrame = false;
      },
    );
  }

  Future<void> capturePrimaryImage() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
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
  }

  Future<void> getFaceImages() async {
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

      todayAttendanceModel = await repo.getTodayAttendance();
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
      if (cameraController == null ||
          !cameraController!.value.isInitialized ||
          cameraController!.value.isTakingPicture) {
        return;
      }

      final XFile image = await cameraController!.takePicture();

      final file = File(image.path);

      final bytes = await file.readAsBytes();

      final decoded = img.decodeImage(bytes);

      if (decoded == null) {
        instructionText = "Image error";

        notifyListeners();
        return;
      }

      /// =======================
      /// BRIGHTNESS
      /// =======================

      final brightness = calculateBrightness(
        decoded,
      );

      if (!validateBrightness(
        brightness,
      )) {
        isFaceValid = false;
        notifyListeners();
        return;
      }

      /// =======================
      /// BLUR
      /// =======================

      if (!validateBlur(
        decoded,
      )) {
        isFaceValid = false;
        notifyListeners();
        return;
      }

      /// =======================
      /// FACE DETECT
      /// =======================

      final input = InputImage.fromFile(
        file,
      );

      final faces = await faceDetector.processImage(
        input,
      );

      if (faces.isEmpty) {
        instructionText = "Face not detected";

        isFaceValid = false;

        notifyListeners();
        return;
      }

      if (faces.length > 1) {
        instructionText = "Only one face";

        isFaceValid = false;

        notifyListeners();
        return;
      }

      final face = faces.first;

      /// =======================
      /// ENTERPRISE QUALITY
      /// =======================

      final valid = validateFaceEnterprise(
        face,
        decoded,
      );

      if (!valid) {
        isFaceValid = false;
        notifyListeners();
        return;
      }

      /// =======================
      /// ANGLE VALIDATION
      /// =======================

      final yaw = face.headEulerAngleY ?? 0;

      final pitch = face.headEulerAngleX ?? 0;
      bool goodAngle = false;

      switch (currentAngleIndex) {
        /// Straight
        case 0:
          goodAngle = yaw.abs() < 12;
          break;

        /// Left
        case 1:
          goodAngle = yaw > 8;
          break;

        /// Right
        case 2:
          goodAngle = yaw < -8;
          break;

        /// Up
        case 3:
          goodAngle = pitch > 5;
          break;

        /// Down
        case 4:
          goodAngle = pitch < -5;
          break;
      }

      if (!goodAngle) {
        resetPoseStability();

        instructionText = getCurrentAngleInstruction();

        isFaceValid = false;

        notifyListeners();
        return;
      }

      /// ENTERPRISE STABILITY
      _poseStableCount++;

      if (_poseStableCount < 2) {
        instructionText = "Hold ${getCurrentAngleInstruction()}";

        notifyListeners();
        return;
      }

      resetPoseStability();
      //
      // bool goodAngle = false;
      //
      // switch (currentAngleIndex) {
      //   case 0:
      //     goodAngle = yaw.abs() < 8;
      //     break;
      //
      //   case 1:
      //     goodAngle = yaw > 8;
      //     break;
      //
      //   case 2:
      //     goodAngle = yaw < -8;
      //     break;
      //   case 3:
      //     goodAngle = pitch > 5;
      //     break;
      //
      //   case 4:
      //     goodAngle = pitch < -5;
      //     break;
      // }
      //
      // if (!goodAngle) {
      //   instructionText = getCurrentAngleInstruction();
      //
      //   isFaceValid = false;
      //
      //   notifyListeners();
      //   return;
      // }

      /// =======================
      /// SUCCESS
      /// =======================

      isFaceValid = true;

      await triggerStepSuccessHaptic();

      instructionText = "${getCurrentAngleInstruction()} Done ✓";

      /// Avoid duplicates
      if (croppedFaceImages.length < 5) {
        croppedFaceImages.add(file);

        captureCount++;
      }

      if (captureCount < 5) {
        currentAngleIndex++;

        resetPoseStability();
        resetStepHaptic();

        instructionText = getCurrentAngleInstruction();
      }

      notifyListeners();
    } catch (e) {
      debugPrint(
        "REGISTER CAPTURE ERROR => $e",
      );
    }
  }

  /// ============================================================
  /// REGISTER FACE
  /// ============================================================
  ///api
  // Future<void> registerFace() async {
  //
  //   try {
  //
  //     isRegistering = true;
  //
  //     notifyListeners();
  //
  //     debugPrint("REGISTER trhrowwehdwhd : ${primaryImage!.path}");
  //
  //     faceRegistrationModel =
  //     await repo.registerFace(
  //
  //       primaryImages: [primaryImage!],
  //
  //       images: croppedFaceImages,
  //     );
  //
  //     final prefs = await SharedPreferences.getInstance();
  //
  //     await prefs.setString(
  //       "profile_id",
  //       faceRegistrationModel?.profileId ?? "",
  //     );
  //
  //     debugPrint("REGISTER trhrowwehdwhd : ${primaryImage!.path}");
  //
  //     await FaceVerification.instance.init();
  //
  //     await FaceVerification.instance.registerFromImagePath(
  //
  //       id: faceRegistrationModel?.profileId ?? "",
  //
  //       imagePath: primaryImage!.path,
  //
  //       imageId: 'work_id',
  //     );
  //     debugPrint("REGISTER trhrowwehdwhd : ${primaryImage!.path}");
  //
  //     await getFaceStatus();
  //     // ✅ RESET UI HERE
  //     resetFaceScanner();
  //
  //   } catch (e) {
  //
  //     debugPrint("REGISTER ERROR : $e");
  //   }
  //
  //   isRegistering = false;
  //
  //   notifyListeners();
  // }
  Future<void> registerFaceSingleImage() async {
    try {
      if (primaryImage == null) return;

      isRegistering = true;

      instructionText = "Processing face...";

      notifyListeners();

      final inputImage = InputImage.fromFile(
        primaryImage!,
      );

      final faces = await faceDetector.processImage(
        inputImage,
      );

      if (faces.isEmpty) {
        instructionText = "No face detected";

        return;
      }

      if (faces.length > 1) {
        instructionText = "Only one face allowed";

        return;
      }

      final face = faces.first;

      final valid = validateFaceQuality(face);

      if (!valid) {
        return;
      }

      instructionText = "Extracting features...";

      notifyListeners();

      final embedding = await FaceRecognitionService.instance.extractEmbedding(
        primaryImage!,
        face,
      );

      // await FaceRecognitionService.instance.saveSingleEmbedding(
      //   embedding,
      // );

      instructionText = "Uploading registration...";

      notifyListeners();

      faceRegistrationModel = await repo.registerFace(
        primaryImages: [primaryImage!],
        images: [primaryImage!],
      );

      instructionText = "Face registered successfully";

      await getFaceStatus();

      resetFaceScanner();
    } catch (e) {
      debugPrint(
        "REGISTER ERROR => $e",
      );

      instructionText = "Registration failed";
    } finally {
      isRegistering = false;

      notifyListeners();
    }
  }

  bool validateFaceQuality(
    Face face,
  ) {
    final width = face.boundingBox.width;

    final height = face.boundingBox.height;

    final yaw = face.headEulerAngleY ?? 0;

    final pitch = face.headEulerAngleX ?? 0;

    final left = face.leftEyeOpenProbability ?? 0;

    final right = face.rightEyeOpenProbability ?? 0;

    if (width < 140 || height < 140) {
      instructionText = "Move closer";

      return false;
    }

    if (yaw.abs() > 15 || pitch.abs() > 15) {
      instructionText = "Keep face straight";

      return false;
    }

    if (left < 0.40 || right < 0.40) {
      instructionText = "Keep eyes open";

      return false;
    }

    return true;
  }

  ///below okay for multiple image

  Future<void> registerFace() async {
    try {
      if (primaryImage == null) {
        return;
      }

      if (croppedFaceImages.isEmpty) {
        instructionText = "Capture face angles";

        return;
      }

      isRegistering = true;

      instructionText = "Preparing registration...";

      notifyListeners();

      final input = InputImage.fromFile(
        primaryImage!,
      );

      final faces = await faceDetector.processImage(input);

      if (faces.isEmpty) {
        instructionText = "No face found";

        return;
      }

      final primaryFace = faces.first;

      /// =======================
      /// MULTI EMBEDDINGS
      /// =======================

      List<List<double>> embeddings = [];

      instructionText = "Building face profile...";

      notifyListeners();

      /// PRIMARY

      final primaryEmbedding =
          await FaceRecognitionService.instance.extractEmbedding(
        primaryImage!,
        primaryFace,
      );

      embeddings.add(
        primaryEmbedding,
      );

      /// ANGLES

      for (final image in croppedFaceImages) {
        final inputImage = InputImage.fromFile(
          image,
        );

        final detected = await faceDetector.processImage(
          inputImage,
        );

        if (detected.isEmpty) {
          continue;
        }

        final emb = await FaceRecognitionService.instance.extractEmbedding(
          image,
          detected.first,
        );

        embeddings.add(
          emb,
        );
      }

      if (embeddings.length < 3) {
        instructionText = "Poor registration quality";

        return;
      }

      /// SAVE LOCAL

      await FaceRecognitionService.instance.saveEmbeddings(
        embeddings,
      );

      instructionText = "Uploading registration...";

      notifyListeners();

      /// SERVER

      faceRegistrationModel = await repo.registerFace(
        primaryImages: [
          primaryImage!,
        ],
        images: croppedFaceImages,
      );

      instructionText = "Registration successful";

      notifyListeners();

      await getFaceStatus();

      resetFaceScanner();
    } catch (e) {
      debugPrint(
        "REGISTER ERROR => $e",
      );

      instructionText = "Registration failed";
    } finally {
      isRegistering = false;

      notifyListeners();
    }
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
          cameraController!.value.isTakingPicture) {
        return false;
      }

      isFaceValid = false;
      instructionText = "Align your face";
      notifyListeners();

      int attempts = 0;
      const maxAttempts = 6;

      while (attempts < maxAttempts) {
        attempts++;

        final XFile image = await cameraController!.takePicture();

        final file = File(image.path);

        final bytes = await file.readAsBytes();

        final decoded = img.decodeImage(bytes);

        if (decoded == null) {
          continue;
        }

        final brightness = calculateBrightness(decoded);

        if (!validateBrightness(brightness)) {
          await Future.delayed(
            const Duration(milliseconds: 150),
          );
          continue;
        }

        if (!validateBlur(decoded)) {
          await Future.delayed(
            const Duration(milliseconds: 150),
          );
          continue;
        }

        final input = InputImage.fromFile(file);

        final faces = await faceDetector.processImage(input);

        if (faces.isEmpty) {
          instructionText = "Face not detected";
          notifyListeners();
          continue;
        }

        if (faces.length > 1) {
          instructionText = "Only one face";
          notifyListeners();
          continue;
        }

        final face = faces.first;

        final valid = validateFaceEnterprise(
          face,
          decoded,
        );

        if (!valid) {
          notifyListeners();
          continue;
        }

        /// ONE GOOD IMAGE
        punchImage = file;

        isFaceValid = true;

        instructionText = "Face captured";

        notifyListeners();

        return true;
      }

      instructionText = "Could not capture face";

      return false;
    } catch (e) {
      debugPrint(
        "PUNCH ERROR => $e",
      );

      return false;
    }
  }

  ///
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

  List<String> getAvailableActions() {
    final summary = todayAttendanceModel?.attendanceSummary;

    final timeline = summary?.timeline ?? [];

    final isStudent = todayAttendanceModel?.userType == "student";

    /// STUDENT FLOW
    if (isStudent) {
      if (timeline.isEmpty) {
        return ["In"];
      }

      final last = timeline.last.type;

      if (last == "In") {
        return ["Out"];
      }

      return [];
    }

    /// EMPLOYEE FLOW

    if (timeline.isEmpty) {
      return ["In"];
    }

    final last = timeline.last.type;

    switch (last) {
      case "In":
        return [
          "Start Break",
          "Out",
        ];

      case "Start Break":
        return [
          "End Break",
        ];

      case "End Break":
        return [
          "Out",
        ];

      case "Out":
        return ["In"];

      default:
        return ["In"];
    }
  }

  /// ============================================================
  /// PUNCH ATTENDANCE
  /// ============================================================

  Future<void> punchAttendance({
    required String locationId,
    required String action,
    required String breakId,
    required BuildContext context,
  }) async {
    try {
      if (punchImage == null) return;

      // isPunchLoading = true;

      notifyListeners();

      final userType = todayAttendanceModel?.userType ?? "";
      final lat = currentLatLng?.latitude ?? 0;

      final lng = currentLatLng?.longitude ?? 0;
      if (userType == "employee") {
        punchResponseModel = await repo.employeePunch(
            locationId: locationId,
            punchImage: punchImage!,
            lat: lat,
            lng: lng,
            action: action,
            breakId: breakId);
      } else {
        punchResponseModel = await repo.studentPunch(
          locationId: locationId,
          punchImage: punchImage!,
          lat: lat,
          lng: lng,
          action: action,
        );
      }
      final summary = todayAttendanceModel?.attendanceSummary;

      final isPunchIn = summary?.timeline == null ||
          summary!.timeline.isEmpty ||
          summary.timeline.last.type != "In";

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final profile = context.read<ProfileProvider>().profileModel;
          return AttendanceSuccessPopup(
            action: action,
            employeeName: profile?.data.fieldName ?? "",
            employeeId: profile?.data.userId ?? "",
            imageUrl: profile?.data.photo ?? "",
            onHomeTap: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.home,
              );
            },
          );
        },
      );
      // Navigator.pushReplacementNamed(
      //
      //   context,
      //
      //   AppRoutes.home,
      // );

      await getTodayAttendance();

      // ✅ RESET UI HERE
      resetFaceScanner();
    } catch (e) {
      debugPrint("PUNCH dfsdfERROR : $e");
    }

    // isPunchLoading = false;

    notifyListeners();
  }

  /// VERIFY FACE & PUNCH (Optimized)
  /// ============================================================

  // Future<bool> verifyFaceAndPunch(BuildContext context) async {
  //   try {
  //     isPunchLoading = true;
  //     instructionText = "Verifying face...";
  //     // instructionText = "Verifying face...";
  //     notifyListeners();
  //
  //     // await getFaceImages();
  //
  //     if (faceImagesModel == null ||
  //         faceImagesModel!.primaryImages == null ||
  //         faceImagesModel!.primaryImages!.isEmpty) {
  //       instructionText = "No registered face found";
  //       return false;
  //     }
  //
  //     // Fast Capture (Only 1 good image)
  //     final captureSuccess = await capturePunchImage();
  //
  //     if (!captureSuccess || punchImage == null) {
  //       instructionText = "Face capture failed";
  //       return false;
  //     }
  //
  //     instructionText = "Matching face...";
  //     notifyListeners();
  //
  //     // Download registered image
  //     final oldImageUrl = faceImagesModel!.primaryImages!.first.url ?? "";
  //     final oldImageFile = await downloadImage(oldImageUrl);
  //
  //     // Face Match API
  //     final response = await repo.newFaceMatchApi(
  //       oldImage: oldImageFile,
  //       newImage: punchImage!,
  //     );
  //
  //
  //
  //
  //
  //
  //     if (response.status == true && (response.match ?? false)) {
  //       instructionText = "Face matched successfully";
  //       notifyListeners();
  //       // Show Success Dialog
  // // Make sure you pass context
  // //       WidgetsBinding.instance.addPostFrameCallback((_) {
  // //         if (context.mounted) {
  // //           showDialog(
  // //             context: context,
  // //             barrierDismissible: false,
  // //             builder: (context) => SuccessAttendanceDialog(
  // //               onHomePressed: () {
  // //                 Navigator.pushReplacementNamed(
  // //                   context,
  // //                   AppRoutes.home,
  // //                 );
  // //               },
  // //             ),
  // //           );
  // //         }
  // //       });
  //
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

  ///forSingle
  //   Future<bool> verifyFaceAndPunch(
  //       BuildContext context,
  //       ) async {
  //
  //     try {
  //
  //       isPunchLoading = true;
  //
  //       instructionText =
  //       "Scanning face...";
  //
  //       notifyListeners();
  //
  //       final captured =
  //       await capturePunchImage();
  //
  //       if (!captured ||
  //           punchImage == null) {
  //
  //         return false;
  //       }
  //
  //       final inputImage =
  //       InputImage.fromFile(
  //         punchImage!,
  //       );
  //
  //       final faces =
  //       await faceDetector.processImage(
  //         inputImage,
  //       );
  //
  //       if (faces.isEmpty) {
  //         return false;
  //       }
  //
  //       final embedding =
  //       await FaceRecognitionService.instance
  //           .extractEmbedding(
  //         punchImage!,
  //         faces.first,
  //       );
  //
  //       final matched =
  //       await FaceRecognitionService.instance
  //           .verifyFace(
  //         embedding,
  //       );
  //
  //       if (!matched) {
  //
  //         instructionText =
  //         "Face not matched";
  //
  //         return false;
  //       }
  //
  //       instructionText =
  //       "Face matched";
  //
  //       return true;
  //
  //     } catch (e) {
  //
  //       instructionText =
  //       "Verification failed";
  //
  //       return false;
  //
  //     } finally {
  //
  //       isPunchLoading = false;
  //
  //       notifyListeners();
  //     }
  //   }
  ///fjhdfjals Thikm hai below
  Future<bool> verifyFaceAndPunch(
    BuildContext context,
  ) async {
    try {
      isPunchLoading = true;

      instructionText = "Preparing verification...";

      notifyListeners();

      /// ===========================
      /// CAPTURE
      /// ===========================

      final captured = await capturePunchImage();

      if (!captured || punchImage == null) {
        instructionText = "Face capture failed";

        return false;
      }

      /// ===========================
      /// LIVENESS
      /// ===========================

      instructionText = "Analyzing face...";

      notifyListeners();

      /// ===========================
      /// DETECT FACE
      /// ===========================

      final input = InputImage.fromFile(
        punchImage!,
      );

      final faces = await faceDetector.processImage(
        input,
      );

      if (faces.isEmpty) {
        instructionText = "No face detected";

        return false;
      }

      if (faces.length > 1) {
        instructionText = "Multiple faces detected";

        return false;
      }

      final face = faces.first;

      /// ===========================
      /// FINAL QUALITY CHECK
      /// ===========================

      final bytes = await punchImage!.readAsBytes();

      final decoded = img.decodeImage(
        bytes,
      );

      if (decoded == null) {
        instructionText = "Image error";

        return false;
      }

      final valid = validateFaceEnterprise(
        face,
        decoded,
      );

      if (!valid) {
        instructionText = "Poor face quality";

        return false;
      }

      /// ===========================
      /// EMBEDDING
      /// ===========================

      instructionText = "Matching face...";

      notifyListeners();

      final currentEmbedding =
          await FaceRecognitionService.instance.extractEmbedding(
        punchImage!,
        face,
      );

      /// ===========================
      /// VERIFY
      /// ===========================

      // final matched = await FaceRecognitionService.instance.verifyFace(
      //   currentEmbedding,
      // );
      if (!isManagerFlow) {
        if (!_embeddingsPrepared) {
          instructionText = "Loading face profile...";
          notifyListeners();

          await prepareLocalEmbeddingsFromServer();
        }
      }

      bool matched = false;

      if (isManagerFlow) {
        matched =
            await FaceRecognitionService.instance.verifyFaceAgainstEmbeddings(
          currentEmbedding,
          managerEmployeeEmbeddings,
        );
        // matched = await FaceRecognitionService.instance.verifyFace(
        //   currentEmbedding,
        // );
      } else {
        matched = await FaceRecognitionService.instance.verifyFace(
          currentEmbedding,
        );
      }

      if (!matched) {
        instructionText = "Face not matched";

        notifyListeners();

        return false;
      }

      /// ===========================
      /// SUCCESS
      /// ===========================

      instructionText = "Face verified";

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint(
        "VERIFY ERROR => $e",
      );

      instructionText = "Verification failed";

      return false;
    } finally {
      isPunchLoading = false;

      notifyListeners();
    }
  }

  ///okeay above
  // Future<bool> verifyFaceAndPunch(
  //     BuildContext context) async {
  //
  //   try {
  //
  //     isPunchLoading = true;
  //
  //     instructionText = "Verifying face...";
  //
  //     notifyListeners();
  //
  //     final captureSuccess =
  //     await capturePunchImage();
  //
  //     if (!captureSuccess || punchImage == null) {
  //
  //       instructionText =
  //       "Face capture failed";
  //
  //       return false;
  //     }
  //
  //     instructionText = "Matching face...";
  //
  //     notifyListeners();
  //
  //     final prefs =
  //     await SharedPreferences.getInstance();
  //
  //     final profileId =
  //         prefs.getString("profile_id") ?? "";
  //
  //     final result =
  //     await FaceVerification.instance.verifyFromImagePath(
  //
  //       staffId: profileId,
  //
  //       imagePath: punchImage!.path,
  //     );       instructionText =
  //     "Face matched successfully";
  //
  //     notifyListeners();
  //
  //     return true;
  //
  //     // if (result!.isVerified) {
  //     //
  //     //
  //     //
  //     // } else {
  //     //
  //     //   instructionText =
  //     //   "Face not matched";
  //     //
  //     //   notifyListeners();
  //     //
  //     //   return false;
  //     // }
  //
  //   } catch (e) {
  //
  //     debugPrint(
  //         "VERIFY FACE ERROR => $e");
  //
  //     instructionText =
  //     "Face verification failed";
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
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    final dir = await getTemporaryDirectory();

    final file = File(
      '${dir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg',
    );

    await file.writeAsBytes(
      response.data,
    );

    return file;
  }

  void resetFaceScanner() {
    isFaceValid = false;
    isManagerFlow = false;
    isCapturing = false;

    isProcessingFrame = false;

    isLivenessPassed = false;

    livenessInstruction = "";

    latestBrightness = 0;

    captureCount = 0;

    currentAngleIndex = 0;

    instructionText = "Align your face";

    croppedFaceImages.clear();

    punchImage = null;

    notifyListeners();
  }

  // void resetFaceScanner() {
  //   isFaceValid = false;
  //   isCapturing = false;
  //   isProcessingFrame = false;
  //
  //   captureCount = 0;
  //   currentAngleIndex = 0;
  //
  //   instructionText = "Align your face properly";
  //
  //   croppedFaceImages.clear();
  //   punchImage = null;
  //
  //   notifyListeners();
  // }
  @override
  void dispose() {
    captureTimer?.cancel();
    positionStream?.cancel();
    cameraController?.dispose();
    faceDetector.close();

    FaceRecognitionService.instance.dispose();
    super.dispose();
  }

  ///manager 26.5
  int? selectedEmployeeUid;

  bool isManagerFlow = false;

  String? loadingAction;

  void setManagerFlow(bool value) {
    isManagerFlow = value;
    notifyListeners();
  }

  void selectEmployee(int uid) {
    selectedEmployeeUid = uid;
    notifyListeners();
  }

  Future<void> registerEmployeeByManager() async {
    try {
      if (selectedEmployeeUid == null) {
        instructionText = "Employee not selected";
        return;
      }

      if (primaryImage == null) {
        instructionText = "Select primary image";
        return;
      }

      if (croppedFaceImages.isEmpty) {
        instructionText = "Capture face angles";
        return;
      }

      isRegistering = true;

      instructionText = "Submitting employee registration...";

      notifyListeners();

      faceRegistrationModel = await repo.managerRegisterEmployeeFace(
        uid: selectedEmployeeUid!,
        primaryImages: [
          primaryImage!,
        ],
        images: croppedFaceImages,
      );
      isManagerFlow = false;
      instructionText = "Employee face submitted";

      resetFaceScanner();
    } catch (e) {
      debugPrint(
        "MANAGER REGISTER ERROR $e",
      );

      instructionText = "Registration failed";
    } finally {
      isRegistering = false;
      notifyListeners();
    }
  }

  String? managerAttendanceError;

  Future<void> getManagerEmployeeAttendance(
    int uid,
  ) async {
    try {
      isLoading = true;

      managerAttendanceError = null;

      managerTodayAttendanceModel = null;

      notifyListeners();

      final response = await repo.apiClient.get(
        "${ApiEndpoints.managerTodayAttendance}?uid=$uid",
      );

      /// 403 / BUSINESS FAILURE
      if (response.statusCode == 403 || response.data["status"] == false) {
        managerAttendanceError = response.data["message"] ??
            "Employee is not assigned to any Shift or Location.";

        return;
      }

      /// SUCCESS
      managerTodayAttendanceModel = TodayAttendanceModel.fromJson(
        response.data,
      );
    } catch (e) {
      debugPrint(
        "MANAGER ATTENDANCE ERROR $e",
      );

      managerAttendanceError = "Unable to fetch attendance.";
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> managerPunchAttendance({
    required int uid,
    required String locationId,
    required BuildContext context,
  }) async {
    try {
      if (punchImage == null) {
        return;
      }

      isPunchLoading = true;

      notifyListeners();

      punchResponseModel = await repo.managerEmployeePunch(
        uid: uid,
        locationId: locationId,
        punchImage: punchImage!,
      );
    } catch (e) {
      debugPrint(
        "MANAGER PUNCH ERROR $e",
      );
    } finally {
      isPunchLoading = false;

      notifyListeners();
    }
  }

  List<AttendanceCardModel> get attendanceCards {
    final attendance = todayAttendanceModel?.attendanceSummary;
    final shift = todayAttendanceModel?.assignment?.shift;

    if (attendance == null) return [];

    return [
      AttendanceCardModel(
        title: "Status",
        value: attendance.status ?? '-',
        subtitle: "${attendance.totalPunches} Punches",
        bottomText: attendance.dayName,
        color:
            attendance.status == "Present" ? AppColors2.green : Colors.orange,
        icon: Icons.check_circle,
      ),
      AttendanceCardModel(
        title: "Punch In",
        value: formatTimestamp(attendance.punchInTime),
        subtitle: attendance.timeline.isNotEmpty
            ? attendance.timeline.first.note
            : "",
        bottomText: "Sch: ${shift?.startTime ?? '--'}",
        color: AppColors2.blue,
        icon: Icons.login,
      ),
      AttendanceCardModel(
        title: "Punch Out",
        value: formatTimestamp(attendance.punchOutTime),
        subtitle: attendance.workingHours ?? "00:00",
        bottomText: "Sch: ${shift?.endTime ?? '--'}",
        color: AppColors2.textDark,
        icon: Icons.logout,
      ),
      AttendanceCardModel(
        title: "Location",
        value: attendance.timeline.isNotEmpty
            ? attendance.timeline.first.location
            : "--",
        subtitle: attendance.timeline.isNotEmpty
            ? attendance.timeline.first.type
            : "",
        bottomText: "Field Staff",
        color: AppColors2.green,
        icon: Icons.location_on,
      ),
    ];
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null || timestamp == 0) return "--";

    return DateFormat("hh:mm a")
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }
}
