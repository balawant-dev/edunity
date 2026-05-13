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

        enableContours: true,

        enableClassification: true,

        enableLandmarks: true,

        enableTracking: true,

        performanceMode: FaceDetectorMode.accurate,
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
      camera.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(

      frontCamera,

      ResolutionPreset.high,

      enableAudio: false,

      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await cameraController?.initialize();

    notifyListeners();
  }

  /// ============================================================
  /// PICK PRIMARY IMAGE FROM CAMERA
  /// ============================================================

  Future<void> capturePrimaryImage() async {

    try {

      if (cameraController == null) return;

      final XFile file =
      await cameraController!.takePicture();

      primaryImage = File(file.path);

      notifyListeners();

    } catch (e) {

      debugPrint("PRIMARY CAMERA ERROR : $e");
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

      const Duration(milliseconds: 1200),

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

      File file = File(image.path);

      final inputImage =
      InputImage.fromFile(file);

      final faces =
      await faceDetector.processImage(inputImage);

      if (faces.length != 1) {

        instructionText =
        "Only one face allowed";

        notifyListeners();

        return;
      }

      final face = faces.first;

      final leftEye =
          face.leftEyeOpenProbability ?? 0;

      final rightEye =
          face.rightEyeOpenProbability ?? 0;

      if (leftEye < 0.6 || rightEye < 0.6) {

        instructionText =
        "Open your eyes properly";

        notifyListeners();

        return;
      }

      final headX =
          face.headEulerAngleX ?? 0;

      final headY =
          face.headEulerAngleY ?? 0;

      if (headX.abs() > 15 ||
          headY.abs() > 15) {

        instructionText =
        "Keep head straight";

        notifyListeners();

        return;
      }

      final faceWidth =
          face.boundingBox.width;

      if (faceWidth < 150) {

        instructionText =
        "Move closer to camera";

        notifyListeners();

        return;
      }

      instructionText =
      "Face detected successfully";

      isFaceValid = true;

      captureCount++;

      croppedFaceImages.add(file);

      notifyListeners();

    } catch (e) {

      debugPrint("FACE CAPTURE ERROR : $e");
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

  Future<void> capturePunchImage() async {

    if (cameraController == null) return;

    final XFile image =
    await cameraController!.takePicture();

    punchImage = File(image.path);

    notifyListeners();
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