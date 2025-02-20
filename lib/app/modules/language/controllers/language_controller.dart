import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../../../configs/localization/localization_service.dart';

/// Language Controller for handling application localization.
///
/// This controller manages the language selection functionality in the app,
/// providing methods to get available languages, check current language,
/// and change the application's language.
///
/// Key features:
/// * Tracks the currently selected language
/// * Provides list of supported language names
/// * Handles language switching
/// * Integrates with LocalizationService for actual language changes
///
/// Usage:
/// ```dart
/// final controller = Get.find<LanguageController>();
/// controller.setLanguage('English');
/// ```
class LanguageController extends GetxController {
  final selectedLanguage = 'English'.obs;
  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = getCurrentLanguage();
  }

  @override
  void onClose() {}

  List<String> getLanguageNames() {
    return LocalizationService.supportedLanguagesName.values.toList();
  }

  bool isCurrentLanguage(String language) {
    return getCurrentLanguage() == language;
  }

  String getCurrentLanguage() {
    Locale lang = LocalizationService.getCurrentLocal();
    return LocalizationService.supportedLanguagesName[lang.languageCode] ??
        "English";
  }

  void setLanguage() {
    log(selectedLanguage.value);
    LocalizationService.updateLanguage(
        LocalizationService.supportedLanguages.keys.firstWhere((key) =>
            LocalizationService.supportedLanguagesName[key] ==
            selectedLanguage.value));
  }
}
