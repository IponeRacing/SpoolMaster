// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bobbin_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BobbinDataModel _$BobbinDataModelFromJson(Map<String, dynamic> json) =>
    BobbinDataModel(
      filamentType: json['filamentType'] as String,
      color: json['color'] as String,
      weightGrams: (json['weightGrams'] as num).toDouble(),
      manufactureDate: json['manufactureDate'] == null
          ? null
          : DateTime.parse(json['manufactureDate'] as String),
      batchNumber: json['batchNumber'] as String?,
      colorRgb: (json['colorRgb'] as num?)?.toInt(),
      extruderTempMin: (json['extruderTempMin'] as num?)?.toInt(),
      extruderTempMax: (json['extruderTempMax'] as num?)?.toInt(),
      bedTempMin: (json['bedTempMin'] as num?)?.toInt(),
      bedTempMax: (json['bedTempMax'] as num?)?.toInt(),
      diameter: (json['diameter'] as num?)?.toDouble(),
      spoolLength: (json['spoolLength'] as num?)?.toInt(),
      remainingWeight: (json['remainingWeight'] as num?)?.toDouble(),
      brand: json['brand'] as String?,
      detailedType: json['detailedType'] as String?,
      dryingTemp: (json['dryingTemp'] as num?)?.toInt(),
      dryingTime: (json['dryingTime'] as num?)?.toInt(),
      materialVariantId: json['materialVariantId'] as String?,
      materialId: json['materialId'] as String?,
      nozzleSize: (json['nozzleSize'] as num?)?.toDouble(),
      vendorCode: json['vendorCode'] as String?,
      productCode: json['productCode'] as String?,
    );

Map<String, dynamic> _$BobbinDataModelToJson(BobbinDataModel instance) =>
    <String, dynamic>{
      'filamentType': instance.filamentType,
      'color': instance.color,
      'weightGrams': instance.weightGrams,
      'manufactureDate': instance.manufactureDate?.toIso8601String(),
      'batchNumber': instance.batchNumber,
      'colorRgb': instance.colorRgb,
      'extruderTempMin': instance.extruderTempMin,
      'extruderTempMax': instance.extruderTempMax,
      'bedTempMin': instance.bedTempMin,
      'bedTempMax': instance.bedTempMax,
      'diameter': instance.diameter,
      'spoolLength': instance.spoolLength,
      'remainingWeight': instance.remainingWeight,
      'brand': instance.brand,
      'detailedType': instance.detailedType,
      'dryingTemp': instance.dryingTemp,
      'dryingTime': instance.dryingTime,
      'materialVariantId': instance.materialVariantId,
      'materialId': instance.materialId,
      'nozzleSize': instance.nozzleSize,
      'vendorCode': instance.vendorCode,
      'productCode': instance.productCode,
    };
