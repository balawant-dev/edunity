import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/auth_background.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../provider/otp_provider.dart';

class OtpScreen extends StatelessWidget {

  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<OtpProvider>();

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
                  "Verify Your Mail",
                  style: AppTextStyles.bold,
                ),

                SizedBox(height: 16.h),

                /// SUBTITLE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),

                  child: Text(
                    "Please enter the 4-digit code sent to\nstudent@user.com",
                    textAlign: TextAlign.center,

                    style: AppTextStyles.medium,
                  ),
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

                      SizedBox(height: 20.h),

                      /// OTP FIELD
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: List.generate(
                          6,
                              (index){

                            return SizedBox(

                              width: 45.w,

                              child: TextField(

                                controller:
                                provider
                                    .otpControllers[index],

                                keyboardType:
                                TextInputType.number,

                                maxLength: 1,

                                textAlign: TextAlign.center,

                                style:
                                AppTextStyles.bold,

                                decoration:
                                InputDecoration(

                                  counterText: "",

                                  filled: true,

                                  fillColor:
                                  AppColors.textField,

                                  border:
                                  OutlineInputBorder(

                                    borderRadius:
                                    BorderRadius.circular(
                                      14.r,
                                    ),

                                    borderSide:
                                    BorderSide.none,
                                  ),

                                  enabledBorder:
                                  OutlineInputBorder(

                                    borderRadius:
                                    BorderRadius.circular(
                                      14.r,
                                    ),

                                    borderSide:
                                    BorderSide.none,
                                  ),

                                  focusedBorder:
                                  OutlineInputBorder(

                                    borderRadius:
                                    BorderRadius.circular(
                                      14.r,
                                    ),

                                    borderSide:
                                    const BorderSide(
                                      color:
                                      AppColors.primary,
                                    ),
                                  ),
                                ),

                                onChanged: (value){

                                  if(value.isNotEmpty &&
                                      index < 5){

                                    FocusScope.of(context)
                                        .nextFocus();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 28.h),

                      /// RESEND
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Text(
                            "Didn't get the code? ",
                            style: AppTextStyles.medium,
                          ),

                          GestureDetector(

                            onTap: provider.seconds == 0
                                ? (){
                              provider.resendOtp(
                                  context);
                            }
                                : null,

                            child: Text(

                              provider.seconds == 0
                                  ? "Resend"
                                  : "Resend in 0:${provider.seconds}",

                              style:
                              AppTextStyles.semiBold(
                                size: 14,
                                color:
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 50.h),

                      /// BUTTON
                      CustomButton(
                        text: "Send",

                        isLoading:
                        provider.isLoading,

                        onTap: (){
                          provider.verifyOtp(
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