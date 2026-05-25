import 'package:flutter/material.dart';

class AttendanceHomeScreen extends StatelessWidget {
  const AttendanceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BLUE HEADER
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0A36D6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 14),

                      // LOGO
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: Color(0xff0A36D6),
                          size: 35,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          "SNS Vidyapeeth",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Stack(
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 18),

                  // PROFILE CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: const NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRg4sfsepfmmNfuCTozFRNbMVVhRaRHJoeVbQ&s",
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Ramesh Kumar Singh",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1B1B1B),
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                "Student ID: 250900001",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),

                              SizedBox(height: 8),

                              Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: Color(0xff0A36D6),
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "B.Ed (2 Year Programme)",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // GEOFENCE CARD
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Geo-fence Status",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff18214D),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              Container(
                                height: 130,
                                width: 170,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 65,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.location_on,
                                      size: 40,
                                      color: Color(0xff0A36D6),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Color(0xff0A36D6),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "Valid Geofence Confirmed.",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff18214D),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10),

                                    Text(
                                      "You are within the 50m radius.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // READY TO PUNCH
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ready to Punch In",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff18214D),
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Frame Your Face to Punch In.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              Container(
                                height: 170,
                                width: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRg4sfsepfmmNfuCTozFRNbMVVhRaRHJoeVbQ&s",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "You are ready to\nrecord attendance.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff18214D),
                                      ),
                                    ),

                                    const SizedBox(height: 22),

                                    Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff0A36D6),
                                        borderRadius:
                                        BorderRadius.circular(22),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "PUNCH IN",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Color(0xff0A36D6),
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // SUMMARY
                    _buildCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Today’s Summary",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff18214D),
                                ),
                              ),
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: Color(0xff0A36D6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _summaryBox(
                                  icon: Icons.watch_later_outlined,
                                  title: "Working Hours",
                                  value: "07h 45m",
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _summaryBox(
                                  icon: Icons.calendar_month_outlined,
                                  title: "Total Punches",
                                  value: "2",
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // TODAY PUNCHES
                    _buildCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Today’s Punches",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff18214D),
                                ),
                              ),
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: Color(0xff0A36D6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          _punchTile(
                            color: Colors.green,
                            title: "Punched In",
                            time: "08:50 AM",
                            note: "On Time",
                          ),

                          const SizedBox(height: 25),

                          _punchTile(
                            color: Colors.red,
                            title: "Punched Out",
                            time: "01:15 PM",
                            note: "Lunch Break",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

      // BOTTOM NAV

    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  static Widget _summaryBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade50,
            child: Icon(
              icon,
              color: const Color(0xff0A36D6),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff18214D),
            ),
          )
        ],
      ),
    );
  }

  static Widget _punchTile({
    required Color color,
    required String title,
    required String time,
    required String note,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: const Icon(
            Icons.login,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff18214D),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: const [
                  Icon(Icons.location_on, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "College Campus",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                note,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Note: -",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _navItem(
      IconData icon,
      String title,
      bool isSelected,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xff0A36D6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? Colors.white
                : Colors.grey,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: TextStyle(
            color: isSelected
                ? const Color(0xff0A36D6)
                : Colors.grey,
            fontWeight:
            isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }
}