// about_us_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_appbar.dart';
import '../provider/cms_provider.dart';


class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CMSProvider>().getAboutUs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CMSProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "About Us"),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.aboutUsData == null
          ? const Center(child: Text("Failed to load data"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.aboutUsData!.data.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Html(
              data: provider.aboutUsData!.data.body,
              style: {
                "p": Style(fontSize: FontSize(16)),
              },
            ),
          ],
        ),
      ),
    );
  }
}