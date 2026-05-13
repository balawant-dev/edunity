import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../model/face_status_model.dart';
import '../model/punch_response_model.dart';
import '../model/today_attendance_model.dart';
import '../repo/attendance_repo.dart';
import 'package:image_picker/image_picker.dart';
class AttendanceProvider extends ChangeNotifier {

  final AttendanceRepo repo = AttendanceRepo();

  final ImagePicker picker = ImagePicker();

  bool isProcessingFrame = false;

  Timer? captureTimer;

  bool isLoading = false;

  bool isRegistering = false;

  bool isPunchLoading = false;

  FaceStatusModel? faceStatusModel;

  TodayAttendanceModel? todayAttendanceModel;

  PunchResponseModel? punchResponseModel;

  CameraController? cameraController;

  List<CameraDescription> cameras = [];

  late FaceDetector faceDetector;

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

  /// ============================================================
  /// INIT
  /// ============================================================

  Future<void> initialize() async {

    faceDetector = FaceDetector(

      options: FaceDetectorOptions(

        performanceMode:
        FaceDetectorMode.fast,

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

          (camera) =>
      camera.lensDirection ==
          CameraLensDirection.front,
    );

    cameraController = CameraController(

      frontCamera,

      /// HIGH se medium karo
      ResolutionPreset.medium,

      enableAudio: false,

      imageFormatGroup:
      ImageFormatGroup.yuv420,
    );

    await cameraController?.initialize();

    /// FLASH OFF
    await cameraController?.setFlashMode(
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
  /// START FACE REGISTRATION FLOW
  /// ============================================================

  Future<void> startAutoCapture() async {

    if (primaryImage == null) {

      instructionText =
      "Please select primary image first";

      notifyListeners();

      return;
    }

    if (isCapturing) return;

    isCapturing = true;

    captureCount = 0;

    croppedFaceImages.clear();

    notifyListeners();

    captureTimer?.cancel();

    captureTimer = Timer.periodic(

      const Duration(milliseconds: 450),

          (timer) async {

        if (captureCount >= 20) {

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
      },
    );
  }

  /// ============================================================
  /// CAPTURE FACE
  /// ============================================================

  Future<void> captureAndValidateFace() async {

    try {

      if (cameraController == null ||
          !cameraController!.value.isInitialized) {
        return;
      }

      final XFile image =
      await cameraController!.takePicture();

      final file = File(image.path);

      final inputImage =
      InputImage.fromFile(file);

      final faces =
      await faceDetector.processImage(
        inputImage,
      );

      /// FACE CHECK
      if (faces.isEmpty) {

        instructionText =
        "Face not detected";

        isFaceValid = false;

        notifyListeners();

        return;
      }

      if (faces.length > 1) {

        instructionText =
        "Only one face allowed";

        isFaceValid = false;

        notifyListeners();

        return;
      }

      final face = faces.first;

      /// FACE SIZE
      final faceWidth =
          face.boundingBox.width;

      if (faceWidth < 80) {

        instructionText =
        "Move closer";

        isFaceValid = false;

        notifyListeners();

        return;
      }

      /// HEAD ROTATION
      final headY =
          face.headEulerAngleY ?? 0;

      if (headY.abs() > 10) {

        instructionText =
        "Keep face straight";

        isFaceValid = false;

        notifyListeners();

        return;
      }

      /// SUCCESS
      instructionText =
      "Face detected";

      isFaceValid = true;

      captureCount++;

      /// ONLY STORE SOME IMAGES
      if (captureCount % 2 == 0) {
        croppedFaceImages.add(file);
      }

      notifyListeners();

    } catch (e) {

      debugPrint(
        "FACE CAPTURE ERROR : $e",
      );
    }
  }

  /// ============================================================
  /// REGISTER FACE
  /// ============================================================

  Future<void> registerFace() async {

    try {

      isRegistering = true;

      notifyListeners();

      faceStatusModel =
      await repo.registerFace(

        primaryImages: [primaryImage!],

        images: croppedFaceImages,
      );

      await getFaceStatus();

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

  Future<bool> capturePunchImage() async {

    try {

      if (cameraController == null ||
          !cameraController!.value.isInitialized) {
        return false;
      }

      isPunchLoading = true;

      isFaceValid = false;

      instructionText =
      "Align your face properly";

      notifyListeners();

      int successCount = 0;

      List<File> validImages = [];

      while (successCount < 2) {

        final XFile image =
        await cameraController!.takePicture();

        final file = File(image.path);

        final inputImage =
        InputImage.fromFile(file);

        final faces =
        await faceDetector.processImage(
          inputImage,
        );

        /// NO FACE
        if (faces.isEmpty) {

          instructionText =
          "Face not detected";

          isFaceValid = false;

          notifyListeners();

          await Future.delayed(
            const Duration(milliseconds: 300),
          );

          continue;
        }

        /// MULTIPLE FACE
        if (faces.length > 1) {

          instructionText =
          "Only one face allowed";

          isFaceValid = false;

          notifyListeners();

          await Future.delayed(
            const Duration(milliseconds: 300),
          );

          continue;
        }

        final face = faces.first;

        /// HEAD STRAIGHT CHECK

        final headX =
            face.headEulerAngleX ?? 0;

        final headY =
            face.headEulerAngleY ?? 0;

        /// STRICT ANGLE

        if (headX.abs() > 10 ||
            headY.abs() > 10) {

          instructionText =
          "Keep face straight";

          isFaceValid = false;

          notifyListeners();

          await Future.delayed(
            const Duration(milliseconds: 300),
          );

          continue;
        }

        /// FACE SIZE CHECK

        final faceWidth =
            face.boundingBox.width;

        if (faceWidth < 100) {

          instructionText =
          "Move closer to camera";

          isFaceValid = false;

          notifyListeners();

          await Future.delayed(
            const Duration(milliseconds: 300),
          );

          continue;
        }

        /// SUCCESS

        instructionText =
        "Face detected successfully";

        isFaceValid = true;

        validImages.add(file);

        successCount++;

        notifyListeners();

        await Future.delayed(
          const Duration(milliseconds: 250),
        );
      }

      /// BEST IMAGE

      punchImage = validImages.first;

      instructionText =
      "Face scan completed";

      notifyListeners();

      return true;

    } catch (e) {

      debugPrint(
        "PUNCH SCAN ERROR : $e",
      );

      return false;

    } finally {

      isPunchLoading = false;

      notifyListeners();
    }
  }


  /// ============================================================
  /// PUNCH ATTENDANCE
  /// ============================================================

  Future<void> punchAttendance({
    required String locationId,
  }) async {

    try {

      if (punchImage == null) return;

      isPunchLoading = true;

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

    } catch (e) {

      debugPrint("PUNCH ERROR : $e");
    }

    isPunchLoading = false;

    notifyListeners();
  }
}