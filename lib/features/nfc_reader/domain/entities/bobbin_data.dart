class BobbinData {
  const BobbinData({
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
    this.price,
    this.remainingWeight,
    this.brand,
    this.detailedType,
    this.dryingTemp,
    this.dryingTime,
    this.materialVariantId,
    this.materialId,
    this.nozzleSize,
    this.vendorCode,
    this.productCode,
  });

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
  final double? price;
  final double? remainingWeight;
  final String? brand;
  final String? detailedType;
  final int? dryingTemp;
  final int? dryingTime;
  final String? materialVariantId;
  final String? materialId;
  final double? nozzleSize;
  final String? vendorCode;
  final String? productCode;
}
