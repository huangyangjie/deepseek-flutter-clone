import 'package:get/get.dart';
import 'package:openai_dart/openai_dart.dart';

import '../configs/api_config.dart';
import '../models/ai_model.dart';
import 'shared_pref.dart';

class OpenaiService extends GetxService {
  static OpenaiService get to => Get.find();
  final historyConversation = HistoryConversationModel(conversations: {}).obs;
  String _customModelName = ApiConfig.customModel;
  String _deepThinkModelName = ApiConfig.deepThinkingModel;
  String currentModel = ApiConfig.customModel;
  OpenAIClient client = OpenAIClient(
    apiKey: ApiConfig.apiKey,
    baseUrl: ApiConfig.baseUrl,
  );

  @override
  void onInit() async {
    super.onInit();
    historyConversation.value = AppSharedPref.getHistoryConversationModel();
    final customModel = AppSharedPref.getCustomModel();
    if (customModel.isActivate) {
      client = OpenAIClient(
        apiKey: customModel.apiKey,
        baseUrl: customModel.baseUrl,
      );
      _customModelName = customModel.normalModel;
      _deepThinkModelName = customModel.deepThinkingModel;
    }
  }

  void chengeModel(bool value) {
    if (value) {
      currentModel = _deepThinkModelName;
    } else {
      currentModel = _customModelName;
    }
  }

  Future<void> sendMessage({
    required ConversationModel conversation,
    required void Function(String?) onCallback,
    void Function(String?)? onThink,
    void Function()? onDone,
    void Function(OpenAIClientException)? onError,
  }) async {
    // final isDeepThinking = currentModel == _deepThinkModelName;
    // bool isThinking = false;
    try {
      final stream = client.createChatCompletionStream(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(currentModel),
          messages: conversation.toOpenaiMessage(),
        ),
      );

      await for (final res in stream) {
        // String? content = res.choices.first.delta.content;
        // if (content != null && content.contains("</think>")) {
        //   isThinking = false;
        //   onThink?.call(content.split("</think>").first);
        // }
        // if (content != null && content.contains("<think>")) {
        //   isThinking = true;
        //   onThink?.call(content.split("<think>").last);
        // }
        // if (!isThinking) {
        //   onCallback(content);
        // } else {
        //   onThink?.call(content);
        // }
        onCallback(res.choices.first.delta.content);

      }
    } on OpenAIClientException catch (e) {
      onError?.call(e);
    } finally {
      onDone?.call();
    }
  }
}
