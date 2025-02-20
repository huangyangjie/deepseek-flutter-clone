
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dark_mode_controller.dart';

class DarkModeView extends GetView<DarkModeController> {
    const DarkModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => Get.back(),
          ),
          title: Text('DarkMode'),
      ),
      body: Center(
        child: Text(
        'DarkModeView is working',
        style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
