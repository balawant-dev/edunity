import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../common/widgets/custom_appbar.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool isBack;
  const ProfileScreen({super.key, required this.isBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profileModel?.data;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Profile",
        showBack: widget.isBack,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
              ? const Center(child: Text("Profile not found"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      // ==================== TOP PROFILE CARD ====================
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 90.h,
                              width: 90.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.primary, width: 3.5),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  profile.photo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.fieldName,
                                    style: AppTextStyles.semiBold(size: 18.sp),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "${profile.userId}",
                                    style: AppTextStyles.medium(
                                        size: 14.sp, color: Colors.grey),
                                  ),
                                  SizedBox(height: 8.h),
                                  // Text(
                                  //   profile.designation.isNotEmpty ? profile.designation : profile.type.toUpperCase(),
                                  //   style: AppTextStyles.semiBold(size: 15.sp, color: AppColors.primary),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Employee/Academic Details
                      _buildSection(
                        title: "WORK DETAILS",
                        children: [
                          _buildDetailRow(
                              Icons.work, "DESIGNATION", profile.designation),
                          _buildDetailRow(
                              Icons.business, "DEPARTMENT", profile.department),
                          // _buildDetailRow(Icons.badge, "UID", profile.uid,
                          //     isLast: true),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Personal Details
                      _buildSection(
                        title: "PERSONAL DETAILS",
                        children: [
                          _buildDetailRow(
                              Icons.email, "EMAIL ID", profile.email),
                          _buildDetailRow(
                              Icons.phone, "MOBILE", profile.fieldMobile),
                          _buildDetailRow(Icons.calendar_month, "DATE OF BIRTH",
                              profile.dob),
                          _buildDetailRow(
                              Icons.person, "FATHER NAME", profile.fatherName),
                          _buildDetailRow(Icons.credit_card, "AADHAAR NUMBER",
                              "[Aadhaar Redacted]"),
                          _buildDetailRow(Icons.bloodtype, "BLOOD GROUP",
                              profile.bloodGroup),
                          _buildDetailRow(
                              Icons.location_on, "ADDRESS", profile.address,
                              isLast: true),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Emergency Contact
                      if (profile.emergencyContact != null)
                        _buildSection(
                          title: "EMERGENCY CONTACT",
                          children: [
                            _buildDetailRow(Icons.person, "NAME",
                                profile.emergencyContact!.name),
                            _buildDetailRow(Icons.family_restroom, "RELATION",
                                profile.emergencyContact!.relation),
                            _buildDetailRow(Icons.phone, "CONTACT",
                                profile.emergencyContact!.contact,
                                isLast: true),
                          ],
                        ),

                      SizedBox(height: 16.h),

                      // College Details
                      if (profile.collegeDetails != null)
                        _buildSection(
                          title: "COLLEGE DETAILS",
                          children: [
                            _buildDetailRow(Icons.school, "COLLEGE",
                                profile.collegeDetails!.college),
                            _buildDetailRow(Icons.language, "WEBSITE",
                                profile.collegeDetails!.website),
                            _buildDetailRow(Icons.call, "CONTACT NO",
                                profile.collegeDetails!.contactNo),
                            _buildDetailRow(Icons.location_city, "ADDRESS",
                                profile.collegeDetails!.address,
                                isLast: true),
                          ],
                        ),
                    ],
                  ),
                ),
    );
  }

  // Same Section & DetailRow Widgets...
  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.semiBold(
                  size: 15.sp, color: AppColors.primary)),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 14.w),

              /// Title
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: AppTextStyles.medium(
                    size: 12.sp,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(width: 16.w),

              /// Value
              Expanded(
                flex: 4,
                child: Text(
                  value.trim().isEmpty ? "N/A" : value,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.medium(
                    size: 14.sp,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.only(left: 54.w),
            child: Divider(
              color: Colors.grey.withOpacity(0.25),
              height: 1,
              thickness: 1,
            ),
          ),
      ],
    );
  }
}
