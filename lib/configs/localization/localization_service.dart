import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/shared_pref.dart';
import 'ar_AR/ar_ar_translation.dart';
import 'en_US/en_us_translation.dart';
import 'zh_CN/zh_cn_translation.dart';

class LocalizationService extends Translations {
  // prevent creating instance
  LocalizationService._();

  static LocalizationService? _instance;

  static LocalizationService getInstance() {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  // default language
  // todo change the default language
  static String systemLanguage = Get.deviceLocale!.languageCode;
  static Locale defaultLanguage = supportedLanguages[systemLanguage]!;

  // supported languages
  static Map<String,Locale> supportedLanguages = {
    'en' : const Locale('en', 'US'),
    'ar' : const Locale('ar', 'AR'),
    'zh' : const Locale('zh', 'CN'),
  };

  static Map<String,String> supportedLanguagesName = {
    'en' : 'English',
    'ar' : 'العربية',
    'zh' : '简体中文',
  };

  // supported languages fonts family (must be in assets & pubspec yaml) or you can use google fonts
  static Map<String,TextStyle> supportedLanguagesFontsFamilies = {
    // todo add your English font families (add to assets/fonts, pubspec and name it here) default is poppins for english and cairo for arabic
    'en' : const TextStyle(fontFamily: 'Poppins'),
    'ar': const TextStyle(fontFamily: 'Cairo'),
    'zh': const TextStyle(fontFamily: 'NotoSansSC'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'ar_AR': arAR,
    'zh_CN': zhCN,
  };

  /// check if the language is supported
  static isLanguageSupported(String languageCode) =>
    supportedLanguages.keys.contains(languageCode);


  /// update app language by code language for example (en,ar..etc)
  static updateLanguage(String languageCode) async {
    // check if the language is supported
    if(!isLanguageSupported(languageCode)) return;
    // update current language in shared pref
    await AppSharedPref.setCurrentLanguage(languageCode);
    if(!Get.testMode) {
      Get.updateLocale(supportedLanguages[languageCode]!);
    }
  }

  /// check if the language is english
  static bool isItEnglish() =>
      AppSharedPref.getCurrentLocal().languageCode.toLowerCase().contains('en');

  /// get current locale
  static Locale getCurrentLocal () => AppSharedPref.getCurrentLocal();
}
