import 'dart:async';
import 'dart:convert';

import 'package:nekoton_flutter/nekoton_flutter.dart';

import '../../../../../../../../logger.dart';
import '../../../../../data/repositories/permissions_repository.dart';
import '../../../../../data/repositories/transport_repository.dart';
import '../../../../../injection.dart';
import '../custom_in_app_web_view_controller.dart';

Future<dynamic> runLocalHandler({
  required CustomInAppWebViewController controller,
  required List<dynamic> args,
}) async {
  try {
    final jsonInput = args.first as Map<String, dynamic>;

    final input = RunLocalInput.fromJson(jsonInput);

    final currentOrigin = await controller.controller.getUrl().then((v) => v?.authority);

    if (currentOrigin == null) throw Exception();

    final transport = await getIt.get<TransportRepository>().transport;

    await getIt.get<PermissionsRepository>().checkPermissions(
      origin: currentOrigin,
      requiredPermissions: [Permission.basic],
    );

    FullContractState? contractState = input.cachedState;

    if (input.cachedState == null) {
      contractState = await transport.getFullAccountState(address: input.address);
    }

    if (contractState == null) throw Exception();

    if (!contractState.isDeployed) throw Exception();

    final output = runLocal(
      accountStuffBoc: contractState.boc,
      contractAbi: input.functionCall.abi,
      method: input.functionCall.method,
      input: input.functionCall.params,
    );

    final jsonOutput = jsonEncode(output.toJson());

    return jsonOutput;
  } catch (err, st) {
    logger.e(err, err, st);
  }
}