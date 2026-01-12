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
}
