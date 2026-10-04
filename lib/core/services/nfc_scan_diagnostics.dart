/// Diagnostics du dernier scan NFC, renseignés par la couche datasource depuis
/// le résultat natif, puis lus par le bloc au moment du logging analytics.
///
/// Découple la télémétrie (retries, techno du tag) du flux de données métier :
/// pas besoin de la faire transiter par tous les modèles.
class NfcScanDiagnostics {
  NfcScanDiagnostics._();

  /// Nombre de passes de lecture ayant réussi (1 = du premier coup ; >1 = un
  /// retry a sauvé le scan). 0 = inconnu/non applicable.
  static int? readAttempts;

  /// Technologie(s) du tag détecté (ex: "MifareUltralight,NfcA", "NfcV").
  static String? tagTech;

  /// Nombre de relances de session iOS sur code 202.
  static int? sessionRetries;

  /// Délai entre le début de session et la détection du tag (ms) — perf.
  static int? detectDelayMs;

  /// Code d'erreur natif brut (EMPTY_READ, CONNECTION_ERROR…) : plus précis
  /// que la taxonomie error_code, où READ_ERROR regroupe plusieurs causes.
  static String? nativeErrorCode;

  /// Précision sur un échec de parsing. BLANK_TAG = NTAG vierge (aucune
  /// donnée de bobine) → distingue « tag vide » d'un vrai bug de lecture.
  static String? errorDetail;

  /// Octets bruts du dernier tag lu (hex), envoyés seulement quand la lecture
  /// est suspecte ([wantsRawDump]) : sert à corriger le décodage d'un format.
  static String? lastRawHex;

  /// Champs écartés par le contrôle de plausibilité (ex. « extruder_temp_min »).
  static String? outOfRange;

  /// Lecture suspecte : valeur hors bornes ou format non reconnu → l'événement
  /// de scan embarque les octets bruts du tag (données de filament seulement).
  static bool get wantsRawDump =>
      outOfRange != null || errorDetail == unrecognizedFormat;

  /// [errorDetail] d'un tag NDEF ou d'un texte que l'app ne sait pas décoder.
  static const String unrecognizedFormat = 'UNRECOGNIZED_FORMAT';

  /// À appeler au démarrage d'un scan.
  static void reset() {
    readAttempts = null;
    tagTech = null;
    sessionRetries = null;
    detectDelayMs = null;
    nativeErrorCode = null;
    errorDetail = null;
    lastRawHex = null;
    outOfRange = null;
  }

  /// Vrai si la zone utilisateur (à partir de la page 4) est vierge : tout à
  /// 0x00, ou message NDEF vide (TLV 03 00), éventuellement précédé de TLV
  /// Lock/Memory Control. Faux si on ne peut pas conclure.
  static bool looksBlank(List<int> rawBytes) {
    if (rawBytes.length <= 16) return false;
    final body = rawBytes.sublist(16);
    if (body.every((b) => b == 0)) return true;
    var i = 0;
    while (i < body.length) {
      final t = body[i];
      if (t == 0x00) {
        i++;
        continue;
      }
      if (i + 1 >= body.length) return false;
      final len = body[i + 1];
      if (t == 0x01 || t == 0x02) {
        i += 2 + len;
        continue;
      }
      return t == 0x03 && len == 0;
    }
    return false;
  }

  /// Renseigne depuis la map de résultat natif (clés read_attempts / tag_tech /
  /// session_retries). Ignore silencieusement les clés absentes.
  static void updateFromNative(Map<dynamic, dynamic>? result) {
    if (result == null) return;
    final ra = result['read_attempts'];
    if (ra is int) readAttempts = ra;
    final tt = result['tag_tech'];
    if (tt is String && tt.isNotEmpty) tagTech = tt;
    final sr = result['session_retries'];
    if (sr is int) sessionRetries = sr;
    final dd = result['detect_delay_ms'] ?? result['tag_detect_delay_ms'];
    if (dd is int && dd >= 0) detectDelayMs = dd;
    final raw = result['rawBytes'];
    if (raw is List && raw.isNotEmpty) {
      lastRawHex = raw
          .take(1024)
          .map((b) => ((b as num).toInt() & 0xFF).toRadixString(16).padLeft(2, '0'))
          .join();
    }
  }

  /// Renseigne depuis une erreur native (PlatformException) : code brut +
  /// diagnostics joints (le natif les envoie aussi en cas d'échec).
  static void updateFromNativeError(String code, Object? details) {
    nativeErrorCode = code;
    if (details is Map) updateFromNative(details);
  }
}
