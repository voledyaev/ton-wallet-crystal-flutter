import 'package:flutter/material.dart';

import '../../../../../design/widgets/show_platform_modal_bottom_sheet.dart';
import 'prepare_confirm_page.dart';

Future<void> startConfirmTransactionFlow({
  required BuildContext context,
  required String address,
}) =>
    showPlatformModalBottomSheet(
      context: context,
      builder: (context) => Navigator(
        initialRoute: '/',
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => PrepareConfirmPage(
            modalContext: context,
            address: address,
          ),
        ),
      ),
    );
