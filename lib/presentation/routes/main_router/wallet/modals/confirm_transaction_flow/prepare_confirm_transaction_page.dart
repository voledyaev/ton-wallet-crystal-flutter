import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../logger.dart';
import '../../../../../../providers/key/keys_provider.dart';
import '../../../../../../providers/key/public_keys_labels_provider.dart';
import '../../../../../../providers/ton_wallet/ton_wallet_info_provider.dart';
import '../../../../../design/design.dart';
import '../../../../../design/widgets/custom_dropdown_button.dart';
import '../../../../../design/widgets/custom_elevated_button.dart';
import '../../../../../design/widgets/modal_header.dart';
import 'confirm_transaction_info_page.dart';

class PrepareConfirmTransactionPage extends StatefulWidget {
  final BuildContext modalContext;
  final String address;
  final List<String> publicKeys;
  final String transactionId;
  final String destination;
  final String amount;
  final String? comment;

  const PrepareConfirmTransactionPage({
    Key? key,
    required this.modalContext,
    required this.address,
    required this.publicKeys,
    required this.transactionId,
    required this.destination,
    required this.amount,
    this.comment,
  }) : super(key: key);

  @override
  _PrepareConfirmTransactionPageState createState() => _PrepareConfirmTransactionPageState();
}

class _PrepareConfirmTransactionPageState extends State<PrepareConfirmTransactionPage> {
  late final ValueNotifier<String> publicKeyNotifier;

  @override
  void initState() {
    super.initState();
    publicKeyNotifier = ValueNotifier<String>(widget.publicKeys.first);
  }

  @override
  void dispose() {
    publicKeyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    ModalHeader(
                      text: 'Confirm transaction',
                      onCloseButtonPressed: Navigator.of(widget.modalContext).pop,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            dropdownButton(),
                            const SizedBox(height: 8),
                            balance(),
                            const SizedBox(height: 64),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      submitButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget dropdownButton() => Consumer(
        builder: (context, ref, child) {
          final publicKeysLabels = ref.watch(publicKeysLabelsProvider).asData?.value ?? {};
          final keys = ref.watch(keysProvider).asData?.value ?? {};
          final keysList = [
            ...keys.keys,
            ...keys.values.whereNotNull().expand((e) => e),
          ];

          return ValueListenableBuilder<String>(
            valueListenable: publicKeyNotifier,
            builder: (context, value, child) => CustomDropdownButton<String>(
              items: widget.publicKeys.map(
                (e) {
                  final title = keysList.firstWhereOrNull((el) => el.publicKey == e)?.name ??
                      publicKeysLabels[e] ??
                      e.ellipsePublicKey();

                  return Tuple2(
                    e,
                    title,
                  );
                },
              ).toList(),
              value: value,
              onChanged: (value) {
                if (value != null) {
                  publicKeyNotifier.value = value;
                }
              },
            ),
          );
        },
      );

  Widget balance() => Consumer(
        builder: (context, ref, child) {
          final tonWalletInfo = ref.watch(tonWalletInfoProvider(widget.address)).asData?.value;

          return Text(
            'Your balance: ${tonWalletInfo?.contractState.balance.toTokens().removeZeroes() ?? '0'} EVER',
            style: const TextStyle(
              color: Colors.black54,
            ),
          );
        },
      );

  Widget submitButton() => ValueListenableBuilder<String>(
        valueListenable: publicKeyNotifier,
        builder: (context, value, child) => CustomElevatedButton(
          onPressed: () => onPressed(value),
          text: 'Next',
        ),
      );

  void onPressed(String publicKey) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            try {
              final a = ConfirmTransactionInfoPage(
                modalContext: widget.modalContext,
                address: widget.address,
                publicKey: publicKey,
                transactionId: widget.transactionId,
                destination: widget.destination,
                amount: widget.amount,
                comment: widget.comment,
              );

              return a;
            } catch (err, st) {
              logger.e(err, err, st);
              rethrow;
            }
          },
        ),
      );
}
