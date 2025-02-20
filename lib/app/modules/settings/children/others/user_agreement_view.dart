import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../configs/localization/l10n_enum.dart';

class UserAgreementView extends StatelessWidget {
  const UserAgreementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Get.back(),
        ),
        title: Text(L10nEnum.userAgreement.tr),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10nEnum.userAgreement.tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '1. 接受条款\n'
                '当您使用本应用程序时，即表示您同意遵守本用户协议的所有条款。\n\n'
                '2. 使用规则\n'
                '您同意不会使用本应用程序进行任何非法或未经授权的行为。\n\n'
                '3. 隐私政策\n'
                '我们重视您的隐私，具体详情请参阅隐私政策。\n\n'
                '4. 免责声明\n'
                '本应用程序按"现状"提供，不提供任何明示或暗示的保证。\n\n'
                '5. 协议修改\n'
                '我们保留随时修改本协议的权利。重大变更会通知用户。',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
