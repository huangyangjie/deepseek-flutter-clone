import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../configs/localization/l10n_enum.dart';
import '../../../../../widgets/app_items.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Get.back(),
          ),
          title: Text(L10nEnum.helpCenter.tr),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            buildSettingsItem(Icons.help_center, 'FAQ', () {}),
            buildSettingsItem(Icons.contact_mail, 'Contact Us', () {}),
            buildSettingsItem(Icons.feedback, 'Feedback', () {}),
            buildSettingsItem(Icons.privacy_tip, 'Privacy Policy', () {}),
          ],
        ));
  }
}
