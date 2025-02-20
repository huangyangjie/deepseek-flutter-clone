import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../configs/localization/l10n_enum.dart';
import '../../../../../../widgets/app_textfield.dart';
import '../controllers/model_controller.dart';

class ModelView extends GetView<ModelController> {
  const ModelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Get.back(),
        ),
        title: Text(L10nEnum.model.tr),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                      controller.isNeedSave() ? Colors.red : Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed:
                    controller.isNeedSave()
                        ? () {
                          // Add save functionality here
                          controller.saveCustomModel();
                        }
                        : null,
                child: Text(
                  L10nEnum.save.tr,
                  style: TextStyle(
                    color:
                        controller.isNeedSave()
                            ? Colors.white
                            : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Obx(
            () => SwitchListTile(
              title: Text(L10nEnum.customModel.tr),
              value: controller.customModel.value.isActivate,
              onChanged: (bool value) {
                controller.setCustomModelActivate(value);
              },
            ),
          ),
          Obx(
            () =>
                controller.customModel.value.isActivate
                    ? Column(
                      children: [
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Base URL',
                          hintText: 'Enter base URL',
                          initialValue: controller.customModel.value.baseUrl,
                          onChanged: (text) {
                            controller.setBaseUrl(text);
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'API Key',
                          hintText: 'Enter API key',
                          obscureText: true,
                          initialValue: controller.customModel.value.apiKey,
                          onChanged: (text) {
                            controller.setApiKey(text);
                          },
                          // Add controller and validation
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: L10nEnum.normalModel.tr,
                          initialValue:
                              controller.customModel.value.normalModel,
                          onChanged: (text) {
                            controller.setNormalModel(text);
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: L10nEnum.deepThinkingModel.tr,
                          initialValue:
                              controller.customModel.value.deepThinkingModel,
                          onChanged: (text) {
                            controller.setNormalModel(text);
                          },
                        ),
                      ],
                    )
                    : Column(children: []),
          ),
        ],
      ),
    );
  }
}
