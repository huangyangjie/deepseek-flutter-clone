import 'dart:developer';

import 'package:deepseek/app/modules/chat/bindings/chat_binding.dart';
import 'package:deepseek/app/modules/chat/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/settings/children/model/bindings/model_binding.dart';
import '../modules/settings/children/model/views/model_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/children/dark_mode/bindings/dark_mode_binding.dart';
import '../modules/settings/children/dark_mode/views/dark_mode_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.dashboard;

  static final routes = [
    // GetPage(
    //   name: _Paths.root,
    //   page: () => const RootView(),
    //   bindings: [RootBinding()],
    //   children: [
    GetPage(
      name: _Paths.dashboard,
      participatesInRootNavigator: true,
      page: () => const ChatView(),
      bindings: [ChatBinding()],
    ),
    GetPage(
      name: _Paths.settings,
      page: () => const SettingsView(),
      bindings: [SettingsBinding()],
    ),
    GetPage(
      name: _Paths.language,
      page: () => const LanguageView(),
      bindings: [LanguageBinding()],
    ),
    GetPage(
      name: _Paths.darkMode,
      page: () => const DarkModeView(),
      bindings: [DarkModeBinding()],
    ),
    GetPage(
      name: _Paths.model,
      page: () => const ModelView(),
      bindings: [ModelBinding()],
    ),
    //   ],
    // ),
  ];
}

class MainMiddleware extends GetMiddleware {
  @override
  void onPageDispose() {
    log('MainMiddleware onPageDispose');
    super.onPageDispose();
  }

  @override
  Widget onPageBuilt(Widget page) {
    log('MainMiddleware onPageBuilt');
    return super.onPageBuilt(page);
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    log('MainMiddleware onPageCalled for route: ${page?.name}');
    return super.onPageCalled(page);
  }

  @override
  List<R>? onBindingsStart<R>(List<R>? bindings) {
    log('MainMiddleware onBindingsStart');
    return super.onBindingsStart(bindings);
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    log('MainMiddleware onPageBuildStart');

    return super.onPageBuildStart(page);
  }
}
