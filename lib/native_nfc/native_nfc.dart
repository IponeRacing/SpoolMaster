import 'dart:typed_data';
import 'package:flutter/services.dart';

class NativeNfc {
  static const MethodChannel _channel = MethodChannel('com.anycubic.nfc/native');

  /// Lit des pages MiFare Ultralight
  static Future<Uint8List> readMiFarePages(int startPage, int pageCount) async {
    final result = await _channel.invokeMethod('readMiFarePages', {
      'startPage': startPage,
      'pageCount': pageCount,
    });
    return result as Uint8List;
  }

  /// Écrit une page MiFare Ultralight (4 bytes)
  static Future<void> writeMiFarePage(int page, Uint8List data) async {
    if (data.length != 4) {
      throw ArgumentError('Data must be exactly 4 bytes');
    }
    await _channel.invokeMethod('writeMiFarePage', {
      'page': page,
      'data': data,
    });
  }

  /// Démarre une session de lecture NFC
  static Future<Map<String, dynamic>> startReadSession() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>>('startReadSession');
    return Map<String, dynamic>.from(result ?? {});
  }

  /// Démarre une session d'écriture NFC
  static Future<void> startWriteSession(List<Map<String, dynamic>> pages) async {
    await _channel.invokeMethod('startWriteSession', {'pages': pages});
  }

  /// Auto-détecte le type de tag NFC et le lit (Anycubic/Bambu/Prusa)
  static Future<Map<String, dynamic>> startAutoDetectReadSession() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>>('startAutoDetectReadSession');
    return Map<String, dynamic>.from(result ?? {});
  }

  /// Lit un tag OpenPrintTag ISO 15693 (Prusa)
  static Future<Map<String, dynamic>> readOpenPrintTag() async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>>('readOpenPrintTag');
    return Map<String, dynamic>.from(result ?? {});
  }

  /// Écrit un tag OpenPrintTag ISO 15693 (Prusa)
  static Future<void> writeOpenPrintTag(List<int> data) async {
    await _channel.invokeMethod('writeOpenPrintTag', {'data': data});
  }

  /// Vérifie si NFC est disponible sur l'appareil (via plugin natif, bypass nfc_manager)
  static Future<bool> checkNfcAvailability() async {
    final result = await _channel.invokeMethod<bool>('checkNfcAvailability');
    return result ?? false;
  }

  /// Arrête la session NFC en cours
  static Future<void> stopSession() async {
    await _channel.invokeMethod('stopSession');
  }
}
