import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../design/design.dart';
import '../../../../../design/widgets/custom_elevated_button.dart';
import '../../../../../design/widgets/modal_header.dart';
import '../../../../../design/widgets/selectable_button.dart';
import 'add_existing_account_page.dart';
import 'add_new_account_name_page.dart';

class AddAccountPage extends StatefulWidget {
  final BuildContext modalContext;
  final String publicKey;

  const AddAccountPage({
    Key? key,
    required this.modalContext,
    required this.publicKey,
  }) : super(key: key);

  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final optionNotifier = ValueNotifier<_Options>(_Options.createNew);

  @override
  void dispose() {
    optionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ModalHeader(
                  text: 'Add account',
                  onCloseButtonPressed: Navigator.of(widget.modalContext).pop,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    physics: const ClampingScrollPhysics(),
                    child: selector(),
                  ),
                ),
                const SizedBox(height: 16),
                submitButton(),
              ],
            ),
          ),
        ),
      );

  Widget selector() => ValueListenableBuilder<_Options>(
        valueListenable: optionNotifier,
        builder: (context, value, child) => Row(
          children: [
            Expanded(
              child: SelectableButton(
                icon: Assets.images.iconCreate,
                text: _Options.createNew.describe(),
                onPressed: () => optionNotifier.value = _Options.createNew,
                isSelected: value == _Options.createNew,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SelectableButton(
                icon: Assets.images.iconAdd,
                text: _Options.addExisting.describe(),
                onPressed: () => optionNotifier.value = _Options.addExisting,
                isSelected: value == _Options.addExisting,
              ),
            ),
          ],
        ),
      );

  Widget submitButton() => ValueListenableBuilder<_Options>(
        valueListenable: optionNotifier,
        builder: (context, value, child) => CustomElevatedButton(
          onPressed: () => onPressed(value),
          text: 'Next',
        ),
      );

  void onPressed(_Options value) {
    late Widget page;

    switch (value) {
      case _Options.createNew:
        page = AddNewAccountNamePage(
          modalContext: widget.modalContext,
          publicKey: widget.publicKey,
        );
        break;
      case _Options.addExisting:
        page = AddExistingAccountPage(
          modalContext: widget.modalContext,
          publicKey: widget.publicKey,
        );
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

enum _Options {
  createNew,
  addExisting,
}

extension on _Options {
  String describe() {
    switch (this) {
      case _Options.createNew:
        return 'Create new account';
      case _Options.addExisting:
        return 'Add an existing account';
    }
  }
}