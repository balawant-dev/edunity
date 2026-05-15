import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_images.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;

  final bool showLogo;
  final bool showBack;
  final String? logo;

  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLogo = false,
    this.logo,
    this.onBack,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(

      backgroundColor: Colors.white,

      elevation: 0,

      centerTitle: true,

      automaticallyImplyLeading: false,

      toolbarHeight: 65.h,

      leading:showBack
          ? GestureDetector(

        onTap: onBack ??
                (){
              Navigator.pop(context);
            },

        child: Padding(

          padding: EdgeInsets.only(
            left: 16.w,
          ),

          child: Container(

            height: 36.h,
            width: 36.w,

            decoration: BoxDecoration(

              color: const Color(0xffF5F5F5),

              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.sp,
              color: Colors.black,
            ),
          ),
        ),
      ):const SizedBox(width: 16),

      title: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          /// LOGO
          if(showLogo) ...[

            ClipRRect(

              borderRadius:
              BorderRadius.circular(6.r),

              child: Image.asset(

                logo ??
                    AppImages.collegeLogo,

                height: 28.h,
                width: 28.w,

                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 10.w),
          ],

          /// TITLE
          Flexible(

            child: Text(

              title,

              overflow: TextOverflow.ellipsis,

              style: TextStyle(

                fontSize: 16.sp,

                fontWeight: FontWeight.w600,

                color: const Color(0xff1D2B53),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(65.h);
}


// appBar: CustomAppBar(
//
// title: "SNS Vidyapeeth",
//
// showLogo: true,
//
// logo: "lib/assets/images/collegeLogo.png",
// ),


// appBar: const CustomAppBar(
//
// title: "Gate Pass",
// ),