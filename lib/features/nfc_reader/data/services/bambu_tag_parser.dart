import 'dart:math' as math;
import 'dart:typed_data';

import 'package:nfc_filament/core/constants/bambu_colors.g.dart';
import 'package:nfc_filament/core/utils/bambu_color_lookup.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Décodage d'un tag RFID Bambu Lab (MIFARE Classic 1K) depuis ses blocs bruts.
///
/// Format : Bambu-Research-Group/RFID-Tag-Guide (BambuLabRfid.md), validé le
/// 04.10.2026 sur les 5959 dumps réels de Bambu-Lab-RFID-Library
/// (`tool/bambu_corpus_check.py`).
/// - bloc 1 : variante (0-7, ex. « A00-W1 ») + identifiant filament (8-15, « GFA00 »)
/// - bloc 2 : type (« PLA ») ; bloc 4 : type détaillé (« PLA Basic »)
/// - bloc 5 : couleur RGBA (0-3, alpha 0 = transparent), poids en g (4-5),
///   diamètre float (8-11)
/// - bloc 6 : séchage °C (0-1) et h (2-3), plateau °C (6-7), buse max (8-9) / min (10-11)
/// - bloc 8 : diamètre de buse float (12-15) ; bloc 12 : date « AAAA_MM_JJ_hh_mm »
/// - bloc 14 : longueur en m (4-5). Entiers et flottants en little-endian.
///
/// Avant (jusqu'à la 1.4.10+88), le natif lisait le bloc 5 comme matériau et
/// températures, et le bloc 6 comme couleur : matériau, couleur, températures
/// et poids faux sur toute lecture Bambu.
class BambuTagParser {
  BambuTagParser._();

  /// Blocs bruts du natif (`rawBlocks` : « block_5 » → 16 octets).
  static Map<int, List<int>> blocksFromNative(Object? raw) {
    final blocks = <int, List<int>>{};
    if (raw is! Map) return blocks;
    for (final entry in raw.entries) {
      final index = int.tryParse(entry.key.toString().replaceAll('block_', ''));
      final value = entry.value;
      if (index == null || value is! List) continue;
      blocks[index] = value.map((b) => (b as num).toInt() & 0xFF).toList();
    }
    return blocks;
  }

  /// Identifiant de filament Bambu (bloc 1, octets 8-15) : « GFA00 », « GFG02 »…
  /// Vrai sur les 5959 tags de Bambu-Lab-RFID-Library.
  static final RegExp _bambuMaterialId = RegExp(r'^GF[A-Z]\d{2}$');

  /// Le tag est-il un tag Bambu Lab ? Un MIFARE Classic d'une autre marque
  /// ouvert avec les clés par défaut (Qidi Box, Creality lu en mode Bambu)
  /// devenait une fausse bobine « Bambu Lab » au matériau illisible.
  static bool isBambuTag(Map<int, List<int>> blocks) {
    final b1 = _block(blocks, 1);
    return b1 != null && _bambuMaterialId.hasMatch(_ascii(b1.sublist(8, 16)));
  }

  /// Données de la bobine, ou null sans bloc 5 (couleur, poids, diamètre) ou
  /// si ce n'est pas un tag Bambu Lab ([isBambuTag]).
  static BobbinData? parse(Map<int, List<int>> blocks) {
    final b5 = _block(blocks, 5);
    if (b5 == null || !isBambuTag(blocks)) return null;
    final b1 = _block(blocks, 1);
    final b6 = _block(blocks, 6);
    final b8 = _block(blocks, 8);
    final b12 = _block(blocks, 12);
    final b14 = _block(blocks, 14);

    final variantId = b1 == null ? '' : _ascii(b1.sublist(0, 8));
    final materialId = b1 == null ? '' : _ascii(b1.sublist(8, 16));
    final type = _ascii(_block(blocks, 2) ?? const []);
    final detailedType = _ascii(_block(blocks, 4) ?? const []);
    // Bloc 4 en principe plus précis (« PLA Basic » / « PLA »), mais certains
    // tags ABS-GF portent « ABS-GF » au bloc 2 et « ABS » au bloc 4.
    final filamentType = detailedType.isEmpty
        ? (type.isNotEmpty ? type : 'PLA')
        : (type.length > detailedType.length && type.startsWith(detailedType)
            ? type
            : detailedType);

    final colorRgb = (b5[0] << 16) | (b5[1] << 8) | b5[2];
    final transparent = b5[3] == 0;
    final weight = _u16(b5, 4);
    final weightGrams = weight > 0 ? weight.toDouble() : 1000.0;
    final diameter = _f32(b5, 8);
    final nozzle = b8 == null ? null : _f32(b8, 12);
    final length = b14 == null ? 0 : _u16(b14, 4);

    return BobbinData(
      filamentType: filamentType,
      color: colorName(
        rgb: colorRgb,
        materialId: materialId,
        variantId: variantId,
        filamentType: filamentType,
        transparent: transparent,
      ),
      colorRgb: transparent ? kClearFilamentRgb : colorRgb,
      weightGrams: weightGrams,
      remainingWeight: weightGrams,
      diameter: _inRange(diameter, 1, 3.5) ? _round2(diameter!) : 1.75,
      extruderTempMin: _temp(b6, 10, 150, 450),
      extruderTempMax: _temp(b6, 8, 150, 450),
      bedTempMin: _temp(b6, 6, 20, 150),
      bedTempMax: _temp(b6, 6, 20, 150),
      dryingTemp: _temp(b6, 0, 30, 150),
      dryingTime: _temp(b6, 2, 1, 72),
      spoolLength: length > 0 ? length : null,
      manufactureDate: b12 == null ? null : _date(_ascii(b12)),
      brand: 'Bambu Lab',
      detailedType: detailedType.isEmpty ? null : filamentType,
      materialVariantId: variantId.isEmpty ? null : variantId,
      materialId: materialId.isEmpty ? null : materialId,
      nozzleSize: _inRange(nozzle, 0.1, 2) ? _round2(nozzle!) : null,
    );
  }

