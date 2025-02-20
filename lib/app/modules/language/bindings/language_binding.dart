import 'package:get/get.dart';

import '../controllers/language_controller.dart';

class LanguageBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<LanguageController>(
        () => LanguageController(),
      )
    ];
  }
}
