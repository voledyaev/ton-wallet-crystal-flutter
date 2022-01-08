import 'package:flutter/material.dart';

import '../../../../../design/widgets/show_platform_modal_bottom_sheet.dart';
import 'token_asset_info_modal_body.dart';

Future<void> showTokenAssetInfo({
  required BuildContext context,
  required String owner,
  required String rootTokenContract,
  String? icon,
}) =>
    showPlatformModalBottomSheet(
      context: context,
      builder: (context) => TokenAssetInfoModalBody(
        owner: owner,
        rootTokenContract: rootTokenContract,
        icon: icon,
      ),
    );