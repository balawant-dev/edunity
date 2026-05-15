// terms_condition_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_appbar.dart';
import '../provider/cms_provider.dart';


class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CMSProvider>().getTermsCondition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CMSProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Terms & Conditions"),
      // appBar: AppBar(title: const Text("Terms & Conditions")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.termsData == null
          ? const Center(child: Text("Failed to load data"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.termsData!.data.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Html(
              data: provider.termsData!.data.body,
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