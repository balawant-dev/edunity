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
      backgroundColor:  Colors.white,
      appBar: const CustomAppBar(title: "Profile"),
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                  // BoxShadow(
                  //   color: Colors.black.withOpacity(0.1),
                  //   blurRadius: 6,
                  //   spreadRadius: 1,
                  //   offset: const Offset(0, 3),
                  // ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 90.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3.5),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        profile.photo ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fieldName ?? "Ramesh Kumar Singh",
                          style: AppTextStyles.semiBold(size: 18.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "ID: ${profile.userId ?? "BED-2024-0892"}",
                          style: AppTextStyles.medium(size: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          profile.course ?? "B.Ed (2 Year Programme)",
                          style: AppTextStyles.semiBold(size: 15.sp, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Academic Details
            _buildSection(
              title: "ACADEMIC DETAILS",
              children: [
                _buildDetailRow(Icons.school, "BOARD / UNIVERSITY REG NO.", "REG0892987"),
                _buildDetailRow(Icons.book, "COURSE", profile.course ?? "B.Ed (2 Year Programme)"),
                _buildDetailRow(Icons.calendar_today, "SESSION", "2024-2027"),
                _buildDetailRow(Icons.calendar_month, "YEAR", "1 Year", isLast: true),
              ],
            ),

            SizedBox(height: 16.h),

            // Personal Details
            _buildSection(
              title: "PERSONAL DETAILS",
              children: [
                _buildDetailRow(Icons.calendar_today, "DATE OF BIRTH", "15-06-2003"),
                _buildDetailRow(Icons.person, "FATHER NAME", "Ram Singh"),
                _buildDetailRow(Icons.person_outline, "MOTHER NAME", "Sita Singh"),
                _buildDetailRow(Icons.phone, "STUDENT MOBILE", "+92 9876543210"),
                _buildDetailRow(Icons.email, "EMAIL ID", "ramesh.singh@university.edu"),
                _buildDetailRow(Icons.bloodtype, "BLOOD GROUP", "B+ Positive"),
                _buildDetailRow(Icons.location_on, "ADDRESS",
                    "H-45, Green Valley Residency, New Delhi, 110024",
                    isLast: true),
              ],
            ),

            SizedBox(height: 16.h),

            // Emergency Contact
            _buildSection(
              title: "EMERGENCY CONTACT",
              children: [
                _buildDetailRow(Icons.person, "NAME", "Ram Singh"),
                _buildDetailRow(Icons.family_restroom, "RELATION", "Father"),
                _buildDetailRow(Icons.phone, "CONTACT NUMBER", "+91 9876543210", isLast: true),
              ],
            ),

            SizedBox(height: 16.h),

            // College Details
            _buildSection(
              title: "COLLEGE DETAILS",
              children: [
                _buildDetailRow(Icons.school, "COLLEGE NAME", "SNS Vidhyapeeth"),
                _buildDetailRow(Icons.location_on, "ADDRESS",
                    "Vill. Motihari, post: Motihari Dist. Est Champaran, Bihar-845401"),
                _buildDetailRow(Icons.language, "WEBSITE", "www.snsvidhyapeeth.edu.in"),
                _buildDetailRow(Icons.phone, "CONTACT NUMBER", "06252-222222", isLast: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION WIDGET ====================
  Widget _buildSection({required String title, required List<Widget> children}) {
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
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.1),
          //   blurRadius: 6,
          //   spreadRadius: 1,
          //   offset: const Offset(0, 3),
          // ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.semiBold(size: 15.sp, color: AppColors.primary),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  // ==================== DETAIL ROW WITH ICON + DIVIDER ====================
  Widget _buildDetailRow(IconData icon, String title, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.medium(size: 12.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: AppTextStyles.medium(size: 14.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.only(left: 54.w, top: 12.h),
            child: Divider(color: Colors.grey.withOpacity(0.25), thickness: 1),
          ),
      ],
    );
  }
}