  /// Nom de la couleur : nom officiel Bambu par code couleur (variante du
  /// tag), sinon « Transparent » pour un tag transparent (RGB noir sans
  /// signification), sinon couleur officielle la plus proche (écart
  /// perceptuel ΔE ≤ 15) du même filament, du même type, puis de tout le
  /// catalogue ; sinon nom générique (« Green »…) plutôt qu'un nom officiel faux.
  static String colorName({
    required int rgb,
    String materialId = '',
    String variantId = '',
    String filamentType = '',
    bool transparent = false,
  }) {
    final official = bambuCatalogColor(materialId, variantId);
    if (official != null) return official.name;
    if (transparent) return 'Transparent';

    final type = filamentType.toLowerCase();
    final pools = [
      if (materialId.isNotEmpty) bambuColors.where((c) => c.filaId == materialId),
      if (type.isNotEmpty) bambuColors.where((c) => c.type.toLowerCase() == type),
      bambuColors,
    ];
    final target = _lab(rgb);
    for (final pool in pools) {
      BambuColor? best;
      var bestScore = double.infinity;
      for (final c in pool) {
        var d = c.rgb.map((x) => _deltaE(_lab(x), target)).reduce(math.min);
        // À écart égal : couleur unie avant dégradé, puis nom le plus court
        // (« White » avant « Arctic Whisper »).
        if (c.rgb.length > 1) d += 0.5;
        d += c.name.length / 1000;
        if (d < bestScore) {
          bestScore = d;
          best = c;
        }
      }
      if (best != null && bestScore <= 15) return best.name;
    }
    return colorNameFromRgb((rgb >> 16) & 0xFF, (rgb >> 8) & 0xFF, rgb & 0xFF);
  }

  static List<int>? _block(Map<int, List<int>> blocks, int index) {
    final b = blocks[index];
    return b != null && b.length >= 16 ? b : null;
  }

  static String _ascii(List<int> bytes) {
    final end = bytes.indexOf(0);
    return String.fromCharCodes(
      (end >= 0 ? bytes.sublist(0, end) : bytes).where((b) => b >= 32 && b < 127),
    ).trim();
  }

  static int _u16(List<int> b, int offset) => b[offset] | (b[offset + 1] << 8);

  static double? _f32(List<int> b, int offset) {
    final v = ByteData.sublistView(Uint8List.fromList(b.sublist(offset, offset + 4)))
        .getFloat32(0, Endian.little);
    return v.isFinite ? v : null;
  }

  static int? _temp(List<int>? b, int offset, int min, int max) {
    if (b == null) return null;
    final v = _u16(b, offset);
    return v >= min && v <= max ? v : null;
  }

  static bool _inRange(double? v, double min, double max) =>
      v != null && v >= min && v <= max;

  static double _round2(double v) => (v * 100).round() / 100;

  /// « 2024_11_05_15_07 » → DateTime.
  static DateTime? _date(String s) {
    final m = RegExp(r'^(\d{4})_(\d{2})_(\d{2})(?:_(\d{2})_(\d{2}))?').firstMatch(s);
    if (m == null) return null;
    final year = int.parse(m.group(1)!);
    final month = int.parse(m.group(2)!);
    final day = int.parse(m.group(3)!);
    if (year < 2015 || month < 1 || month > 12 || day < 1 || day > 31) return null;
    return DateTime(year, month, day, int.parse(m.group(4) ?? '0'), int.parse(m.group(5) ?? '0'));
  }

  // CIE L*a*b* (D65) et ΔE76 : distance perceptuelle entre deux couleurs.
  static List<double> _lab(int rgb) {
    double lin(int c) {
      final v = c / 255;
      return v > 0.04045 ? math.pow((v + 0.055) / 1.055, 2.4).toDouble() : v / 12.92;
    }

    final r = lin((rgb >> 16) & 0xFF);
    final g = lin((rgb >> 8) & 0xFF);
    final b = lin(rgb & 0xFF);
    double f(double t) => t > 0.008856 ? math.pow(t, 1 / 3).toDouble() : 7.787 * t + 16 / 116;
    final fx = f((r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047);
    final fy = f(r * 0.2126 + g * 0.7152 + b * 0.0722);
    final fz = f((r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883);
    return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
  }

  static double _deltaE(List<double> a, List<double> b) => math.sqrt(
        math.pow(a[0] - b[0], 2) + math.pow(a[1] - b[1], 2) + math.pow(a[2] - b[2], 2),
      );
}
