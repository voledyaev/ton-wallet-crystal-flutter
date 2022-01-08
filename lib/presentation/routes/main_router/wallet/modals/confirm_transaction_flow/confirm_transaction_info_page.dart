import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nekoton_flutter/nekoton_flutter.dart';

import '../../../../../../data/repositories/biometry_repository.dart';
import '../../../../../../domain/blocs/biometry/biometry_info_provider.dart';
import '../../../../../../domain/blocs/ton_wallet/ton_wallet_estimate_fees_provider.dart';
import '../../../../../../domain/blocs/ton_wallet/ton_wallet_prepare_confirm_transaction_provider.dart';
import '../../../../../../injection.dart';
import '../../../../../design/extension.dart';
import '../../../../../design/widgets/custom_back_button.dart';
import '../../../../../design/widgets/custom_elevated_button.dart';
import '../../../../../design/widgets/sectioned_card.dart';
import '../../../../../design/widgets/sectioned_card_section.dart';
import '../common/password_enter_page.dart';
import '../common/send_result_page.dart';

class ConfirmTransactionInfoPage extends ConsumerStatefulWidget {
  final BuildContext modalContext;
  final String address;
  final String publicKey;
  final String transactionId;
  final String destination;
  final String amount;
  final String? comment;

  const ConfirmTransactionInfoPage({
    Key? key,
    required this.modalContext,
    required this.address,
    required this.publicKey,
    required this.transactionId,
    required this.destination,
    required this.amount,
    this.comment,
  }) : super(key: key);

  @override
  _NewSelectWalletTypePageState createState() => _NewSelectWalletTypePageState();
}

class _NewSelectWalletTypePageState extends ConsumerState<ConfirmTransactionInfoPage> {
  @override
  void initState() {
    super.initState();
    ref.read(tonWalletPrepareConfirmTransactionProvider.notifier).prepareConfirmTransaction(
          publicKey: widget.publicKey,
          address: widget.address,
          transactionId: widget.transactionId,
        );
    ref.read(tonWalletPrepareConfirmTransactionProvider.future).then(
          (value) => ref.read(tonWalletEstimateFeesProvider.notifier).estimateFees(
                address: widget.address,
                message: value,
                amount: widget.amount,
              ),
        );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: const Text(
            'Confirm transaction',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: body(),
      );

  Widget body() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                controller: ModalScrollController.of(context),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    card(),
                    const SizedBox(height: 64),
                  ],
                ),
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
      );

  Widget card() => SectionedCard(
        sections: [
          recipient(),
          amount(),
          fee(),
          if (widget.comment != null) comment(),
        ],
      );

  Widget recipient() => SectionedCardSection(
        title: 'Recipient',
        subtitle: widget.destination,
        isSelectable: true,
      );

  Widget amount() => SectionedCardSection(
        title: 'Amount',
        subtitle: '${widget.amount.toTokens().removeZeroes()} TON',
      );

  Widget fee() => Consumer(
        builder: (context, ref, child) {
          final message = ref.watch(tonWalletPrepareConfirmTransactionProvider);

          final fees = message.asData?.value != null ? ref.watch(tonWalletEstimateFeesProvider) : null;

          final subtitle = message.maybeWhen(
                error: (err, st) => err.toString(),
                orElse: () => null,
              ) ??
              fees?.when(
                data: (data) => '${data.toTokens().removeZeroes()} TON',
                error: (err, st) => err.toString(),
                loading: () => null,
              );

          final hasError = message.maybeWhen(
                error: (err, st) => true,
                orElse: () => false,
              ) ||
              (fees?.maybeWhen(
                    error: (err, st) => true,
                    orElse: () => false,
                  ) ??
                  false);

          return SectionedCardSection(
            title: 'Blockchain fee',
            subtitle: subtitle,
            hasError: hasError,
          );
        },
      );

  Widget comment() => SectionedCardSection(
        title: 'Comment',
        subtitle: widget.comment,
      );

  Widget submitButton() => Consumer(
        builder: (context, ref, child) {
          final message = ref.watch(tonWalletPrepareConfirmTransactionProvider).asData?.value;

          final fees = message != null ? ref.watch(tonWalletEstimateFeesProvider).asData?.value : null;

          return CustomElevatedButton(
            onPressed: message != null && fees != null
                ? () => onPressed(
                      read: ref.read,
                      message: message,
                      publicKey: widget.publicKey,
                    )
                : null,
            text: 'Send',
          );
        },
      );

  Future<void> onPressed({
    required Reader read,
    required UnsignedMessage message,
    required String publicKey,
  }) async {
    String? password;

    final info = await read(biometryInfoProvider.future);

    if (info.isAvailable && info.isEnabled) {
      password = await getPasswordFromBiometry(publicKey);
    }

    if (!mounted) return;

    if (password != null) {
      pushDeploymentResult(
        message: message,
        password: password,
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PasswordEnterPage(
            modalContext: widget.modalContext,
            publicKey: publicKey,
            onSubmit: (password) => pushDeploymentResult(
              message: message,
              password: password,
            ),
          ),
        ),
      );
    }
  }

  Future<String?> getPasswordFromBiometry(String publicKey) async {
    try {
      final password = await getIt.get<BiometryRepository>().getKeyPassword(
            localizedReason: 'Please authenticate to interact with wallet',
            publicKey: publicKey,
          );

      return password;
    } catch (err) {
      return null;
    }
  }

  Future<void> pushDeploymentResult({
    required UnsignedMessage message,
    required String password,
  }) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SendResultPage(
            modalContext: widget.modalContext,
            address: widget.address,
            message: message,
            publicKey: widget.publicKey,
            password: password,
            sendingText: 'Transaction is sending...',
            successText: 'Transaction has been sent successfully',
          ),
        ),
        (_) => false,
      );
}