import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/auth_background.dart';
import '../../../common/widgets/common_scaffold.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/theme/text_styles.dart';
import '../provider/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _scaleAnimation;

  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _initializeAnimation();

    Future.microtask(() {
      context.read<SplashProvider>().initializeApp(context);
    });
  }

  void _initializeAnimation() {

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // child: CommonScaffold(
  //      backgroundColor: AppColors.primary,

        body: Center(
          child: FadeTransition(
            opacity: _opacityAnimation,

            child: ScaleTransition(
              scale: _scaleAnimation,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  /// LOGO
                  Image.asset(
                    AppImages.appLogo,
                    fit: BoxFit.contain,
                    scale: 4,
                  ),
                  // Container(
                  //   height: 120.h,
                  //   width: 120.w,
                  //   padding: EdgeInsets.all(22.r),
                  //
                  //   decoration: BoxDecoration(
                  //     color: AppColors.white,
                  //     borderRadius: BorderRadius.circular(28.r),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.08),
                  //         blurRadius: 18,
                  //         offset: const Offset(0, 8),
                  //       ),
                  //     ],
                  //   ),
                  //
                  //   child: Image.asset(
                  //     AppImages.appLogo,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),

                  // SizedBox(height: 28.h),
                  //
                  // /// APP NAME
                  // Text(
                  //   "EDUnity",
                  //   style: AppTextStyles.bold.copyWith(
                  //     fontSize: 34.sp,
                  //     color: AppColors.white,
                  //     letterSpacing: 1,
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 10.h),
                  //
                  // Text(
                  //   "Learn • Grow • Achieve",
                  //   style: AppTextStyles.medium.copyWith(
                  //     fontSize: 14.sp,
                  //     color: AppColors.white.withOpacity(0.85),
                  //     letterSpacing: 0.5,
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 60.h),
                  //
                  // SizedBox(
                  //   width: 32.w,
                  //   height: 32.h,
                  //
                  //   child: CircularProgressIndicator(
                  //     strokeWidth: 2.8,
                  //     color: AppColors.white,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}