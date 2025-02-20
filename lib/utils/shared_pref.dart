import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/localization/localization_service.dart';
import '../models/ai_model.dart';

class AppSharedPref {
  // prevent making instance
  AppSharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';

  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true; // todo set the default theme (true for light, false for dark)

  /// save current locale
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// get current locale
  static Locale getCurrentLocal(){
      String? langCode = _sharedPreferences.getString(_currentLocalKey);
      // default language is english
      if(langCode == null){
        return LocalizationService.defaultLanguage;
      }
      return LocalizationService.supportedLanguages[langCode]!;
  }

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();

  static List<String> getChatHistoryUuid() {
    return _sharedPreferences.getStringList('chat_history_uuid') ?? [];
  }

  static Future<bool> setChatHistoryUuid(List<String> uuids) async {
    return await _sharedPreferences.setStringList('chat_history_uuid', uuids);
  }

  static Future<void> saveChatHistory(String uuid, List<String> chatHistory) async {
    _sharedPreferences.setStringList('chat_history_uuid_$uuid', chatHistory);
  }

  static Future<void> removeChatHistory(String uuid) async {
    _sharedPreferences.remove('chat_history_uuid_$uuid');
  }

  static List<String> getChatHistory(String uuid) {
    return _sharedPreferences.getStringList('chat_history_uuid_$uuid') ?? [];
  }

  static CustomModel getCustomModel() {
    String customModelString = _sharedPreferences.getString('custom_model') ?? '';
    if (customModelString.isEmpty) {
      return CustomModel(
        isActivate: false,
        baseUrl: '',
        apiKey: '',
        normalModel: 'deepseek-v3',
        deepThinkingModel: 'deepseek-r1',
      );
    }
    return CustomModel.fromJson(jsonDecode(customModelString));
  }

  static Future<bool> setCustomModel(CustomModel model) async {
    return await _sharedPreferences.setString('custom_model', model.toString());
  }
}