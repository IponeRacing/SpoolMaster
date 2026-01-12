import 'dart:convert';
import 'package:nfc_filament/features/nfc_reader/data/models/bobbin_data_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';

class ScanHistoryModel extends ScanHistory {
  const ScanHistoryModel({
    required super.id,
    required super.timestamp,
    required super.bobbinData,
  });

  factory ScanHistoryModel.fromBobbinData(BobbinData bobbinData) {
    return ScanHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      bobbinData: bobbinData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'bobbinData': {
        'filamentType': bobbinData.filamentType,
        'color': bobbinData.color,
        'colorRgb': bobbinData.colorRgb,
        'weightGrams': bobbinData.weightGrams,
        'diameter': bobbinData.diameter,
        'spoolLength': bobbinData.spoolLength,
        'extruderTempMin': bobbinData.extruderTempMin,
        'extruderTempMax': bobbinData.extruderTempMax,
        'bedTempMin': bobbinData.bedTempMin,
        'bedTempMax': bobbinData.bedTempMax,
        'manufactureDate': bobbinData.manufactureDate?.toIso8601String(),
        'batchNumber': bobbinData.batchNumber,
        'brand': bobbinData.brand,
        'remainingWeight': bobbinData.remainingWeight,
      },
    };
  }

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    final bobbinDataJson = json['bobbinData'] as Map<String, dynamic>;
    final bobbinDataModel = BobbinDataModel(
      filamentType: bobbinDataJson['filamentType'] as String,
      color: bobbinDataJson['color'] as String,
      colorRgb: bobbinDataJson['colorRgb'] as int?,
      weightGrams: (bobbinDataJson['weightGrams'] as num).toDouble(),
      diameter: bobbinDataJson['diameter'] as double?,
      spoolLength: bobbinDataJson['spoolLength'] as int?,
      extruderTempMin: bobbinDataJson['extruderTempMin'] as int?,
      extruderTempMax: bobbinDataJson['extruderTempMax'] as int?,
      bedTempMin: bobbinDataJson['bedTempMin'] as int?,
      bedTempMax: bobbinDataJson['bedTempMax'] as int?,
      manufactureDate: bobbinDataJson['manufactureDate'] != null
          ? DateTime.parse(bobbinDataJson['manufactureDate'] as String)
          : null,
      batchNumber: bobbinDataJson['batchNumber'] as String?,
      brand: bobbinDataJson['brand'] as String?,
      remainingWeight: bobbinDataJson['remainingWeight'] as double?,
    );

    return ScanHistoryModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      bobbinData: bobbinDataModel.toEntity(),
    );
  }

  String toJsonString() => json.encode(toJson());

  factory ScanHistoryModel.fromJsonString(String jsonString) {
    return ScanHistoryModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
  }
}
