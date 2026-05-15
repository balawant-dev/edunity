// privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_appbar.dart';
import '../provider/cms_provider.dart';


class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CMSProvider>().getPrivacyPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CMSProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Privacy Policy"),
      // appBar: AppBar(title: const Text("Privacy Policy")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.privacyData == null
          ? const Center(child: Text("Failed to load data"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.privacyData!.data.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Html(
              data: provider.privacyData!.data.body,
              style: {
                "p": Style(fontSize: FontSize(16)),
                "h1": Style(fontSize: FontSize(22)),
                "h2": Style(fontSize: FontSize(20)),
              },
            ),
          ],
        ),
      ),
    );
  }
}