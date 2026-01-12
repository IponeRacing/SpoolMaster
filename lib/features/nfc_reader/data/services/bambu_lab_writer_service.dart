import 'package:flutter/services.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';

/// Service pour écrire des clones Bambu Lab sur cartes CUID
class BambuLabWriterService {
  static const MethodChannel _channel = MethodChannel('com.anycubic.nfc/native');

  /// Écrire un clone Bambu Lab sur une carte CUID vierge
  /// IMPORTANT: Nécessite une carte CUID (MiFare Classic 1K compatible)
  static Future<void> writeClonedTag(ClonedTagModel clone) async {
    try {
      // Convertir les blocs en format attendu par le plugin natif
      final Map<String, List<int>> blocks = {};
      for (final entry in clone.rawBlocks.entries) {
        blocks[entry.key.toString()] = entry.value;
      }

      // Appeler le plugin natif pour écrire
      await _channel.invokeMethod('writeBambuLabClone', {
        'blocks': blocks,
      });

      print('✅ Clone Bambu Lab écrit avec succès sur carte CUID');
    } on PlatformException catch (e) {
      throw Exception('Erreur écriture clone: ${e.message}');
    } catch (e) {
      throw Exception('Erreur lors de l\'écriture du clone: $e');
    }
  }
}
