import 'package:deepseek/models/ai_model.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

import '../../../../configs/localization/l10n_enum.dart';
import '../controllers/chat_controller.dart';
import 'drawer.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: 200.0,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              controller.conversation.value = ConversationModel(
                uuid: '',
                title: '',
                messages: [],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () =>
                  controller.conversation.value.messages.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/deepseek-color.png',
                                width: 50,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 300,
                              child: Center(
                                child: Text(
                                  L10nEnum.hiIAmDeepSeek.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: 260,
                              child: Center(
                                child: Text(
                                  L10nEnum.canHelpWithQuestionsAndWriting.tr,
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.conversation.value.messages.length,
                        itemBuilder: (context, index) {
                          final message = controller.conversation.value.messages[index];
                          return ChatMessageWidget(message: message);
                        },
                      ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              // border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                TextField(
                  autofocus: false,
                  autocorrect: false,
                  controller: controller.textController,
                  decoration: InputDecoration(
                    hintText: L10nEnum.sendMessageToDeepSeek.tr,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  onSubmitted: (_) => controller.sendMessage(),
                ),
                Row(
                  children: [
                    Obx(
                      () => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              controller.isDeepThinking.value
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade200,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          minimumSize: Size(0, 24),
                        ),
                        onPressed: () => controller.toggleDeepThinking(),
                        icon: Icon(Icons.psychology, size: 14),
                        label: Text(
                          L10nEnum.deepThinkingR1.tr,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              controller.isWebSearching.value
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade200,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          minimumSize: Size(0, 24),
                        ),
                        onPressed: () => controller.toggleWebSearch(),
                        icon: Icon(Icons.search, size: 14),
                        label: Text(
                          L10nEnum.onlineSearch.tr,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 14,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          controller.sendMessage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            message.isUser
                ? [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'You',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(message.content),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(child: Icon(Icons.person)),
                ]
                : [
                  CircleAvatar(child: Icon(Icons.computer)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DeepSeek',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Offstage(
                          offstage: message.think == null,
                          // maintainSize: true,
                          // maintainAnimation: true,
                          // maintainState: true,
                          child: ExpansionTileItem(
                            expansionKey: message.deepThinkKey,
                            initiallyExpanded: false,
                            title: Text(L10nEnum.deepThinking.tr),
                            isHasTopBorder: false,
                            isHasBottomBorder: false,
                            isDefaultVerticalPadding: false,
                            tilePadding: EdgeInsets.zero,
                            trailingIcon: const Icon(Icons.arrow_drop_down),
                            children: [
                              Text(
                                message.think ?? "",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        GptMarkdown(message.content),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              icon: Icon(Icons.copy, size: 16),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: message.content),
                                );
                                Get.snackbar(
                                  L10nEnum.copy.tr,
                                  L10nEnum.copySuccess.tr,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
      ),
    );
  }
}
