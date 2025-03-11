import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/openai_request.dart';
import '../../../../utils/shared_pref.dart';

class DashboardController extends GetxController {
  final messages = <Message>[].obs;

  final isDeepThinking = false.obs;
  final isWebSearching = false.obs;

  String currentUuid = '';

  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

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

  @override
  void onInit() {
    super.onInit();
    reload(null);
  }

  @override
  void onClose() {
    super.onClose();
    print('onClose');
  }

  void reload(String? uuid) {
    isDeepThinking.value = false;
    isWebSearching.value = false;
    currentUuid = '';
    messages.clear();

    OpenaiRequest.chengeModel(isDeepThinking.value);

    if (uuid != null) {
      currentUuid = uuid;
      List<String> chatHistory = AppSharedPref.getChatHistory(uuid);
      for (String message in chatHistory) {
        messages.add(Message.fromJson(jsonDecode(message)));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void sendMessage() {
    if (textController.text == '') return;
    String content = textController.text;
    textController.clear();
    if (messages.isEmpty) {
      currentUuid = DateTime.now().millisecondsSinceEpoch.toString();
      OpenaiRequest.addMessageHistory(currentUuid, content);
    }
    messages.add(Message(content: "今天天气不错", role: OpenAIChatMessageRole.user));
    messages.add(Message(content: '是啊，真不错', role: OpenAIChatMessageRole.assistant));
    messages.add(Message(content: '我刚刚问了什么？', role: OpenAIChatMessageRole.user));
    messages.add(Message(content: '', role: OpenAIChatMessageRole.assistant));
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    OpenaiRequest.addChat(
      messages: messages,
      callback: (response) {
        messages.last.addNewMessage(response);
        messages.refresh();
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      },
      onDone: () {
        if (messages.last.content == '') {
          messages.removeLast();
          return;
        }
        messages.last.content = messages.last.content
            .split("<|im_end|>")[0]
            .replaceAll("<|im_start|>assistant", "");
        messages.refresh();
        List<String> chatHistory = [];
        for (Message message in messages) {
          chatHistory.add(message.toJson());
        }
        AppSharedPref.saveChatHistory(currentUuid, chatHistory);
      },
    );
  }

  void toggleDeepThinking() {
    isDeepThinking.value = !isDeepThinking.value;
    OpenaiRequest.chengeModel(isDeepThinking.value);
  }

  void toggleWebSearch() {
    isWebSearching.value = !isWebSearching.value;
  }
}
