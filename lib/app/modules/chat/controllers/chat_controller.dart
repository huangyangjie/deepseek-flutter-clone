import 'package:deepseek/utils/openai_server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/ai_model.dart';

class ChatController extends GetxController {
  final conversation = ConversationModel(uuid: '', title: '', messages: []).obs;
  final isDeepThinking = false.obs;
  final isWebSearching = false.obs;
  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      // 平滑滚动到底部
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void toggleDeepThinking() {
    isDeepThinking.value = !isDeepThinking.value;
    OpenaiService.to.chengeModel(isDeepThinking.value);
  }

  void toggleWebSearch() {
    isWebSearching.value = !isWebSearching.value;
  }

  void sendMessage() {
    if (textController.text == '') return;
    String content = textController.text;
    textController.clear();
    if (conversation.value.messages.isEmpty) {
      conversation.value.uuid =
          DateTime.now().millisecondsSinceEpoch.toString();
      conversation.value.title =
          content.length > 20 ? '${content.substring(0, 20)}...' : content;
    }
    conversation.value.messages.add(
      MessageModel(content: content, role: OpenAiRole.user),
    );
    conversation.value.messages.add(
      MessageModel(content: '', role: OpenAiRole.assistant),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    OpenaiService.to.sendMessage(
      conversation: conversation.value,
      onCallback: (String? content) {
        if (content != null) {
          conversation.value.messages.last.content += content;
          conversation.refresh();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
          // print(content);
        }
      },
      onError: (e) {
        conversation.value.messages.last.content += e.message;
      },
      onDone: () {
        OpenaiService.to.historyConversation.value.addConversation(
          conversation.value,
        );
      },
    );
  }
}
