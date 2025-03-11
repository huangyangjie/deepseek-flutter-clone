import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<ChatController>(
        () => ChatController(),
      )
    ];
  }
}
