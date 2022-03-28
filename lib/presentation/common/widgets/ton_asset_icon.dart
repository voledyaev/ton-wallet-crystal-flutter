import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';

class TonAssetIcon extends StatelessWidget {
  const TonAssetIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipOval(
        child: Assets.images.ever.svg(
          width: 36,
          height: 36,
        ),
      );
}