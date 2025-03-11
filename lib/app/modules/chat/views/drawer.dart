import 'package:deepseek/configs/localization/l10n_enum.dart';
import 'package:deepseek/utils/openai_server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/chat_controller.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final uuids = OpenaiService.to.historyConversation.value.uuids.obs;
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      child: Column(
        children: [
          Obx(
            () => Expanded(
              child:
                  uuids.isEmpty
                      ? Center(child: Text(L10nEnum.noConversation.tr))
                      : ListView.builder(
                        itemCount: uuids.length,
                        itemBuilder: (context, index) {
                          final conversation =
                              OpenaiService
                                  .to
                                  .historyConversation
                                  .value
                                  .conversations[uuids[index]]!;
                          return ListTile(
                            title: Text(conversation.title),
                            onTap: () {
                              Get.find<ChatController>().conversation.value =
                                  conversation;
                              Navigator.pop(context);
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text(
                                        L10nEnum.deleteConfirmation.tr,
                                      ),
                                      content: Text(
                                        L10nEnum.confirmDeleteDialog.tr,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: Text(L10nEnum.cancel.tr),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            OpenaiService
                                                .to
                                                .historyConversation
                                                .value
                                                .removeConversation(
                                                  uuids[index],
                                                );
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
