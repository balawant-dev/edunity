class ApiEndpoints {
  static const String baseUrl = "https://edunityerp.com";
  // static const String baseUrl = "https://evidyapeeth.co.in";

  static const String findCollege = "/api/find-college";
  static const String login = "/api/edu-login";

  static const String forgotPassword = "/api/forgot-password";

  static const String verifyOtp = "/api/verify-otp";

  static const String resetPassword = "/api/reset-password";
  static const String changePassword = "/api/change-password";
  static const String tokenCheck = "/api/token-check";

  static const String refreshToken = "/api/refresh-token";

  static const String logout = "/api/edu-logout";
  static const String myProfile = "/api/my-profile";

  /// FACE ATTENDANCE
  static const String faceStatus = "/api/face-status";

  static const String registerFace = "/api/register-face";

  static const String todayAttendance = "/api/today-attendance";
  static const String faceImages = "/api/face-images";

  static const String employeePunch = "/api/employee/punch";

  static const String studentPunch = "/api/student/punch";

  static const String activeEmployees = "/api/employees/active";
  static const String managerRegisterFace =
      "/api/manager/employee/register-face";
  static const String managerTodayAttendance =
      "/api/manager/employee/today-attendance";

  static const String managerEmployeePunch = "/api/manager/employee/punch";

  static const attendanceReport = "/api/employee/attendance-report";

  ///CMS Section URL
  static const String privacyPolicy = "/api/privacy-policy";
  static const String aboutUs = "/api/about-us";
  static const String termsCondition = "/api/terms-condition";
  static const String campusConnect = "/api/campus-connect";
}
