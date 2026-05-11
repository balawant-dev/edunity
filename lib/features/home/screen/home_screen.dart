import 'package:edunity/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../drawer/ui/custom_drawer.dart';
import '../model/home_model.dart';
import '../provider/home_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    final vm = context.watch<HomeProvider>();

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

               GestureDetector(
                 onTap: (){
                   _scaffoldKey.currentState!.openDrawer();
                 },
                   child: CustomAppBar()),

              const SizedBox(height: 24),

              StudentCard(
                student: vm.student,
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




class SectionTitle extends StatelessWidget {

  final String title;
  final String buttonText;

  const SectionTitle({
    super.key,
    required this.title,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors2.textDark,
          ),
        ),

        const Spacer(),

        Text(
          buttonText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors2.blue,
          ),
        ),

        const SizedBox(width: 4),

        const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors2.blue,
        ),
      ],
    );
  }
}






class StudentCard extends StatelessWidget {

  final StudentModel student;

  const StudentCard({
    super.key,
    required this.student,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 4),
          height: 120,
          width: 50,
          decoration: BoxDecoration(
            color: AppColors2.primary,
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        // 2. Main White Card
        Container(
          height: 120,
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              // Purani accent line hata di hai kyunki piche wala container wahi kaam kar raha hai

              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  student.image,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),

              // --- Pehli Vertical Line ---
              const SizedBox(width: 8),
              Container(width: 1, height: 70, color: Colors.grey.shade200),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.id,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors2.blue, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors2.textGrey),
                        const SizedBox(width: 4),
                        Text(student.campus, style: const TextStyle(color: AppColors2.textGrey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Dusri Vertical Line ---
              const SizedBox(width: 8),
              Container(width: 1, height: 70, color: Colors.grey.shade200),
              const SizedBox(width: 8),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors2.purple.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_month, color: AppColors2.purple, size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text("Session", style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                  Text(student.session, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors2.primary, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}






class AttendanceCard extends StatelessWidget {

  final AttendanceCardModel model;

  const AttendanceCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 125,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green.withOpacity(0.08),
                  child: Icon(
                    model.icon,
                    size: 16,
                    color: model.color,
                  ),
                ),

                const SizedBox(width: 4),

                Text(
                  model.title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              model.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: model.color,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              model.subtitle,
              style: const TextStyle(fontSize: 11),
            ),

            const SizedBox(height: 8),

            if(model.bottomText.isNotEmpty)
              Text(
                model.bottomText,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}




class QuickActionCard extends StatelessWidget {

  final QuickActionModel model;

  const QuickActionCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Column(
          children: [

            Icon(
              model.icon,
              color: model.color,
            ),

            const SizedBox(height: 8),

            Text(
              model.title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              model.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: model.color,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              model.status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class EmptyCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const EmptyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            size: 48,
            color: color.withOpacity(.5),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}





class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          height: 55,
          width: 48,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.collegeLogo))
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
    );
  }
}