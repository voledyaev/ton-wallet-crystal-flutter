import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nekoton_flutter/nekoton_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../models/approval_request.dart';

@lazySingleton
class ApprovalsRepository {
  final _approvalsSubject = PublishSubject<ApprovalRequest>();

  ApprovalsRepository();

  Stream<ApprovalRequest> get approvalsStream => _approvalsSubject;

  Future<Permissions> requestForPermissions({
    required String origin,
    required List<Permission> permissions,
  }) async {
    final completer = Completer<Permissions>();

    final request = ApprovalRequest.requestPermissions(
      origin: origin,
      permissions: permissions,
      completer: completer,
    );

    _approvalsSubject.add(request);

    return completer.future;
  }

  Future<Tuple2<String, String>> requestToSendMessage({
    required String origin,
    required String sender,
    required String recipient,
    required String amount,
    required bool bounce,
    required FunctionCall? payload,
    required KnownPayload? knownPayload,
  }) async {
    final completer = Completer<Tuple2<String, String>>();

    final request = ApprovalRequest.sendMessage(
      origin: origin,
      sender: sender,
      recipient: recipient,
      amount: amount,
      bounce: bounce,
      payload: payload,
      knownPayload: knownPayload,
      completer: completer,
    );

    _approvalsSubject.add(request);

    return completer.future;
  }

  Future<String> requestToCallContractMethod({
    required String origin,
    required String publicKey,
    required String recipient,
    required FunctionCall payload,
  }) async {
    final completer = Completer<String>();

    final request = ApprovalRequest.callContractMethod(
      origin: origin,
      publicKey: publicKey,
      recipient: recipient,
      payload: payload,
      completer: completer,
    );

    _approvalsSubject.add(request);

    return completer.future;
  }
}
