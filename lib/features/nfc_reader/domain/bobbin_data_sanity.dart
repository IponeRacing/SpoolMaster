import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Résultat du contrôle de plausibilité d'une lecture de tag.
class BobbinSanityResult {
  const BobbinSanityResult(this.data, this.droppedFields, {required this.garbled});

  /// Données lues, valeurs hors bornes remplacées par null (ou le défaut).
  final BobbinData data;

  /// Champs écartés car hors bornes (vide si tout est plausible).
  final List<String> droppedFields;

  /// Texte illisible (fragments de JSON…) dans le matériau ou la marque :
  /// le tag a été décodé avec le mauvais format.
  final bool garbled;
}

/// Bornes de plausibilité appliquées à TOUTE lecture de tag, quel que soit le
/// décodeur. En prod (09-10.2026), des formats mal reconnus donnaient une buse
/// à 25 449 °C, un plateau à 16 352 °C ou un matériau « ,"max_temp":230, ».
/// Une valeur hors bornes devient vide plutôt que fausse.
BobbinSanityResult checkBobbinData(BobbinData d) {
  final dropped = <String>[];

  int? range(String field, int? v, int min, int max) {
    if (v == null) return null;
    if (v >= min && v <= max) return v;
    dropped.add(field);
    return null;
  }

  double? rangeD(String field, double? v, double min, double max) {
    if (v == null) return null;
    if (v >= min && v <= max) return v;
    dropped.add(field);
    return null;
  }

  var extruderMin = range('extruder_temp_min', d.extruderTempMin, 150, 450);
  var extruderMax = range('extruder_temp_max', d.extruderTempMax, 150, 450);
  if (extruderMin != null && extruderMax != null && extruderMin > extruderMax) {
    final t = extruderMin;
    extruderMin = extruderMax;
    extruderMax = t;
  }
  // Plateau : 0 = non renseigné (plateau froid ou champ vide), pas une valeur.
  final bedMin = range('bed_temp_min', d.bedTempMin == 0 ? null : d.bedTempMin, 1, 150);
  final bedMax = range('bed_temp_max', d.bedTempMax == 0 ? null : d.bedTempMax, 1, 150);

  var weight = d.weightGrams;
  if (weight < 50 || weight > 10000) {
    dropped.add('weight');
    weight = 1000;
  }
  var remaining = d.remainingWeight;
  if (remaining != null && (remaining < 0 || remaining > weight)) {
    dropped.add('remaining_weight');
    remaining = weight;
  }

  final now = DateTime.now();
  var date = d.manufactureDate;
  if (date != null && (date.year < 2015 || date.isAfter(now.add(const Duration(days: 366))))) {
    dropped.add('manufacture_date');
    date = null;
  }

  final data = BobbinData(
    filamentType: d.filamentType,
    color: d.color,
    weightGrams: weight,
    manufactureDate: date,
    batchNumber: d.batchNumber,
    colorRgb: d.colorRgb,
    extruderTempMin: extruderMin,
    extruderTempMax: extruderMax,
    bedTempMin: bedMin,
    bedTempMax: bedMax,
    diameter: rangeD('diameter', d.diameter == 0 ? null : d.diameter, 1, 3.5),
    spoolLength: range('spool_length', d.spoolLength == 0 ? null : d.spoolLength, 1, 5000),
    price: d.price,
    remainingWeight: remaining,
    brand: d.brand,
    detailedType: d.detailedType,
    dryingTemp: range('drying_temp', d.dryingTemp, 30, 150),
    dryingTime: range('drying_time', d.dryingTime, 1, 72),
    materialVariantId: d.materialVariantId,
    materialId: d.materialId,
    nozzleSize: rangeD('nozzle_size', d.nozzleSize, 0.1, 2),
    vendorCode: d.vendorCode,
    productCode: d.productCode,
  );

  final garbled = [d.filamentType, d.brand ?? '', d.detailedType ?? ''].any(isGarbledTagText);
  return BobbinSanityResult(data, dropped, garbled: garbled);
}

/// Texte de tag illisible : des caractères de structure (JSON, séparateurs)
/// n'apparaissent jamais dans un nom de matériau ou de marque.
bool isGarbledTagText(String s) => RegExp(r'["{}\[\]|\\]|":').hasMatch(s);
