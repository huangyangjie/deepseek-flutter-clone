import 'package:deepseek/utils/openai_server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'configs/localization/localization_service.dart';
import 'utils/openai_request.dart';
import 'utils/shared_pref.dart';

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // init shared preference
  await AppSharedPref.init();

  OpenaiRequest.init();

  runApp(
    GetMaterialApp(
      title: "Application",
      binds: [Bind.put(OpenaiService())],
      translations: LocalizationService.getInstance(),
      defaultTransition: Transition.noTransition,
      getPages: AppPages.routes,
      // initialRoute: AppPages.initial,
      locale: AppSharedPref.getCurrentLocal(),
    ),
  );
}
