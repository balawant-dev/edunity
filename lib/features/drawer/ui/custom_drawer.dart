import 'package:edunity/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
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
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 24),
            color: AppColors.primary,
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
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            width: 3,
                            color: AppColors.white,
                          ),
                        ),
                      child:     ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          profilePro.profileModel!.data.photo,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(AppImages.logoNotFound, height: 80, width: 80, fit: BoxFit.cover);
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
                      fontSize: 14,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    drawerItem(
                      icon: Icons.person_outline,
                      title: "My Profile",
                      onTap: () {


                      },
                    ),


                    drawerItem(
                      icon: Icons.currency_rupee,
                      title: "Change Password",
                      onTap: () {
                        Navigator.pushNamed(

                          context,

                          AppRoutes.changePassword

                        );

                      },
                    ),
                    drawerItem(
                      icon: Icons.support_agent,
                      title: "Help & Support",
                      onTap: () {},
                    ),
                    drawerItem(
                      icon: Icons.info_outline,
                      title: "About us",
                      onTap: () {

                      },
                    ),
                    drawerItem(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      onTap: () {

                      },
                    ),
                    drawerItem(
                      icon: Icons.description_outlined,
                      title: "Terms & Conditions",
                      onTap: () {

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
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor,
            ),
            const SizedBox(width: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 50, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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