import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_appbar.dart';
import '../../home/widget/studentCard.dart';
import '../../profile/provider/profile_provider.dart';

class QuickAccessScreen extends StatelessWidget {
  const QuickAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profilePro = context.watch<ProfileProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Quick Access",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP BAR

              /// PROFILE CARD
              // Container(
              //   padding: const EdgeInsets.all(18),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(25),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(.08),
              //         blurRadius: 10,
              //         spreadRadius: 2,
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       /// LEFT BLUE BAR
              //       Container(
              //         width: 5,
              //         height: 120,
              //         decoration: BoxDecoration(
              //           color: Colors.blue,
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //
              //       const SizedBox(width: 15),
              //
              //       /// IMAGE
              //       ClipRRect(
              //         borderRadius: BorderRadius.circular(18),
              //         child: Image.network(
              //           "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
              //           height: 90,
              //           width: 90,
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //
              //       const SizedBox(width: 18),
              //
              //       /// INFO
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: const [
              //             Text(
              //               "Ramesh Kumar Singh",
              //               style: TextStyle(
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             SizedBox(height: 8),
              //             Text(
              //               "ID: BED-2024-0892",
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 color: Colors.black54,
              //               ),
              //             ),
              //             SizedBox(height: 5),
              //             Text(
              //               "B.Ed 2 Year Programme",
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 color: Colors.black54,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              StudentCard(
                name: profilePro.profileModel?.data.fieldName ?? "",
                course: profilePro.profileModel?.data.course ?? "",
                userId: profilePro.profileModel?.data.userId ?? "",
                image: profilePro.profileModel?.data.photo ?? "",
              ),

              SizedBox(height: 15.h),
              const SizedBox(height: 35),

              /// ACADEMICS
              buildSection(
                title: "Academics",
                items: [
                  MenuData(Icons.calendar_month, "My Timetable"),
                  MenuData(Icons.fact_check_outlined, "Attendance"),
                  MenuData(Icons.menu_book_outlined, "Study Material"),
                  MenuData(Icons.assignment_outlined, "Assignments"),
                  MenuData(Icons.bar_chart, "Internal Marks"),
                  MenuData(Icons.event_available, "Exam Schedule"),
                  MenuData(Icons.analytics_outlined, "Results"),
                  MenuData(Icons.grade_outlined, "Grade Card"),
                  MenuData(Icons.workspace_premium_outlined, "Certificates"),
                  MenuData(Icons.calendar_today, "Academic Calendar"),
                ],
              ),

              const SizedBox(height: 30),

              /// CAMPUS SERVICES
              buildSection(
                title: "Campus Services",
                items: [
                  MenuData(Icons.campaign_outlined, "Notice Board"),
                  MenuData(Icons.badge_outlined, "Gate Pass"),
                  MenuData(Icons.event_note_outlined, "Leave Application"),
                  MenuData(Icons.receipt_long_outlined, "Fee Details"),
                  MenuData(Icons.directions_bus_outlined, "Transport"),
                  MenuData(Icons.apartment_outlined, "Hostel"),
                  MenuData(Icons.library_books_outlined, "Library"),
                  MenuData(Icons.star_border, "Events"),
                  MenuData(Icons.groups_outlined, "Clubs & Activities"),
                  MenuData(Icons.support_agent_outlined, "Raise Complaint"),
                ],
              ),

              const SizedBox(height: 30),

              /// LEARNING
              buildSection(
                title: "Learning & Support",
                items: [
                  MenuData(Icons.live_tv_outlined, "LMS"),
                  MenuData(Icons.help_outline, "Ask Faculty"),
                  MenuData(Icons.work_outline, "Training & Placement"),
                  MenuData(Icons.people_outline, "Mentorship"),
                  MenuData(Icons.favorite_border, "Counselling"),
                  MenuData(Icons.question_answer_outlined, "FAQs"),
                  MenuData(Icons.school_outlined, "Online Courses"),
                  MenuData(Icons.link_outlined, "Academic Resources"),
                  MenuData(Icons.feedback_outlined, "Feedback"),
                  MenuData(Icons.more_horiz, "More Services"),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<MenuData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Text(
              "View All",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
              size: 16,
            )
          ],
        ),

        const SizedBox(height: 20),

        /// GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .85,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ICON
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),

                  // const SizedBox(height: 10),

                  /// TITLE
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class MenuData {
  final IconData icon;
  final String title;

  MenuData(this.icon, this.title);
}
