// import 'package:shared_preferences/shared_preferences.dart';
//
// class LocalStorageService {
//
//   static Future<void> saveToken(
//       String token) async {
//
//     final prefs =
//     await SharedPreferences.getInstance();
//
//     await prefs.setString("token", token);
//   }
//
//   static Future<String?> getToken() async {
//
//     final prefs =
//     await SharedPreferences.getInstance();
//
//     return prefs.getString("token");
//   }
//
//   static Future<void> clearSession() async {
//
//     final prefs =
//     await SharedPreferences.getInstance();
//
//     await prefs.clear();
//   }
// }


/// ===============================
/// LOCAL STORAGE SERVICE
/// ===============================

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {

  static const String tokenKey =
      "access_token";

  static const String refreshTokenKey =
      "refresh_token";

  /// SAVE ACCESS TOKEN
  static Future<void> saveToken(
      String token) async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setString(
      tokenKey,
      token,
    );
  }

  /// GET ACCESS TOKEN
  static Future<String?> getToken()
  async {

    final prefs =
    await SharedPreferences
        .getInstance();

    return prefs.getString(
      tokenKey,
    );
  }

  /// SAVE REFRESH TOKEN
  static Future<void>
  saveRefreshToken(
      String refreshToken,
      ) async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setString(
      refreshTokenKey,
      refreshToken,
    );
  }

  /// GET REFRESH TOKEN
  static Future<String?>
  getRefreshToken() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    return prefs.getString(
      refreshTokenKey,
    );
  }

  /// CLEAR SESSION
  static Future<void>
  clearSession() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.clear();
  }
}