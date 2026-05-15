import 'package:edunity/core/constants/app_colors.dart';
import 'package:edunity/core/constants/app_images.dart';
import 'package:edunity/features/attendance/screen/face_attendance_screen.dart';
import 'package:flutter/material.dart';

import '../home/screen/home_screen.dart';
import '../profile/screen/profile_screen.dart';


class MainScreen extends StatefulWidget {
  final int currentIndex;
  const MainScreen({super.key,required this.currentIndex});
  static void changeTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainScreenState>();
    state?.setState(() {
      state.currentIndex = index;
    });
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex; // initial value
  }
  final List<Widget> pages = [
    const HomeScreen(),
    const FaceAttendanceScreen(isBack: false,),
    const QuickAccessScreen(),
    const ProfileScreen(isBack: false,),
  ];

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          setState(() {
            currentIndex = 0; // ✅ Go to Home tab
          });
          return false; // ❌ Don't pop
        }
        return true; // ✅ Pop screen
      },
      child: Scaffold(
        body: pages[currentIndex],
      
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                )
              ],
            ),
                
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bottomItem(
                  index: 0,
                  label: "Home",
                  selectedIcon: AppImages.homeS,
                  unSelectedIcon: AppImages.homeUs,
                ),
                
                bottomItem(
                  index: 1,
                  label: "Punch",
                  selectedIcon: AppImages.punchS,
                  unSelectedIcon: AppImages.punchUn,
                ),
                
                bottomItem(
                  index: 2,
                  label: "Quick Access",
                  selectedIcon: AppImages.quikS,
                  unSelectedIcon:  AppImages.quikUn,
                ),
                
                bottomItem(
                  index: 3,
                  label: "Account",
                  selectedIcon: AppImages.settingS,
                  unSelectedIcon: AppImages.settingUn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomItem({
    required int index,
    required String label,
    required String selectedIcon,
    required String unSelectedIcon,
  }) {

    bool isSelected = currentIndex  == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex  = index;
        });
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            isSelected ? selectedIcon : unSelectedIcon,
            height: 20,
          ),

          const SizedBox(height: 5),
        Text(
            label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color:  isSelected ? AppColors.primary : AppColors.black,
      ),
          )
        ],
      ),
    );
  }
}


class QuickAccessScreen extends StatelessWidget {
  const QuickAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Quick Access Coming Soon"),
      ),
    );
  }
}

