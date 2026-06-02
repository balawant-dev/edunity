import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/custom_appbar.dart';
import '../provider/cms_provider.dart';

class CampusConnectScreen extends StatefulWidget {
  const CampusConnectScreen({super.key});

  @override
  State<CampusConnectScreen> createState() => _CampusConnectScreenState();
}

class _CampusConnectScreenState extends State<CampusConnectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CMSProvider>().getCampusConnect();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CMSProvider>();
    final contacts = [...?provider.campusData?.data]..sort(
        (a, b) => a.sortWeight.compareTo(
          b.sortWeight,
        ),
      );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Campus Connect"),
      // appBar: AppBar(title: const Text("Campus Connect")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.campusData!.data.isEmpty
              ? const Center(child: Text("No data available"))
              : SafeArea(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      // itemCount: provider.campusData!.data.length,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        // final contact = provider.campusData!.data[index];
                        final contact = contacts[index];
                        final isAvailable = _isCurrentlyAvailable(
                          contact,
                        );
                        // final isAvailable =
                        //     contact.status.toLowerCase().contains("available");

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 16,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              18,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  .05,
                                ),
                                blurRadius: 16,
                                offset: const Offset(
                                  0,
                                  6,
                                ),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TOP ROW
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      contact.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  /// STATUS BADGE
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isAvailable
                                          ? Colors.green.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(
                                        50,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: isAvailable
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          isAvailable
                                              ? "Available Now"
                                              : "Closed",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isAvailable
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              _infoRow(
                                Icons.phone_outlined,
                                contact.phoneNumber,
                              ),

                              GestureDetector(
                                onTap: () => _launchEmail(
                                  contact.emailId,
                                ),
                                child: _infoRow(
                                  Icons.email_outlined,
                                  contact.emailId,
                                ),
                              ),

                              _infoRow(
                                Icons.schedule_outlined,
                                "${contact.workingHoursStart} - ${contact.workingHoursEnd}",
                              ),

                              _infoRow(
                                Icons.open_in_new_rounded,
                                contact.servicesHandled,
                              ),

                              const SizedBox(height: 18),

                              /// BUTTON
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => _launchPhone(
                                    contact.phoneNumber,
                                  ),
                                  icon: const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    "Call Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xff0A53FF,
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      48,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentlyAvailable(
    dynamic contact,
  ) {
    try {
      final now = DateTime.now();

      final days = contact.workingDays.toLowerCase();

      final today =
          ["sun", "mon", "tue", "wed", "thu", "fri", "sat"][now.weekday % 7];

      if (!days.contains(today)) {
        return false;
      }

      final start = contact.workingHoursStart.split(":");

      final end = contact.workingHoursEnd.split(":");

      final startMin = int.parse(start[0]) * 60 + int.parse(start[1]);

      final endMin = int.parse(end[0]) * 60 + int.parse(end[1]);

      final nowMin = now.hour * 60 + now.minute;

      return nowMin >= startMin && nowMin <= endMin;
    } catch (_) {
      return false;
    }
  }

  Future<void> _launchPhone(
    String phone,
  ) async {
    final uri = Uri(
      scheme: "tel",
      path: phone.trim(),
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _launchEmail(
    String email,
  ) async {
    final uri = Uri(
      scheme: "mailto",
      path: email.trim(),
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
