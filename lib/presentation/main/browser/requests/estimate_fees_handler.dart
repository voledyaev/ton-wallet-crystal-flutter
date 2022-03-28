import 'dart:async';
import 'dart:convert';

import 'package:nekoton_flutter/nekoton_flutter.dart';

import '../../../../../../../../logger.dart';
import '../../../../../data/repositories/permissions_repository.dart';
import '../../../../../data/repositories/ton_wallets_repository.dart';
import '../../../../../injection.dart';
import '../custom_in_app_web_view_controller.dart';

Future<dynamic> estimateFeesHandler({
  required CustomInAppWebViewController controller,
  required List<dynamic> args,
}) async {
  try {
    final jsonInput = args.first as Map<String, dynamic>;

    final input = EstimateFeesInput.fromJson(jsonInput);

    final currentOrigin = await controller.controller.getUrl().then((v) => v?.authority);

    if (currentOrigin == null) throw Exception();

    await getIt.get<PermissionsRepository>().checkPermissions(
      origin: currentOrigin,
      requiredPermissions: [Permission.accountInteraction],
    );

    final permissions = getIt.get<PermissionsRepository>().permissions[currentOrigin] ?? const Permissions();
    final allowedAccount = permissions.accountInteraction;

    if (allowedAccount?.address != input.sender) throw Exception();

    final selectedAddress = allowedAccount!.address;
    final repackedRecipient = repackAddress(input.recipient);

    String? body;
    if (input.payload != null) {
      body = encodeInternalInput(
        contractAbi: input.payload!.abi,
        method: input.payload!.method,
        input: input.payload!.params,
      );
    }

    final unsignedMessage = await getIt.get<TonWalletsRepository>().prepareTransfer(
          address: selectedAddress,
          destination: repackedRecipient,
          amount: input.amount,
          body: body,
        );

    final fees = await getIt.get<TonWalletsRepository>().estimateFees(
          address: selectedAddress,
          message: unsignedMessage,
        );

    final output = EstimateFeesOutput(
      fees: fees,
    );

    final jsonOutput = jsonEncode(output.toJson());

    return jsonOutput;
  } catch (err, st) {
    logger.e(err, err, st);
  }
}