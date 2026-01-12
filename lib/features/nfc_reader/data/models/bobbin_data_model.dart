import 'package:json_annotation/json_annotation.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

part 'bobbin_data_model.g.dart';

@JsonSerializable()
class BobbinDataModel {
  final String filamentType;
  final String color;
  final double weightGrams;
  final DateTime? manufactureDate;
  final String? batchNumber;
  final int? colorRgb;
  final int? extruderTempMin;
  final int? extruderTempMax;
  final int? bedTempMin;
  final int? bedTempMax;
  final double? diameter;
  final int? spoolLength;
  final double? remainingWeight;
  final String? brand;

  BobbinDataModel({
    required this.filamentType,
    required this.color,
    required this.weightGrams,
    this.manufactureDate,
    this.batchNumber,
    this.colorRgb,
    this.extruderTempMin,
    this.extruderTempMax,
    this.bedTempMin,
    this.bedTempMax,
    this.diameter,
    this.spoolLength,
    this.remainingWeight,
    this.brand,
  });

  factory BobbinDataModel.fromJson(Map<String, dynamic> json) =>
      _$BobbinDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$BobbinDataModelToJson(this);

  BobbinData toEntity() => BobbinData(
    filamentType: filamentType,
    color: color,
    weightGrams: weightGrams,
    manufactureDate: manufactureDate,
    batchNumber: batchNumber,
    colorRgb: colorRgb,
    extruderTempMin: extruderTempMin,
    extruderTempMax: extruderTempMax,
    bedTempMin: bedTempMin,
    bedTempMax: bedTempMax,
    diameter: diameter,
    spoolLength: spoolLength,
    remainingWeight: remainingWeight,
    brand: brand,
  );

  factory BobbinDataModel.fromEntity(BobbinData entity) => BobbinDataModel(
    filamentType: entity.filamentType,
    color: entity.color,
    weightGrams: entity.weightGrams,
    manufactureDate: entity.manufactureDate,
    batchNumber: entity.batchNumber,
    colorRgb: entity.colorRgb,
    extruderTempMin: entity.extruderTempMin,
    extruderTempMax: entity.extruderTempMax,
    bedTempMin: entity.bedTempMin,
    bedTempMax: entity.bedTempMax,
    diameter: entity.diameter,
    spoolLength: entity.spoolLength,
    remainingWeight: entity.remainingWeight,
    brand: entity.brand,
  );
}
