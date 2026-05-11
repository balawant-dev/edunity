import 'package:edunity/core/constants/app_images.dart';
import 'package:edunity/features/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

      context
          .read<ProfileProvider>()
          .getProfile();
    });
  }
  @override
  Widget build(BuildContext context) {

    final vm = context.watch<HomeProvider>();
    final profilePro = context.watch<ProfileProvider>();

    return Scaffold(
      key: _scaffoldKey, // 👈 YE ADD KARO
      backgroundColor: AppColors2.bgColor,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

               Row(
                 children: [

                   GestureDetector(
                     onTap: (){
                       _scaffoldKey.currentState!.openDrawer();
                     },
                     child: Container(
                       height: 55,
                       width: 48,
                       decoration: BoxDecoration(
                           image: DecorationImage(image: AssetImage(AppImages.collegeLogo))
                       ),


                     ),
                   ),

                   const SizedBox(width: 12),

                   Container(
                     padding: const EdgeInsets.symmetric(
                       horizontal: 12,
                       vertical: 10,
                     ),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(6),
                     ),
                     child: const Text(
                       "SNS Vidyapeeth",
                       style: TextStyle(
                         fontWeight: FontWeight.w600,
                         fontSize: 18,
                         color: AppColors2.textDark,
                       ),
                     ),
                   ),

                   const Spacer(),

                   Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: const Icon(Icons.notifications_none),
                   ),
                 ],
               ),

              const SizedBox(height: 24),

              StudentCard(

                name:
                profilePro.profileModel?.data.fieldName
                    ?? "",

                course:
                profilePro.profileModel?.data.course
                    ?? "",

                userId:
                profilePro.profileModel?.data.userId
                    ?? "",

                image:
                profilePro.profileModel?.data.photo
                    ?? "",
              ),

              const SizedBox(height: 28),

              const SectionTitle(
                title: "Today's Attendance",
                buttonText: "View History",
              ),

              const SizedBox(height: 18),

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

              const SizedBox(height: 28),

              const SectionTitle(
                title: "To Do List",
                buttonText: "View All",
              ),

              const SizedBox(height: 18),

              const EmptyCard(
                icon: Icons.event_note_outlined,
                title: "No tasks for now",
                subtitle: "You're all caught up!",
                color: Colors.purple,
              ),

              const SizedBox(height: 28),

              const SectionTitle(
                title: "Today's Schedule",
                buttonText: "View Timetable",
              ),

              const SizedBox(height: 18),

              const EmptyCard(
                icon: Icons.calendar_month,
                title: "No classes scheduled for today",
                subtitle: "Enjoy your day!",
                color: Colors.blue,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


































