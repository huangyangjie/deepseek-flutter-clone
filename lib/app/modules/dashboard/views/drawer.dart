import 'package:deepseek/configs/localization/l10n_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/openai_request.dart';
import '../../../../utils/shared_pref.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      child: Column(
        children: [
          Expanded(
            child:
                OpenaiRequest.messageHistory.isEmpty
                    ? Center(child: Text(L10nEnum.noConversation.tr))
                    : ListView.builder(
                      itemCount: OpenaiRequest.messageHistory.length,
                      itemBuilder: (context, index) {
                        final item = OpenaiRequest.messageHistory[index];
                        return ListTile(
                          title: Text(item.title),
                          onTap: () {
                            Get.find<DashboardController>().reload(item.uuid);
                            Navigator.pop(context);
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(L10nEnum.deleteConfirmation.tr),
                                    content: Text(
                                      L10nEnum.confirmDeleteDialog.tr,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: Text(L10nEnum.cancel.tr),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          OpenaiRequest.messageHistory.removeAt(
                                            index,
                                          );
                                          OpenaiRequest.saveMessageHistory();
                                          AppSharedPref.removeChatHistory(
                                            item.uuid,
                                          );
                                          Get.find<DashboardController>()
                                              .reload(null);
                                          Navigator.pop(context, true);
                                        },
                                        child: Text(L10nEnum.delete.tr),
                                      ),
                                    ],
                                  ),
                            ).then((value) {
                              if (value) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            });
                          },
                        );
                      },
                    ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(L10nEnum.settings.tr),
            onTap: () {
              Get.toNamed(Routes.settings);
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
