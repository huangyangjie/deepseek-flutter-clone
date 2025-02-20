import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../../../../routes/app_pages.dart';
import '../../../../configs/localization/l10n_enum.dart';
import '../controllers/language_controller.dart';
// import '../../home/views/drawer.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Get.back(),
        ),
        title: Text(L10nEnum.language.tr),
        actions: [
          Obx(
            () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: controller.isCurrentLanguage(
                            controller.selectedLanguage.value)
                        ? Colors.grey[200]
                        : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: controller
                          .isCurrentLanguage(controller.selectedLanguage.value)
                      ? null
                      : () {
                          // Add save functionality here
                          controller.setLanguage();
                        },
                  child: Text(
                    L10nEnum.save.tr,
                    style: TextStyle(
                        color: controller.isCurrentLanguage(
                                controller.selectedLanguage.value)
                            ? Colors.grey[700]
                            : Colors.white),
                  ),
                )),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var locale
              in controller.getLanguageNames()) // Add more languages as needed
            ListTile(
              title: Text(locale),
              trailing: Obx(() => controller.selectedLanguage.value == locale
                  ? const Icon(Icons.check, color: Colors.blue)
                  : const SizedBox()),
              onTap: () => controller.selectedLanguage.value = locale,
            ),
        ],
      ),
    );
  }
}
