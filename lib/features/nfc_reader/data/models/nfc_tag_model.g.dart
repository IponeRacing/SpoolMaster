// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nfc_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NfcTagModel _$NfcTagModelFromJson(Map<String, dynamic> json) => NfcTagModel(
  id: json['id'] as String,
  type: json['type'] as String,
  manufacturer: json['manufacturer'] as String?,
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$NfcTagModelToJson(NfcTagModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'manufacturer': instance.manufacturer,
      'data': instance.data,
    };
