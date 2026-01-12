class NfcConstants {
  static const int nfcSessionTimeoutMs = 60000; // 60 secondes
  static const int maxRetryAttempts = 3;
  static const String ndefFormatType = 'NDEF';

  // Anycubic specific
  static const String anycubicManufacturerId = 'ANYCUBIC';
  static const List<String> supportedFilamentTypes = [
    'PLA',
    'ABS',
    'PETG',
    'TPU',
    'Nylon',
  ];
}
