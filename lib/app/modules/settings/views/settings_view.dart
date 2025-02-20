import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../configs/localization/l10n_enum.dart';
import '../../../../widgets/app_items.dart';
import '../../../routes/app_pages.dart';
import '../children/others/about_view.dart';
import '../children/others/help_center_view.dart';
import '../children/others/user_agreement_view.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Get.back(),
        ),
        title: Text(L10nEnum.settings.tr),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          buildSettingsItem(Icons.article, L10nEnum.model.tr, () {
            Get.toNamed(Routes.model);
          }),
          buildSettingsItem(Icons.language, L10nEnum.language.tr, () {
            Get.toNamed(Routes.language);
          }),
          buildSettingsItem(Icons.dark_mode, L10nEnum.darkMode.tr, () {
            Get.toNamed(Routes.darkMode);
          }),
          buildSettingsItem(Icons.privacy_tip, L10nEnum.userAgreement.tr, () {
            Get.to(() => const UserAgreementView());
          }),
          buildSettingsItem(Icons.help_center, L10nEnum.helpCenter.tr, () {
            Get.to(() => const HelpCenterView());
          }),
          buildSettingsItem(Icons.notifications, L10nEnum.about.tr, () {
            Get.to(() => const AboutView());
          }),
        ],
      ), // Add your language selection content here
    );
  }
}
