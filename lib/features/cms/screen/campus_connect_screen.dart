// campus_connect_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Campus Connect"),
      // appBar: AppBar(title: const Text("Campus Connect")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.campusData == null || provider.campusData!.data.isEmpty
          ? const Center(child: Text("No data available"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.campusData!.data.length,
        itemBuilder: (context, index) {
          final contact = provider.campusData!.data[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _infoRow(Icons.phone, contact.phoneNumber),
                  _infoRow(Icons.email, contact.emailId),
                  _infoRow(Icons.work, contact.servicesHandled),
                  _infoRow(
                    Icons.access_time,
                    "${contact.workingHoursStart} - ${contact.workingHoursEnd}",
                  ),
                  _infoRow(Icons.calendar_today, contact.workingDays),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}