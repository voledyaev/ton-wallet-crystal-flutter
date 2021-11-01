import 'package:crystal/data/dtos/transfer_recipient_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:nekoton_flutter/nekoton_flutter.dart';

part 'token_outgoing_transfer_dto.freezed.dart';
part 'token_outgoing_transfer_dto.g.dart';

@freezed
class TokenOutgoingTransferDto with _$TokenOutgoingTransferDto {
  @HiveType(typeId: 13)
  const factory TokenOutgoingTransferDto({
    @HiveField(0) required TransferRecipientDto to,
    @HiveField(1) required String tokens,
  }) = _TokenOutgoingTransferDto;
}

extension TokenOutgoingTransferDtoToDomain on TokenOutgoingTransferDto {
  TokenOutgoingTransfer toModel() => TokenOutgoingTransfer(
        to: to.toModel(),
        tokens: tokens,
      );
}

extension TokenOutgoingTransferFromDomain on TokenOutgoingTransfer {
  TokenOutgoingTransferDto toDto() => TokenOutgoingTransferDto(
        to: to.toDto(),
        tokens: tokens,
      );
}
