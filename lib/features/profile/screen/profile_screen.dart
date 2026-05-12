import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../common/widgets/custom_appbar.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      context
          .read<ProfileProvider>()
          .getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<ProfileProvider>();

    final profile =
        provider.profileModel?.data;

    return Scaffold(

      backgroundColor:
      const Color(0xffF5F7FB),

      appBar: const CustomAppBar(

title: "My Profile",
        // showLogo: true,
),

      body: provider.isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : profile == null

          ? const Center(
        child: Text(
          "Profile not found",
        ),
      )

          : SingleChildScrollView(

        padding:
        EdgeInsets.all(18.r),

        child: Column(

          children: [

            /// TOP CARD
            Container(

              width: double.infinity,

              padding:
              EdgeInsets.all(22.r),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  22.r,
                ),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.r,
                  ),
                ],
              ),

              child: Column(

                children: [

                  /// IMAGE
                  Container(

                    height: 110.h,

                    width: 110.w,

                    decoration:
                    BoxDecoration(

                      shape:
                      BoxShape.circle,

                      border: Border.all(
                        color:
                        AppColors.primary,
                        width: 3,
                      ),
                    ),

                    child: ClipRRect(

                      borderRadius:
                      BorderRadius.circular(
                        999,
                      ),

                      child: Image.network(

                        profile.photo,

                        fit: BoxFit.cover,

                        errorBuilder:
                            (_,__,___){

                          return const Icon(
                            Icons.person,
                            size: 60,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// NAME
                  Text(

                    profile.fieldName,

                    style:
                    AppTextStyles.bold(
                      size: 22,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// USER ID
                  Container(

                    padding:
                    EdgeInsets.symmetric(

                      horizontal: 14.w,

                      vertical: 6.h,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      AppColors.primary
                          .withOpacity(0.1),

                      borderRadius:
                      BorderRadius.circular(
                        30.r,
                      ),
                    ),

                    child: Text(

                      "ID : ${profile.userId}",

                      style:
                      AppTextStyles.medium(
                        color:
                        AppColors.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,

                    children: [

                      profileItem(
                        title: "Course",
                        value:
                        profile.course,
                      ),

                      profileItem(
                        title: "Session",
                        value:
                        profile.session,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            /// DETAILS CARD
            Container(

              width: double.infinity,

              padding:
              EdgeInsets.all(20.r),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  22.r,
                ),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.r,
                  ),
                ],
              ),

              child: Column(

                children: [

                  profileTile(
                    icon: Icons.email,
                    title: "Email",
                    value:
                    profile.email,
                  ),

                  profileTile(
                    icon: Icons.phone,
                    title: "Mobile",
                    value:
                    profile.fieldMobile,
                  ),

                  profileTile(
                    icon:
                    Icons.calendar_month,
                    title:
                    "Date of Birth",
                    value:
                    profile.dob,
                  ),

                  profileTile(
                    icon: Icons.person,
                    title:
                    "Father Name",
                    value:
                    profile.fatherName,
                  ),

                  profileTile(
                    icon:
                    Icons.credit_card,
                    title:
                    "Aadhar Number",
                    value:
                    profile.aadhar,
                  ),

                  profileTile(
                    icon:
                    Icons.location_on,
                    title: "Address",
                    value:
                    profile.address,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItem({

    required String title,

    required String value,

  }){

    return Column(

      children: [

        Text(

          value,

          style:
          AppTextStyles.bold(
            size: 16,
          ),
        ),

        SizedBox(height: 4.h),

        Text(

          title,

          style:
          AppTextStyles.medium(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget profileTile({

    required IconData icon,

    required String title,

    required String value,

    bool isLast = false,

  }){

    return Column(

      children: [

        Row(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Container(

              padding:
              EdgeInsets.all(10.r),

              decoration:
              BoxDecoration(

                color:
                AppColors.primary
                    .withOpacity(0.1),

                borderRadius:
                BorderRadius.circular(
                  12.r,
                ),
              ),

              child: Icon(

                icon,

                color:
                AppColors.primary,

                size: 22.sp,
              ),
            ),

            SizedBox(width: 14.w),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style:
                    AppTextStyles.medium(
                      color:
                      Colors.grey,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(

                    value,

                    style:
                    AppTextStyles.semiBold(
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        if(!isLast)
          Padding(

            padding:
            EdgeInsets.symmetric(
              vertical: 16.h,
            ),

            child: Divider(
              color: Colors.grey
                  .withOpacity(0.2),
            ),
          ),
      ],
    );
  }
}