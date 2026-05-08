import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/auth_background.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
class CollegeCodeScreen extends StatelessWidget {

  CollegeCodeScreen({super.key});

  final TextEditingController codeController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.deepPrimary,

      body: BackgroundWithImage(
        bgImage: AppImages.loginBg,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              SizedBox(height: 100.h),
              Image.asset(
                AppImages.loginLogo,
                height: 80.h,
              ),

              // FlutterLogo(size: 100.sp),

              SizedBox(height: 100.h),

              Container(

                padding: EdgeInsets.all(22.r),

                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Enter Your College Code",
                      style: AppTextStyles.semiBold(
                        size: 14,
                        color: const Color(0xFF444444),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    CustomTextField(
                      controller: codeController,
                      hintText:
                      "Enter Your college code",
                      suffixIcon: Image.asset("lib/assets/icons/ph_student_fill.png",scale: 3,),
                    ),

                    SizedBox(height: 12.h),

                    Center(
                      child: RichText(

                        text: TextSpan(

                          text: "Don't have a code? ",
                          style: AppTextStyles.regular(),


                          children: [

                            TextSpan(
                              text: "Contact your college",
                              style: AppTextStyles.semiBold(
                                size: 14,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 35.h),

                    CustomButton(
                      text: "Submit",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}