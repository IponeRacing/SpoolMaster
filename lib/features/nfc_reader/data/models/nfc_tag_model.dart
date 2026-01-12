import 'package:json_annotation/json_annotation.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/nfc_tag.dart';

part 'nfc_tag_model.g.dart';

@JsonSerializable()
class NfcTagModel {
  final String id;
  final String type;
  final String? manufacturer;
  final Map<String, dynamic>? data;

  NfcTagModel({
    required this.id,
    required this.type,
    this.manufacturer,
    this.data,
  });

  factory NfcTagModel.fromJson(Map<String, dynamic> json) =>
      _$NfcTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$NfcTagModelToJson(this);

  NfcTag toEntity() =>
      NfcTag(id: id, type: type, manufacturer: manufacturer, data: data);

  factory NfcTagModel.fromEntity(NfcTag entity) => NfcTagModel(
    id: entity.id,
    type: entity.type,
    manufacturer: entity.manufacturer,
    data: entity.data,
  );
}
