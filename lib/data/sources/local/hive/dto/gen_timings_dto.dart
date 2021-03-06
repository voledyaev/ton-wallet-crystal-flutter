import 'package:ever_wallet/data/sources/local/hive/dto/meta.dart';
import 'package:hive/hive.dart';
import 'package:nekoton_flutter/nekoton_flutter.dart';

part 'gen_timings_dto.freezed.dart';
part 'gen_timings_dto.g.dart';

@freezedDto
class GenTimingsDto with _$GenTimingsDto {
  @HiveType(typeId: 9)
  const factory GenTimingsDto({
    @HiveField(0) required String genLt,
    @HiveField(1) required int genUtime,
  }) = _GenTimingsDto;
}

extension GenTimingsX on GenTimings {
  GenTimingsDto toDto() => GenTimingsDto(
        genLt: genLt,
        genUtime: genUtime,
      );
}

extension GenTimingsDtoX on GenTimingsDto {
  GenTimings toModel() => GenTimings(
        genLt: genLt,
        genUtime: genUtime,
      );
}
