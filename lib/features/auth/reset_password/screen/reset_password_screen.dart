import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/auth_background.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../provider/reset_password_provider.dart';

class ResetPasswordScreen extends StatelessWidget {

  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<ResetPasswordProvider>();

    return Scaffold(

      body: AuthBackground(

        child: SafeArea(

          child: SingleChildScrollView(

            padding: EdgeInsets.symmetric(horizontal: 20.w),

            child: Column(

              children: [

                SizedBox(height: 20.h),

                /// BACK
                Align(
                  alignment: Alignment.centerLeft,

                  child: GestureDetector(

                    onTap: (){
                      Navigator.pop(context);
                    },

                    child: Container(

                      height: 42.h,
                      width: 42.w,

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 70.h),

                /// TITLE
                Text(
                  "Change Password",
                  style: AppTextStyles.bold(),
                ),

                SizedBox(height: 16.h),

                Text(
                  "Your new password must different from previous used password",
                  textAlign: TextAlign.center,

                  style: AppTextStyles.medium(),
                ),

                SizedBox(height: 55.h),

                /// CARD
                Container(

                  width: double.infinity,

                  padding: EdgeInsets.all(22.r),

                  decoration: BoxDecoration(

                    color: AppColors.white,

                    borderRadius: BorderRadius.circular(28.r),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.r,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(

                    children: [

                      CustomTextField(
                        controller:
                        provider
                            .currentPasswordController,

                        hintText: "••••••••",

                        label: "CURRENT PASSWORD",

                        obscureText:
                        provider.obscureCurrent,

                        suffixIcon: GestureDetector(

                          onTap: (){
                            provider.toggleCurrent();
                          },

                          child: Icon(
                            provider.obscureCurrent
                                ? Icons.visibility_off
                                : Icons.visibility,

                            color: AppColors.grey,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      CustomTextField(
                        controller:
                        provider
                            .newPasswordController,

                        hintText: "••••••••",

                        label: "NEW PASSWORD",

                        obscureText:
                        provider.obscureNew,

                        suffixIcon: GestureDetector(

                          onTap: (){
                            provider.toggleNew();
                          },

                          child: Icon(
                            provider.obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility,

                            color: AppColors.grey,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      CustomTextField(
                        controller:
                        provider
                            .confirmPasswordController,

                        hintText: "••••••••",

                        label:
                        "CONFIRM NEW PASSWORD",

                        obscureText:
                        provider.obscureConfirm,

                        suffixIcon: GestureDetector(

                          onTap: (){
                            provider.toggleConfirm();
                          },

                          child: Icon(
                            provider.obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,

                            color: AppColors.grey,
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      CustomButton(
                        text: "Send",

                        isLoading:
                        provider.isLoading,

                        onTap: (){
                          provider.resetPassword(
                              context);
                        },
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