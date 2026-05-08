import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/auth_background.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({super.key});

  final TextEditingController idController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: AuthBackground(

        child: SafeArea(

          child: SingleChildScrollView(

            padding: EdgeInsets.symmetric(horizontal: 20.w),

            child: Column(

              children: [

                SizedBox(height: 60.h),
                Image.asset("lib/assets/images/collegeLogo.png",scale: 4,),

                /// LOGO
                // Container(
                //
                //   height: 90.h,
                //   width: 90.w,
                //
                //   decoration: BoxDecoration(
                //     color: AppColors.white,
                //     borderRadius: BorderRadius.circular(20.r),
                //   ),
                //
                //   child: Padding(
                //     padding: EdgeInsets.all(12.r),
                //
                //     child: FlutterLogo(),
                //   ),
                // ),

                SizedBox(height: 14.h),

                Text(
                  "SNS Vidyapeeth",
                  style: AppTextStyles.bold,
                ),

                SizedBox(height: 50.h),

                /// CARD
                Container(

                  padding: EdgeInsets.all(24.r),

                  decoration: BoxDecoration(

                    color: AppColors.white,

                    borderRadius: BorderRadius.circular(28.r),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15.r,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        "SIGN INTO YOUR PORTAL",
                        style: AppTextStyles.bold,
                      ),

                      SizedBox(height: 35.h),

                      CustomTextField(
                        controller: idController,
                        hintText: "Enter Your ID",
                        label: "User ID",
                      ),

                      SizedBox(height: 22.h),

                      CustomTextField(
                        controller: dobController,
                        hintText: "DD/MM/YYYY",
                        label: "Date of Birth",
                      ),

                      SizedBox(height: 22.h),

                      CustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        label: "Password",
                        obscureText: true,
                      ),

                      SizedBox(height: 40.h),

                      CustomButton(
                        text: "Login",
                        onTap: () {},
                      ),

                      SizedBox(height: 14.h),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, AppRoutes.forgotPassword);
                        },
                        child: Center(
                          child: Text(
                            "Forget Password",
                            style: AppTextStyles.semiBold(
                              size: 13,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}