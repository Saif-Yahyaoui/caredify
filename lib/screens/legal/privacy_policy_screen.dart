import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.privacyPolicy)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.privacyPolicy,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Your privacy is important to us. This app securely stores your health data, uses encryption, and never shares your information without your consent. For full details, please refer to our official privacy policy document.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              // Add more legal text as needed
            ],
          ),
        ),
      ),
    );
  }
}
