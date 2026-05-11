import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/auth_background.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../college_code/model/college_code_model.dart';
import '../provider/login_provider.dart';

class LoginScreen extends StatelessWidget {
  final CollegeModel collegeModel;

  LoginScreen({super.key,  required this.collegeModel,});


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<LoginProvider>();

    provider.setCollegeData(
      collegeModel,
    );

    return Scaffold(
      backgroundColor: AppColors.deepPrimary,

      body: BackgroundWithImage(
        bgImage: AppImages.portalBg,

        child: SafeArea(

          child: SingleChildScrollView(

            padding: EdgeInsets.symmetric(horizontal: 20.w),

            child: Form(
              key: _formKey,
              child: Column(

                children: [

                  SizedBox(height: 60.h),
                  Image.network(
                    collegeModel.data.logo,
                    height: 90.h,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(AppImages.logoNotFound, height: 100.h,);
                    },
                  ),
           //       Image.asset("lib/assets/images/collegeLogo.png",scale: 4,),

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







                    collegeModel.data.fullName,
                    textAlign: TextAlign.center,

                    style: AppTextStyles.semiBold(
                      color: AppColors.primary,
                    ),
                  ),
                  // Container(
                  //
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 12.w,
                  //     vertical: 6.h,
                  //   ),
                  //
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xffE8EEFC),
                  //
                  //     borderRadius:
                  //     BorderRadius.circular(6.r),
                  //   ),
                  //
                  //   child: Text(
                  //
                  //
                  //     collegeModel.data.fullName,
                  //     textAlign: TextAlign.center,
                  //
                  //     style: AppTextStyles.semiBold(
                  //       color: AppColors.primary,
                  //     ),
                  //   ),
                  // ),

                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xffE8EEFC),
                  //     borderRadius: BorderRadius.circular(4.r)
                  //   ),
                  //   child: Text(
                  //     "SNS Vidyapeeth",
                  //     style: AppTextStyles.semiBold(color: AppColors.primary),
                  //
                  //   ),
                  // ),

                  SizedBox(height: 20.h),

                  /// CARD
                  Container(

                    padding: EdgeInsets.all(24.r),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 6.r,
                          offset: Offset(-6, -6),
                          spreadRadius: 0,
                        )
                      ],
                    ),

                    // decoration: BoxDecoration(
                    //
                    //   color: AppColors.white,
                    //
                    //   borderRadius: BorderRadius.circular(28.r),
                    //
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black12,
                    //       blurRadius: 15.r,
                    //     ),
                    //   ],
                    // ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SIGN INTO YOUR PORTAL",
                              style: AppTextStyles.bold(),
                            ),
                          ],
                        ),

                        SizedBox(height: 25.h),

                        CustomTextField(
                          controller:provider. userIdController,
                          hintText:
                          "Enter User ID",
                          suffixIcon: Image.asset(AppImages.userId,scale: 3.5,),
                          labelText: "User ID",
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

                        SizedBox(height: 14.h),

                        CustomTextField(
                          controller:
                          provider
                              .dobController,

                          onTap: (){

                            provider.selectDate(
                                context);
                          },
                          hintText:
                          "YYYY-MM-DD",
                          labelText: "Date of Birth",     validator: (value){

                          if(value == null ||
                              value.isEmpty){

                            return
                              "Please select DOB";
                          }

                          return null;
                        },

                          suffixIcon:             Image.asset(AppImages.calender,scale: 4,),
                        ),

                        SizedBox(height: 14.h),

                        CustomTextField(
                          controller:
                          provider
                              .passwordController,
                          hintText: "Password",
                          labelText: "Password",
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
                          // suffixIcon:             Image.asset(AppImages.password,scale: 4,),
                          validator: (value){

                            if(value == null ||
                                value.isEmpty){

                              return
                                "Please enter password";
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 40.h),
                        CustomButton(

                          text: "Login",

                          isLoading:
                          provider.isLoading,

                          onTap: () async {

                            FocusScope.of(context)
                                .unfocus();

                            if(_formKey
                                .currentState!
                                .validate()){

                              await provider
                                  .login(
                                context,
                              );

                              if(provider
                                  .loginModel !=
                                  null){

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.home,
                                      (route) => false,
                                );
                              }
                            }
                          },
                        ),
                        //
                        // CustomButton(
                        //   text: "Login",
                        //   onTap: () {
                        //     if (_formKey.currentState!.validate()) {
                        //       Navigator.pushNamed(context, AppRoutes.home);
                        //     }
                        //   },
                        // ),

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
      ),
    );
  }
}