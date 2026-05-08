import 'package:edunity/common/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/common_scaffold.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/theme/text_styles.dart';
import '../model/onboarding_model.dart';
import '../provider/onboarding_provider.dart';
import '../widget/onboarding_bottom_widget.dart';
import '../widget/onboarding_item_widget.dart';

class OnboardingScreen extends StatelessWidget {

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<OnboardingProvider>();

    final List<OnboardingModel> onboardingList = [

      OnboardingModel(
        image: AppImages.appLogo,
        title: "Learn Anytime",
        subtitle: "Access courses and learning materials from anywhere anytime.",
      ),

      OnboardingModel(
        image: AppImages.appLogo,
        title: "Track Progress",
        subtitle: "Monitor your growth and improve your skills daily.",
      ),

      OnboardingModel(
        image: AppImages.appLogo,
        title: "Achieve Goals",
        subtitle: "Complete lessons and achieve your educational goals.",
      ),
    ];

    return AuthBackground(
      child: CommonScaffold(

        backgroundColor: Colors.transparent,

        body: Column(

          children: [

            /// SKIP
            Align(
              alignment: Alignment.topRight,

              child: Padding(
                padding: EdgeInsets.only(
                  right: 20.w,
                  top: 20.h,
                ),

                child: GestureDetector(

                  onTap: (){
                    provider.skip(context);
                  },

                  child: Text(
                    "Skip",
                    style: AppTextStyles.medium.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),

            /// PAGEVIEW
            Expanded(
              child: PageView.builder(

                controller: provider.pageController,

                onPageChanged: provider.onPageChanged,

                itemCount: onboardingList.length,

                itemBuilder: (context, index){

                  return OnboardingItemWidget(
                    model: onboardingList[index],
                  );
                },
              ),
            ),

            /// BOTTOM
            OnboardingBottomWidget(
              currentIndex: provider.currentIndex,
              onTap: (){
                provider.nextPage(context);
              },
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}