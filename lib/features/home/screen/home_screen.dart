import 'package:edunity/core/constants/app_images.dart';
import 'package:edunity/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../drawer/ui/custom_drawer.dart';
import '../model/home_model.dart';
import '../provider/home_provider.dart';
import '../widget/attendanceCard.dart';
import '../widget/emptyCard.dart';
import '../widget/quickActionCard.dart';
import '../widget/sectionTitle.dart';
import '../widget/studentCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(65.h);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeProvider>();
    final profilePro = context.watch<ProfileProvider>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: false,

        automaticallyImplyLeading: false,

        toolbarHeight: 65.h,



        title: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            /// LOGO

            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),

                  child: Image.asset(
                  AppImages.collegeLogo,

                    height: 55.h,
                    width: 48.w,

                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 20.w),


            /// TITLE
            Flexible(
              child:      Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "SNS Vidyapeeth",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    color: AppColors2.textDark,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(10.r),
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Color(0xffdfdfdf),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child:  Icon(Icons.notifications_none,size: 24.sp,),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18.r),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // SizedBox(height: 24.h),

              StudentCard(
                name: profilePro.profileModel?.data.fieldName ?? "",

                course: profilePro.profileModel?.data.course ?? "",

                userId: profilePro.profileModel?.data.userId ?? "",

                image: profilePro.profileModel?.data.photo ?? "",
              ),

              SizedBox(height: 15.h),

              const SectionTitle(
                title: "Today's Attendance",
                buttonText: "View History",
              ),

              SizedBox(height: 10.h),

              Row(
                children: vm.attendanceCards.map((e) {
                  return AttendanceCard(model: e);
                }).toList(),
              ),

              const SizedBox(height: 18),

              Row(
                children: vm.quickActions.map((e) {
                  return QuickActionCard(model: e);
                }).toList(),
              ),

              SizedBox(height: 28.h),

              const SectionTitle(title: "To Do List", buttonText: "View All"),

              SizedBox(height: 18.h),

              const EmptyCard(
                icon: Icons.event_note_outlined,
                title: "No tasks for now",
                subtitle: "You're all caught up!",
                color: Colors.purple,
              ),

              SizedBox(height: 28.h),

              const SectionTitle(
                title: "Today's Schedule",
                buttonText: "View Timetable",
              ),

              SizedBox(height: 18.h),

              const EmptyCard(
                icon: Icons.calendar_month,
                title: "No classes scheduled for today",
                subtitle: "Enjoy your day!",
                color: Colors.blue,
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
