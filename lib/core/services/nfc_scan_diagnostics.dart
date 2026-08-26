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

  /// À appeler au démarrage d'un scan.
  static void reset() {
    readAttempts = null;
    tagTech = null;
    sessionRetries = null;
    detectDelayMs = null;
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
    final dd = result['detect_delay_ms'];
    if (dd is int && dd >= 0) detectDelayMs = dd;
  }
}
