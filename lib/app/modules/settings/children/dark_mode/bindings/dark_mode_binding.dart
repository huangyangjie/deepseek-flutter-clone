
import 'package:get/get.dart';

import '../controllers/dark_mode_controller.dart';

class DarkModeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<DarkModeController>(
        () => DarkModeController(),
      )
    ];
  }
}
