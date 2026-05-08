import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),
          colors: [const Color(0xFF0128A1), const Color(0xFF000E3B)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      child: child,
    );
  }
}class BackgroundWithImage extends StatelessWidget {

  final Widget child;
  final String bgImage;

  const BackgroundWithImage({
    super.key,
    required this.child,
    required this.bgImage,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      clipBehavior: Clip.antiAlias,
      decoration:BoxDecoration(
        //AppImages.loginBg
        image: DecorationImage(image: AssetImage(bgImage),fit: BoxFit.fill)
      ),

      child: child,
    );
  }
}