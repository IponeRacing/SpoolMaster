import 'dart:convert';
import 'package:nfc_filament/features/nfc_reader/data/models/bobbin_data_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Modèle pour sauvegarder un tag NFC Bambu Lab cloné
class ClonedTagModel {
  final String id;
  final DateTime clonedAt;
  final BobbinData bobbinData;
  final Map<int, List<int>> rawBlocks; // Tous les blocs bruts
  final String? customName;

  ClonedTagModel({
    required this.id,
    required this.clonedAt,
    required this.bobbinData,
    required this.rawBlocks,
    this.customName,
  });

  /// Créer un clone depuis les données natives
  factory ClonedTagModel.fromNativeData({
    required BobbinData bobbinData,
    required Map<String, dynamic> rawBlocks,
    String? customName,
  }) {
    // Convertir les blocs de String keys vers int keys
    final Map<int, List<int>> blocksMap = {};
    for (final entry in rawBlocks.entries) {
      // Format: "block_5" -> 5
      final blockNum = int.parse(entry.key.replaceAll('block_', ''));
      final blockData = (entry.value as List).cast<int>();
      blocksMap[blockNum] = blockData;
    }

    return ClonedTagModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clonedAt: DateTime.now(),
      bobbinData: bobbinData,
      rawBlocks: blocksMap,
      customName: customName,
    );
  }

  /// Convertir en JSON pour sauvegarde
  Map<String, dynamic> toJson() {
    final bobbinModel = BobbinDataModel(
      filamentType: bobbinData.filamentType,
      color: bobbinData.color,
      weightGrams: bobbinData.weightGrams,
      manufactureDate: bobbinData.manufactureDate,
      batchNumber: bobbinData.batchNumber,
      colorRgb: bobbinData.colorRgb,
      extruderTempMin: bobbinData.extruderTempMin,
      extruderTempMax: bobbinData.extruderTempMax,
      bedTempMin: bobbinData.bedTempMin,
      bedTempMax: bobbinData.bedTempMax,
      diameter: bobbinData.diameter,
      spoolLength: bobbinData.spoolLength,
      remainingWeight: bobbinData.remainingWeight,
      brand: bobbinData.brand,
    );

    return {
      'id': id,
      'clonedAt': clonedAt.toIso8601String(),
      'bobbinData': bobbinModel.toJson(),
      'rawBlocks': rawBlocks.map((key, value) => MapEntry(key.toString(), value)),
      'customName': customName,
    };
  }

  /// Créer depuis JSON
  factory ClonedTagModel.fromJson(Map<String, dynamic> json) {
    final bobbinDataJson = json['bobbinData'] as Map<String, dynamic>;
    final bobbinModel = BobbinDataModel.fromJson(bobbinDataJson);

    // Convertir rawBlocks
    final rawBlocksJson = json['rawBlocks'] as Map<String, dynamic>;
    final Map<int, List<int>> blocksMap = {};
    for (final entry in rawBlocksJson.entries) {
      final blockNum = int.parse(entry.key);
      final blockData = (entry.value as List).cast<int>();
      blocksMap[blockNum] = blockData;
    }

    return ClonedTagModel(
      id: json['id'] as String,
      clonedAt: DateTime.parse(json['clonedAt'] as String),
      bobbinData: bobbinModel.toEntity(),
      rawBlocks: blocksMap,
      customName: json['customName'] as String?,
    );
  }

  String toJsonString() => json.encode(toJson());

  factory ClonedTagModel.fromJsonString(String jsonString) {
    return ClonedTagModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
  }

  /// Obtenir une description lisible du clone
  String get displayName {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    return '${bobbinData.brand ?? "Bambu Lab"} ${bobbinData.filamentType} ${bobbinData.color}';
  }
}
