import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../configs/localization/l10n_enum.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Get.back(),
          ),
          title: Text(L10nEnum.about.tr),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.app_shortcut, size: 50),
              ),
              const SizedBox(height: 20),
              const Text(
                'My App v1.0.0',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '© 2024 Your Company',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text('Privacy Policy'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Terms of Service'),
              ),
            ],
          ),
        ));
  }
}
