import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:deepseek/configs/api_config.dart';
import 'package:deepseek/models/ai_model.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';

import 'shared_pref.dart';

class Message {
  String think = "";
  bool isThinking = false;
  String content;
  final OpenAIChatMessageRole role;
  final DateTime timestamp;
  final GlobalKey<ExpansionTileCoreState> deepThinkKey = GlobalKey();

  bool isUser() {
    return role == OpenAIChatMessageRole.user;
  }

  String toJson() {
    return jsonEncode({
      'think': think,
      'content': content,
      'role': role.toString(),
      'timestamp': timestamp.toString(),
    });
  }

  Message.fromJson(Map<String, dynamic> json)
    : think = json['think'] ?? "",
      content = json['content'] ?? "",
      role = OpenAIChatMessageRole.values.firstWhere(
        (e) => e.toString() == json['role'],
      ),
      timestamp = DateTime.parse(json['timestamp']);

  void addNewMessage(String message) {
    if (isThinking) {
      think += message;
    } else {
      content += message;
    }

    if (content.contains("<think>")) {
      isThinking = true;
      deepThinkKey.currentState?.expand();
      think = content.replaceAll("<think>", "");
      // 去除开头的空格和换行
      think = think.replaceAll(RegExp(r"^\s+"), "");
      content = "";
    }

    if (think.contains("</think>")) {
      isThinking = false;
      deepThinkKey.currentState?.collapse();
      content = think.split("</think>")[1];
      think = think.split("</think>")[0];
    }
  }

  Message({required this.content, required this.role, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

class MessageUuidTitle {
  final String uuid;
  final String title;

  MessageUuidTitle({required this.uuid, required this.title});
}

class OpenaiRequest {
  static String _customModelName = "deepseek-v3";
  static String _deepThinkModelName = "deepseek-r1";
  static String _model = _customModelName;
  static List<MessageUuidTitle> messageHistory = [];

  static void chengeModel(bool isThink) {
    _model = isThink ? _deepThinkModelName : _customModelName;
  }

  static void loadMessageHistory() {
    List<String> uuids = AppSharedPref.getChatHistoryUuid();
    for (String uuid in uuids) {
      Map<String, dynamic> uuidtitle = jsonDecode(uuid);
      if (uuidtitle['uuid'] != null && uuidtitle['title'] != null) {
        messageHistory.add(
          MessageUuidTitle(
            uuid: uuidtitle['uuid']!,
            title: uuidtitle['title']!,
          ),
        );
      }
    }
  }

  static void saveMessageHistory() {
    List<String> uuids = [];
    for (MessageUuidTitle uuidtitle in messageHistory) {
      uuids.add(jsonEncode({'uuid': uuidtitle.uuid, 'title': uuidtitle.title}));
    }
    AppSharedPref.setChatHistoryUuid(uuids);
  }

  static void addMessageHistory(String uuid, String title) {
    // 限制title的长度为20
    if (title.length > 20) {
      title = title.substring(0, 20);
      title += "...";
    }
    messageHistory.add(MessageUuidTitle(uuid: uuid, title: title));
    saveMessageHistory();
  }

  static void init() {
    CustomModel model = AppSharedPref.getCustomModel();
    if (model.isActivate) {
      OpenAI.baseUrl = model.baseUrl;
      OpenAI.apiKey = model.apiKey;
      OpenAI.showLogs = false;
      OpenAI.showResponsesLogs = false;
      _customModelName = model.normalModel;
      _deepThinkModelName = model.deepThinkingModel;
    } else {
      OpenAI.baseUrl = ApiConfig.baseUrl;
      OpenAI.apiKey = ApiConfig.apiKey;
      OpenAI.showLogs = false;
      OpenAI.showResponsesLogs = false;
    }

    loadMessageHistory();
  }

  static List<OpenAIChatCompletionChoiceMessageModel> _contentFromMessage(
    List<Message> messages,
  ) {
    final content = <OpenAIChatCompletionChoiceMessageModel>[];
    for (final message in messages) {
      if (message.content != '') {
        content.add(
          OpenAIChatCompletionChoiceMessageModel(
            role: message.role,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                message.content,
              ),
            ],
          ),
        );
      }
    }
    return content;
  }

  static void addChat(
    List<Message> messages,
    void Function(String)? callback, {
    void Function()? onDone,
  }) {
    final chatStream = OpenAI.instance.chat.createStream(
      model: _model,
      messages: _contentFromMessage(messages),
      seed: 423,
      n: 2,
    );
    chatStream.listen((streamChatCompletion) {
      final content = streamChatCompletion.choices.first.delta.content;
      callback!(content?[0]?.text ?? "");
    }, onDone: onDone, onError: (error) {
      callback!("DeepSeek Error: $error");
      onDone!();
    });
  }
}
