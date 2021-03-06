import 'package:ever_wallet/data/sources/local/hive/dto/meta.dart';
import 'package:hive/hive.dart';
import 'package:nekoton_flutter/nekoton_flutter.dart';

part 'multisig_submit_transaction_dto.freezed.dart';
part 'multisig_submit_transaction_dto.g.dart';

@freezedDto
class MultisigSubmitTransactionDto with _$MultisigSubmitTransactionDto {
  @HiveType(typeId: 17)
  const factory MultisigSubmitTransactionDto({
    @HiveField(0) required String custodian,
    @HiveField(1) required String dest,
    @HiveField(2) required String value,
    @HiveField(3) required bool bounce,
    @HiveField(4) required bool allBalance,
    @HiveField(5) required String payload,
    @HiveField(6) required String transId,
  }) = _MultisigSubmitTransactionDto;
}

extension MultisigSubmitTransactionX on MultisigSubmitTransaction {
  MultisigSubmitTransactionDto toDto() => MultisigSubmitTransactionDto(
        custodian: custodian,
        dest: dest,
        value: value,
        bounce: bounce,
        allBalance: allBalance,
        payload: payload,
        transId: transId,
      );
}

extension MultisigSubmitTransactionDtoX on MultisigSubmitTransactionDto {
  MultisigSubmitTransaction toModel() => MultisigSubmitTransaction(
        custodian: custodian,
        dest: dest,
        value: value,
        bounce: bounce,
        allBalance: allBalance,
        payload: payload,
        transId: transId,
      );
}
