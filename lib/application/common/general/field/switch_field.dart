import 'package:ever_wallet/application/util/colors.dart';
import 'package:ever_wallet/application/util/extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';

class EWSwitchField extends StatelessWidget {
  const EWSwitchField({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final themeStyle = context.themeStyle;

    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: themeStyle.colors.secondaryButtonTextColor,
      trackColor: ColorsRes.greyLight,
      thumbColor: value
          ? themeStyle.colors.iconPrimaryButtonColor
          : themeStyle.colors.iconSecondaryButtonColor,
    );
  }
}
