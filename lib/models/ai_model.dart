import 'dart:convert';

import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:openai_dart/openai_dart.dart';

import '../utils/shared_pref.dart';

// 自定义模型
class CustomModel {
  bool isActivate;
  String baseUrl;
  String apiKey;
  String normalModel;
  String deepThinkingModel;

  CustomModel({
    required this.isActivate,
    required this.baseUrl,
    required this.apiKey,
    required this.normalModel,
    required this.deepThinkingModel,
  });

  @override
  String toString() {
    return jsonEncode({
      'isActivate': isActivate,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'normalModel': normalModel,
      'deepThinkingModel': deepThinkingModel,
    });
  }

  factory CustomModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return CustomModel(
      isActivate: json['isActivate'],
      baseUrl: json['baseUrl'],
      apiKey: json['apiKey'],
      normalModel: json['normalModel'],
      deepThinkingModel: json['deepThinkingModel'],
    );
  }
}

enum OpenAiRole { system, user, assistant }

// 单次对话
class MessageModel {
  String? think;
  String content;
  final OpenAiRole role;
  final GlobalKey<ExpansionTileCoreState> deepThinkKey =
      GlobalKey(); // 控制思考过程的展开折叠

  bool get isUser => role == OpenAiRole.user;

  String toJson() {
    return jsonEncode({
      'think': think,
      'content': content,
      'role': role.toString(),
    });
  }

  factory MessageModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return MessageModel(
      think: json['think'] ?? "",
      content: json['content'] ?? "",
      role: OpenAiRole.values.firstWhere((e) => e.toString() == json['role']),
    );
  }

  MessageModel({this.think, required this.content, required this.role});
}

// 单组对话
class ConversationModel {
  String uuid;
  String title;
  List<MessageModel> messages;

  ConversationModel({
    required this.uuid,
    required this.title,
    required this.messages,
  });

  String toJson() {
    return jsonEncode({
      'uuid': uuid,
      'title': title,
      'messages': messages.map((e) => e.toJson()).toList(),
    });
  }

  List<ChatCompletionMessage> toOpenaiMessage() {
    return messages.where((item) => item.content.isNotEmpty).map((item) {
      return item.isUser
          ? ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(item.content),
          )
          : ChatCompletionMessage.assistant(content: item.content);
    }).toList();
  }

  factory ConversationModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return ConversationModel(
      uuid: json['uuid'],
      title: json['title'],
      messages:
          (json['messages'] as List)
              .map((e) => MessageModel.fromJson(e))
              .toList(),
    );
  }
}

class HistoryConversationModel {
  Map<String, ConversationModel> conversations = {};

  List<String> get uuids => conversations.keys.toList();

  String toUuidJson() {
    return jsonEncode({'uuids': conversations.keys.toList()});
  }

  factory HistoryConversationModel.fromUuidJson(String jsonString) {
    final json = jsonDecode(jsonString);
    final conversations = <String, ConversationModel>{};
    for (var uuid in json['uuids']) {
      ConversationModel model = AppSharedPref.getConversionModel(uuid);
      conversations[model.uuid] = model;
    }
    return HistoryConversationModel(conversations: conversations);
  }

  Future<void> addConversation(ConversationModel conversation) async {
    conversations[conversation.uuid] = conversation;
    await AppSharedPref.setConversionModel(conversation);
    await AppSharedPref.setHistoryConversationModel(this);
  }

  Future<bool> removeConversation(String uuid) async {
    if (conversations.containsKey(uuid)) {
      conversations.remove(uuid);
      await AppSharedPref.removeConversionModel(uuid);
      await AppSharedPref.setHistoryConversationModel(this);
      return true;
    }
    return false;
  }

  HistoryConversationModel({required this.conversations});
}
