import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/auth_background.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../provider/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ForgotPasswordProvider>();

    return Scaffold(
      backgroundColor: AppColors.deepPrimary,

      body: AuthBackground(

        child: SafeArea(

          child: SingleChildScrollView(

            padding: EdgeInsets.symmetric(horizontal: 20.w),

            child: Form(
              key: _formKey,
              child: Column(

                children: [

                  SizedBox(height: 20.h),

                  /// BACK BUTTON
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
                    "Forgot Password?",
                    style: AppTextStyles.bold(color: AppColors.white),
                  ),

                  SizedBox(height: 16.h),

                  /// SUBTITLE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),

                    child: Text(
                      "Please enter your email to received a verification Code",
                      textAlign: TextAlign.center,

                      style: AppTextStyles.regular(color: AppColors.white.withOpacity(0.7)),
                    ),
                  ),

                  SizedBox(height: 55.h),

                  /// CARD
                  Container(

                    width: double.infinity,

                    padding: EdgeInsets.all(22.r),

                    decoration: BoxDecoration(

                      color: AppColors.white,

                      borderRadius: BorderRadius.circular(24.r),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20.r,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        /// ID
                        CustomTextField(
                          controller: provider.idController,
                          hintText: "USER987654",
                          labelText: "User ID",

                          suffixIcon: Icon(
                            Icons.school_outlined,
                            color: AppColors.grey,
                            size: 22.sp,
                          ),
                          validator: (value){

                            if(value == null || value.isEmpty){
                              return "Please enter User ID";
                            }

                            if(value.length < 6){
                              return "User ID must be 6 characters";
                            }

                            // if(!RegExp(
                            //   r'^[^@]+@[^@]+\.[^@]+',
                            // ).hasMatch(value)){
                            //   return "Invalid email";
                            // }

                            return null;
                          },
                        ),

                        SizedBox(height: 15.h),

                        /// EMAIL / PHONE
                        CustomTextField(
                          controller:
                          provider.emailPhoneController,

                          hintText: "email/phone",

                          labelText: "EMAIL/PHONE",
                          validator: (value){

                            if(value == null || value.isEmpty){
                              return "Please enter EMAIL/PHONE";
                            }

                            if(value.length < 6){
                              return "EMAIL/PHONE must be 6 characters";
                            }

                            // if(!RegExp(
                            //   r'^[^@]+@[^@]+\.[^@]+',
                            // ).hasMatch(value)){
                            //   return "Invalid email";
                            // }

                            return null;
                          },
                        ),

                        SizedBox(height: 15.h),

                        /// AADHAAR
                        CustomTextField(
                          controller:
                          provider.aadhaarController,

                          hintText: "1234 5678 9012",

                         labelText: "AADHAR NUMBER",
                          maxLength: 12,

                          keyboardType: TextInputType.number,
                          validator: (value){

                            if(value == null || value.isEmpty){
                              return "Please enter aadhar number";
                            }

                            if(value.length < 12){
                              return "Aadhar number must be 12 characters";
                            }

                            // if(!RegExp(
                            //   r'^[^@]+@[^@]+\.[^@]+',
                            // ).hasMatch(value)){
                            //   return "Invalid email";
                            // }

                            return null;
                          },
                        ),

                        SizedBox(height: 40.h),

                        /// BUTTON
                        CustomButton(
                          text: "Send",

                          isLoading: provider.isLoading,

                          onTap: (){
                            if (_formKey.currentState!.validate()) {
                              provider.sendOtp(context);
                            }

                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}