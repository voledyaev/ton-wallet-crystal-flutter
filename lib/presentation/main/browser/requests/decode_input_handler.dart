import 'dart:async';
import 'dart:convert';

import 'package:nekoton_flutter/nekoton_flutter.dart';

import '../../../../../../../../logger.dart';
import '../../../../../data/repositories/permissions_repository.dart';
import '../../../../../injection.dart';
import '../custom_in_app_web_view_controller.dart';

Future<dynamic> decodeInputHandler({
  required CustomInAppWebViewController controller,
  required List<dynamic> args,
}) async {
  try {
    final jsonInput = args.first as Map<String, dynamic>;

    final input = DecodeInputInput.fromJson(jsonInput);

    final currentOrigin = await controller.controller.getUrl().then((v) => v?.authority);

    if (currentOrigin == null) throw Exception();

    await getIt.get<PermissionsRepository>().checkPermissions(
      origin: currentOrigin,
      requiredPermissions: [Permission.basic],
    );

    final output = decodeInput(
      messageBody: input.body,
      contractAbi: input.abi,
      method: input.method,
      internal: input.internal,
    );

    final jsonOutput = jsonEncode(output?.toJson());

    return jsonOutput;
  } catch (err, st) {
    logger.e(err, err, st);
  }
}