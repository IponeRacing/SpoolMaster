import 'package:freezed_annotation/freezed_annotation.dart';

part 'bobbin_data.freezed.dart';

@freezed
class BobbinData with _$BobbinData {
  const factory BobbinData({
    required String filamentType,
    required String color,
    required double weightGrams,
    DateTime? manufactureDate,
    String? batchNumber,
    int? colorRgb, // RGB color as integer (0xRRGGBB)
    int? extruderTempMin, // Température extrudeur min (°C)
    int? extruderTempMax, // Température extrudeur max (°C)
    int? bedTempMin, // Température plateau min (°C)
    int? bedTempMax, // Température plateau max (°C)
    double? diameter, // Diamètre filament (mm)
    int? spoolLength, // Longueur bobine (mètres)
    double? price, // Prix d'achat (CHF)
    double? remainingWeight, // Poids restant (grammes)
    String? brand, // Marque
  }) = _BobbinData;
}
