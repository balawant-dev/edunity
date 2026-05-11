/// =============================
/// 2. LOGIN MODEL
/// login_model.dart
/// =============================

class LoginModel {

  final bool status;

  final String accessToken;

  final String refreshToken;

  final int expiresIn;

  final String userType;

  final LoginUser user;

  final LoginCollege college;

  LoginModel({
    required this.status,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.userType,
    required this.user,
    required this.college,
  });

  factory LoginModel.fromJson(
      Map<String, dynamic> json){

    return LoginModel(

      status: json["status"] ?? false,

      accessToken:
      json["access_token"] ?? "",

      refreshToken:
      json["refresh_token"] ?? "",

      expiresIn:
      json["expires_in"] ?? 0,

      userType:
      json["user_type"] ?? "",

      user: LoginUser.fromJson(
        json["user"] ?? {},
      ),

      college: LoginCollege.fromJson(
        json["college"] ?? {},
      ),
    );
  }
}

class LoginUser {

  final String uid;

  final String userId;

  final String email;

  final String name;

  final String mobile;

  LoginUser({
    required this.uid,
    required this.userId,
    required this.email,
    required this.name,
    required this.mobile,
  });

  factory LoginUser.fromJson(
      Map<String, dynamic> json){

    return LoginUser(

      uid: json["uid"].toString(),

      userId:
      json["user_id"] ?? "",

      email:
      json["email"] ?? "",

      name:
      json["field_name"] ?? "",

      mobile:
      json["field_mobile"] ?? "",
    );
  }
}

class LoginCollege {

  final String gid;

  final String name;

  final String fullName;

  final String logo;

  LoginCollege({
    required this.gid,
    required this.name,
    required this.fullName,
    required this.logo,
  });

  factory LoginCollege.fromJson(
      Map<String, dynamic> json){

    return LoginCollege(

      gid: json["gid"].toString(),

      name: json["name"] ?? "",

      fullName:
      json["full_name"] ?? "",

      logo: json["logo"] ?? "",
    );
  }
}