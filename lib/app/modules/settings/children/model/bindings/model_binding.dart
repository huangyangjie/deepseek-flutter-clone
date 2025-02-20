
import 'package:get/get.dart';

import '../controllers/model_controller.dart';

class ModelBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<ModelController>(
        () => ModelController(),
      )
    ];
  }
}
