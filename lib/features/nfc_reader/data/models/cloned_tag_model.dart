import 'dart:convert';
import 'package:nfc_filament/features/nfc_reader/data/models/bobbin_data_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Modèle pour sauvegarder un tag NFC Bambu Lab cloné
class ClonedTagModel {

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
    final blocksMap = <int, List<int>>{};
    for (final entry in rawBlocks.entries) {
      // Format: "block_5" -> 5
      final blockNum = int.parse(entry.key.replaceAll('block_', ''));
      final blockData = (entry.value as List).cast<int>();
      blocksMap[blockNum] = blockData;
    }

    final now = DateTime.now();
    return ClonedTagModel(
      // Identifiant unique de l'entrée ; les relectures du même tag sont
      // fusionnées par [dedupKey] (UID / contenu), pas par cet id.
      id: now.microsecondsSinceEpoch.toString(),
      clonedAt: now,
      bobbinData: bobbinData,
      rawBlocks: blocksMap,
      customName: customName,
    );
  }

  /// Créer depuis JSON
  factory ClonedTagModel.fromJson(Map<String, dynamic> json) {
    final bobbinDataJson = json['bobbinData'] as Map<String, dynamic>;
    final bobbinModel = BobbinDataModel.fromJson(bobbinDataJson);

    // Convertir rawBlocks
    final rawBlocksJson = json['rawBlocks'] as Map<String, dynamic>;
    final blocksMap = <int, List<int>>{};
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

  factory ClonedTagModel.fromJsonString(String jsonString) {
    return ClonedTagModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
  }
  final String id;
  final DateTime clonedAt;
  final BobbinData bobbinData;
  final Map<int, List<int>> rawBlocks; // Tous les blocs bruts
  final String? customName;

  /// Convertir en JSON pour sauvegarde
  Map<String, dynamic> toJson() {
    final bobbinModel = BobbinDataModel.fromEntity(bobbinData);

    return {
      'id': id,
      'clonedAt': clonedAt.toIso8601String(),
      'bobbinData': bobbinModel.toJson(),
      'rawBlocks': rawBlocks.map((key, value) => MapEntry(key.toString(), value)),
      'customName': customName,
    };
  }

  String toJsonString() => json.encode(toJson());

  /// Identité du tag physique, pour ne pas créer un nouveau clone à chaque
  /// relecture : l'UID (4 premiers octets du bloc 0 MIFARE Classic) s'il a
  /// été lu, sinon le contenu complet des blocs.
  String get dedupKey {
    String hex(Iterable<int> bytes) =>
        bytes.map((b) => (b & 0xFF).toRadixString(16).padLeft(2, '0')).join();

    final block0 = rawBlocks[0];
    if (block0 != null && block0.length >= 4 && block0.take(4).any((b) => b != 0)) {
      return 'uid:${hex(block0.take(4))}';
    }
    final blocks = rawBlocks.keys.toList()..sort();
    return 'content:${blocks.map((b) => '$b=${hex(rawBlocks[b]!)}').join(';')}';
  }

  /// Obtenir une description lisible du clone
  String get displayName {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    return '${bobbinData.brand ?? "Bambu Lab"} ${bobbinData.filamentType} ${bobbinData.color}';
  }
}
