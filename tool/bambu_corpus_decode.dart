// Décode des lectures Bambu Lab avec le VRAI code de l'app (BambuTagParser puis
// checkBobbinData, comme NfcRepositoryImpl). Appelé par tool/bambu_corpus_check.py.
//
// Entrée : JSONL {"path", "rawBlocks": {"block_N": [16 octets]}} (ce que le
// natif Android renvoie). Sortie : JSONL des champs décodés.
//
// Usage : dart run tool/bambu_corpus_decode.dart <entrée.jsonl> <sortie.jsonl>
import 'dart:convert';
import 'dart:io';

import 'package:nfc_filament/core/utils/bambu_color_lookup.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/bambu_tag_parser.dart';
import 'package:nfc_filament/features/nfc_reader/domain/bobbin_data_sanity.dart';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Usage : dart run tool/bambu_corpus_decode.dart <entrée.jsonl> <sortie.jsonl>');
    exit(64);
  }
  final out = File(args[1]).openWrite();
  for (final line in File(args[0]).readAsLinesSync()) {
    final rec = jsonDecode(line) as Map<String, dynamic>;
    final res = <String, dynamic>{'path': rec['path']};
    try {
      final parsed = BambuTagParser.parse(BambuTagParser.blocksFromNative(rec['rawBlocks']));
      if (parsed == null) {
        res['status'] = 'PARSE_NULL';
      } else {
        final checked = checkBobbinData(parsed);
        final d = checked.data;
        res.addAll({
          'status': checked.garbled ? 'GARBLED' : 'OK',
          'dropped': checked.droppedFields,
          'material': d.filamentType,
          'color': d.color,
          'catalogColor': bambuCatalogColor(d.materialId, d.materialVariantId)?.name,
          'colorRgb': d.colorRgb,
          'weight': d.weightGrams,
          'diameter': d.diameter,
          'length': d.spoolLength,
          'eMin': d.extruderTempMin,
          'eMax': d.extruderTempMax,
          'bed': d.bedTempMin,
          'dryT': d.dryingTemp,
          'dryH': d.dryingTime,
          'nozzle': d.nozzleSize,
          'date': d.manufactureDate?.toIso8601String(),
        });
      }
    } on Object catch (e) {
      res['status'] = 'EXCEPTION';
      res['error'] = '$e';
    }
    out.writeln(jsonEncode(res));
  }
  out.close();
}
