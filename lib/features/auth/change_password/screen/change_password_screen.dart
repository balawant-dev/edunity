import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/auth_background.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../provider/change_password_provider.dart';

class ChangePasswordScreen extends StatefulWidget {


  const ChangePasswordScreen({super.key, });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final _formKey =
  GlobalKey<FormState>();
  @override
  void initState() {

    super.initState();

    // Future.microtask(() {
    //
    //   context
    //       .read<ChangePasswordProvider>()
    //       .setData(
    //
    //     userId: widget.userId,
    //
    //     otp: widget.otp,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<ChangePasswordProvider>();

    return Scaffold(
      backgroundColor: AppColors.deepPrimary,

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
                  style: AppTextStyles.bold(color: AppColors.white),
                ),

                SizedBox(height: 16.h),

                Text(
                  "Your new password must different from previous used password",
                  textAlign: TextAlign.center,

                  style: AppTextStyles.regular(color: AppColors.white.withOpacity(0.7)),
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

                        labelText: "CURRENT PASSWORD",

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

                      SizedBox(height: 16.h),

                      CustomTextField(
                        controller:
                        provider
                            .newPasswordController,

                        hintText: "••••••••",

                        labelText: "NEW PASSWORD",

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

                      SizedBox(height: 16.h),

                      CustomTextField(
                        controller:
                        provider
                            .confirmPasswordController,

                        hintText: "••••••••",

                        labelText:
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