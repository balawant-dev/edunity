import 'package:edunity/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/local_storage_service.dart';
import '../../profile/provider/profile_provider.dart';
import '../../token/repo/token_repo.dart';





class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {


  @override
  Widget build(BuildContext context) {
    final profilePro = context.watch<ProfileProvider>();
    return  Drawer(
      backgroundColor: AppColors.white,
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 24),
            // color: AppColors.primary,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, 0.50),
                end: Alignment(1.00, 0.50),
                colors: [const Color(0xFF21285B), const Color(0xFF4C5DC0)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: GestureDetector(
              onTap: (){
                // navPush(context: context, action: EditProfile());
              },
              child: Column(
                children:  [
                  Stack(
                    children: [
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            width: 3,
                            color: AppColors.white,
                          ),
                        ),
                      child:     ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Image.network(
                          profilePro.profileModel!.data.photo,
                          height: 110.h,
                          width: 110.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(AppImages.logoNotFound, height: 110.h, width: 110.w, fit: BoxFit.cover);
                          },
                        ),
                      ),
                      //  child: Icon(Icons.person,size: 80,color: Colors.white,),

                      ),


                    ],
                  ),


                  SizedBox(height: 12),
                  Text(
                    profilePro.profileModel?.data?.fieldName??      "Guest User",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    profilePro.profileModel?.data?.fieldMobile??     "+91 XXXXXXX",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Menu Items ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    drawerItem(
                      icon: Icons.person_outline,
                      title: "My Profile",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.profile,
                        );


                      },
                    ),


                    drawerItem(
                      icon: Icons.lock_reset,
                      title: "Change Password",
                      onTap: () {
                        Navigator.pushNamed(

                          context,

                          AppRoutes.changePassword

                        );

                      },
                    ),
                    // drawerItem(
                    //   icon: Icons.lock_reset,
                    //   title: "Face Attendance",
                    //   onTap: () {
                    //     Navigator.pushNamed(
                    //
                    //       context,
                    //
                    //       AppRoutes.faceAttendance
                    //
                    //     );
                    //
                    //   },
                    // ),
                    drawerItem(
                      icon: Icons.support_agent,
                      title: "Help & Support",
                      onTap: () {},
                    ),
                    // About Us
                    drawerItem(
                      icon: Icons.info_outline,
                      title: "About us",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.aboutUs);
                      },
                    ),

// Privacy Policy
                    drawerItem(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                      },
                    ),

// Terms & Conditions
                    drawerItem(
                      icon: Icons.description_outlined,
                      title: "Terms & Conditions",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.termsCondition);
                      },
                    ),

// Campus Connect (naya)
                    drawerItem(
                      icon: Icons.connect_without_contact,
                      title: "Campus Connect",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.campusConnect);
                      },
                    ),
                    // drawerItem(
                    //   icon: Icons.sos,
                    //   title: "SOS",
                    //   onTap: () {
                    //
                    //   },
                    // ),

                    const Divider(height: 32, thickness: 1),

                    drawerItem(
                      icon: Icons.logout,
                      title: "Log Out",
                      onTap: () => showLogoutDialog(context),
                      color: Colors.red,
                    ),
                    const Divider(height: 32, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "v1.1.2",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget drawerItem({
    required IconData icon,
    required VoidCallback onTap,
    required String title,
    Color? color, // optional - only for special cases like logout
  }) {
    final textColor = color ?? Colors.black87;
    final iconColor = color ?? Colors.black54;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: iconColor,
            ),
             SizedBox(width: 18.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        elevation: 16,
        child: Container(
          padding:  EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 50.sp, color: Colors.redAccent),
               SizedBox(height: 16.h),
               Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(height: 10.h),
               Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              ),
               SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      logout(context);
                      // AppSettings.clearUserType();
                      // SecureStorageService.logout(context);
                      // // Navigator.pop(context, true);
                      // navPushBottomRemove(context: context, action: SplashScreen(),duration: 1);
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(
      BuildContext context,
      ) async {

    try{

      final refreshToken =
      await LocalStorageService
          .getRefreshToken();
      final TokenRepository repository =
      TokenRepository();
      if(refreshToken != null){

        await repository.logout(
          refreshToken:
          refreshToken,
        );
      }

    }catch(e){

      debugPrint(
        e.toString(),
      );

    }finally{

      await LocalStorageService
          .clearSession();

      if(context.mounted){

        Navigator.pushNamedAndRemoveUntil(

          context,

          AppRoutes.onboarding,

              (route) => false,
        );
      }
    }
  }
}