import 'package:get/get.dart';

import '../../../../../../models/ai_model.dart';
import '../../../../../../utils/openai_request.dart';
import '../../../../../../utils/shared_pref.dart';

class ModelController extends GetxController {
  late final customModel =
      CustomModel(
        isActivate: false,
        baseUrl: '',
        apiKey: '',
        normalModel: 'deepseek-v3',
        deepThinkingModel: 'deepseek-r1',
      ).obs;
    final _isNeedSave = false.obs;

  @override
  void onInit() {
    super.onInit();
    customModel.value = AppSharedPref.getCustomModel();
  }

  bool isNeedSave() {
    return _isNeedSave.value;
  }

  void setCustomModelActivate(bool isActivate) {
    customModel.value.isActivate = isActivate;
    customModel.refresh();
    _isNeedSave.value = true;
  }

  void setBaseUrl(String baseUrl) {
    customModel.value.baseUrl = baseUrl;
    _isNeedSave.value = true;
  }

  void setApiKey(String apiKey) {
    customModel.value.apiKey = apiKey;
    _isNeedSave.value = true;
  }

  void setNormalModel(String normalModel) {
    customModel.value.normalModel = normalModel;
    _isNeedSave.value = true;
  }

  void setDeepThinkingModel(String deepThinkingModel) {
    customModel.value.deepThinkingModel = deepThinkingModel;
    _isNeedSave.value = true;
  }

  void saveCustomModel() {
    _isNeedSave.value = false;
    AppSharedPref.setCustomModel(customModel.value);
    OpenaiRequest.init();
    Get.snackbar(
      'Success',
      'Save successfully',
      snackPosition: SnackPosition.bottom,
    );
  }
}
