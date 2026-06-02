import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../profile/provider/profile_provider.dart';

class MonthlyHeaderCard extends StatelessWidget {
  const MonthlyHeaderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profilePro = context.watch<ProfileProvider>();

    final user = profilePro.profileModel?.data;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          decoration: const BoxDecoration(
            color: Color(
              0xff0038B8,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                32,
              ),
              bottomRight: Radius.circular(
                32,
              ),
            ),
          ),
          child: Column(
            children: [
              /// TOP BAR
              Row(
                children: [
                  /// BACK
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: const SizedBox(
                      width: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  /// TITLE
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Monthly Summary",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  /// RIGHT PLACEHOLDER
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),

              const SizedBox(
                height: 22,
              ),

              /// PROFILE CARD
              Container(
                padding: const EdgeInsets.all(
                  16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    22,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        .05,
                      ),
                      blurRadius: 18,
                      offset: const Offset(
                        0,
                        8,
                      ),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    /// IMAGE
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          22,
                        ),
                        color: const Color(
                          0xffEEF4FF,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: user?.photo.isNotEmpty == true
                          ? Image.network(
                              user!.photo,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                _,
                                __,
                                ___,
                              ) {
                                return const Icon(
                                  Icons.person,
                                  size: 34,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 34,
                            ),
                    ),

                    const SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NAME
                          Text(
                            user?.fieldName ?? "--",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          /// USER ID
                          Text(
                            "${user?.type == "student" ? "Student" : "Employee"} ID: ${user?.userId ?? "--"}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          /// COURSE / DESIGNATION
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffEEF4FF,
                              ),
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  user?.type == "student"
                                      ? Icons.school_rounded
                                      : Icons.badge_rounded,
                                  size: 18,
                                  color: const Color(
                                    0xff0A53FF,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Flexible(
                                  child: Text(
                                    user?.type == "student"
                                        ? (user?.course.isNotEmpty == true
                                            ? user!.course
                                            : "--")
                                        : (user?.designation.isNotEmpty == true
                                            ? user!.designation
                                            : "--"),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
