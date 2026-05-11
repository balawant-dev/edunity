// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../common/widgets/auth_background.dart';
// import '../../../../common/widgets/custom_button.dart';
// import '../../../../common/widgets/custom_textfield.dart';
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_images.dart';
// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/theme/text_styles.dart';
// class CollegeCodeScreen extends StatelessWidget {
//
//   CollegeCodeScreen({super.key});
//
//   final TextEditingController codeController =
//   TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: AppColors.deepPrimary,
//
//       body: BackgroundWithImage(
//         bgImage: AppImages.loginBg,
//
//         child:  Form(
//           key:_formKey,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//
//             child: Column(
//
//               mainAxisAlignment: MainAxisAlignment.start,
//
//               children: [
//                 SizedBox(height: 100.h),
//                 Image.asset(
//                   AppImages.loginLogo,
//                   height: 80.h,
//                 ),
//
//                 // FlutterLogo(size: 100.sp),
//
//                 SizedBox(height: 100.h),
//
//                 Container(
//
//                   padding: EdgeInsets.all(22.r),
//
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(16.r),
//                   ),
//
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                     children: [
//
//                       Text(
//                         "Enter Your College Code",
//                         style: AppTextStyles.semiBold(
//                           size: 14,
//                           color: const Color(0xFF444444),
//                         ),
//                       ),
//
//                       SizedBox(height: 10.h),
//
//                       CustomTextField(
//
//                         controller: codeController,
//                         maxLength: 8,
//                         keyboardType: TextInputType.text,
//                         validator: (value){
//
//                           if(value == null || value.isEmpty){
//                             return "Please enter college code";
//                           }
//
//                           if(value.length < 4){
//                             return "College code must be 6 characters";
//                           }
//
//                           return null;
//                         },
//                         // isRequired: true,
//                         // useFormValidation: true,
//                         hintText:
//                         "Enter Your college code",
//                         suffixIcon:             Image.asset(AppImages.userId,scale: 3.5,),
//                       ),
//
//                       SizedBox(height: 12.h),
//
//                       Center(
//                         child: RichText(
//
//                           text: TextSpan(
//
//                             text: "Don't have a code? ",
//                             style: AppTextStyles.regular(),
//
//
//                             children: [
//
//                               TextSpan(
//                                 text: "Contact your college",
//                                 style: AppTextStyles.semiBold(
//                                   size: 14,
//                                   color: AppColors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: 35.h),
//
//                       CustomButton(
//                         text: "Submit",
//                         onTap: () {
//
//                           if (_formKey.currentState!.validate()) {
//
//                             Navigator.pushNamed(context, AppRoutes.login);
//                           }
//                         },
//                       )
//
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



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

import '../provider/college_provider.dart';

class CollegeCodeScreen extends StatelessWidget {

  CollegeCodeScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<CollegeProvider>();

    return Scaffold(

      backgroundColor: AppColors.deepPrimary,

      body: BackgroundWithImage(

        bgImage: AppImages.loginBg,

        child: Form(

          key: _formKey,

          child: SingleChildScrollView(

            padding:
            EdgeInsets.symmetric(horizontal: 20.w),

            child: Column(

              children: [

                SizedBox(height: 100.h),

                Image.asset(
                  AppImages.loginLogo,
                  height: 80.h,
                ),

                SizedBox(height: 100.h),

                Container(

                  padding: EdgeInsets.all(22.r),

                  decoration: BoxDecoration(

                    color: AppColors.white,

                    borderRadius:
                    BorderRadius.circular(16.r),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Enter Your College Code",

                        style:
                        AppTextStyles.semiBold(
                          size: 14,
                          color:
                          const Color(0xFF444444),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// TEXTFIELD
                      CustomTextField(

                        controller:
                        provider.codeController,

                        maxLength: 8,

                        keyboardType:
                        TextInputType.text,

                        hintText:
                        "Enter Your college code",

                        validator: (value){

                          if(value == null ||
                              value.isEmpty){

                            return
                              "Please enter college code";
                          }

                          if(value.length < 4){

                            return
                              "College code must be minimum 4 characters";
                          }

                          return null;
                        },

                        suffixIcon: Image.asset(
                          AppImages.userId,
                          scale: 3.5,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Center(
                        child: RichText(

                          text: TextSpan(

                            text:
                            "Don't have a code? ",

                            style:
                            AppTextStyles.regular(),

                            children: [

                              TextSpan(

                                text:
                                "Contact your college",

                                style:
                                AppTextStyles
                                    .semiBold(
                                  size: 14,
                                  color:
                                  AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 35.h),

                      /// BUTTON
                      CustomButton(

                        text: "Submit",

                        isLoading:
                        provider.isLoading,

                        onTap: () async {

                          FocusScope.of(context)
                              .unfocus();

                          if(_formKey
                              .currentState!
                              .validate()){

                            await provider
                                .findCollege(
                              context,
                            );

                            /// SUCCESS NAVIGATION
                            if(provider.collegeModel !=
                                null){

                              Navigator.pushNamed(
                                context,
                                AppRoutes.login,
                                arguments: provider.collegeModel,
                              );
                            }
                          }
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