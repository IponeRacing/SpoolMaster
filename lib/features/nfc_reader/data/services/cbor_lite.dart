/// Décodeur CBOR minimal (RFC 8949) pour OpenPrintTag.
/// Supporte : uint, negint, byte string, text string, array, map,
/// tags (ignorés), half/float32/float64, bool/null, longueurs définies et
/// indéfinies. La spec OpenPrintTag recommande (« SHOULD ») une map racine de
/// longueur indéfinie (0xBF … 0xFF) : c'est le cas des vrais tags Prusament,
/// que l'ancienne version (longueurs définies seulement) ne savait pas lire.
library;

import 'dart:convert';

class CborLite {
  /// Décode la première valeur CBOR de [bytes] à partir de [offset].
  /// Retourne (valeur, prochain offset). Lance [FormatException] si invalide.
  static (dynamic, int) decode(List<int> bytes, [int offset = 0]) {
    if (offset >= bytes.length) {
      throw const FormatException('CBOR: fin de données inattendue');
    }

    final initial = bytes[offset];
    final majorType = initial >> 5;
    final additionalInfo = initial & 0x1F;
    var cursor = offset + 1;

    if (additionalInfo == 31) return _decodeIndefinite(bytes, majorType, cursor);

    // Longueur/valeur selon additional info
    int argument;
    switch (additionalInfo) {
      case < 24:
        argument = additionalInfo;
      case 24:
        argument = _readUint(bytes, cursor, 1);
        cursor += 1;
      case 25:
        argument = _readUint(bytes, cursor, 2);
        cursor += 2;
      case 26:
        argument = _readUint(bytes, cursor, 4);
        cursor += 4;
      case 27:
        argument = _readUint(bytes, cursor, 8);
        cursor += 8;
      default:
        throw FormatException('CBOR: additional info $additionalInfo réservé');
    }

    switch (majorType) {
      case 0: // unsigned int
        return (argument, cursor);

      case 1: // negative int
        return (-1 - argument, cursor);

      case 2: // byte string
        _checkBounds(bytes, cursor, argument);
        return (bytes.sublist(cursor, cursor + argument), cursor + argument);

      case 3: // text string
        _checkBounds(bytes, cursor, argument);
        final str = utf8.decode(
          bytes.sublist(cursor, cursor + argument),
          allowMalformed: true,
        );
        return (str, cursor + argument);

      case 4: // array
        final list = <dynamic>[];
        for (var i = 0; i < argument; i++) {
          final (value, next) = decode(bytes, cursor);
          list.add(value);
          cursor = next;
        }
        return (list, cursor);

      case 5: // map
        final map = <dynamic, dynamic>{};
        for (var i = 0; i < argument; i++) {
          final (key, afterKey) = decode(bytes, cursor);
          final (value, afterValue) = decode(bytes, afterKey);
          map[key] = value;
          cursor = afterValue;
        }
        return (map, cursor);

      case 6: // tag — ignorer, décoder la valeur interne
        return decode(bytes, cursor);

      case 7: // simple / float
        switch (additionalInfo) {
          case 20:
            return (false, cursor);
          case 21:
            return (true, cursor);
          case 22 || 23:
            return (null, cursor);
          case 25:
            return (_decodeHalfFloat(argument), cursor);
          case 26:
            return (_decodeFloat32(argument), cursor);
          case 27:
            return (_decodeFloat64(argument), cursor);
          default:
            return (argument, cursor); // simple value
        }

      default:
        throw FormatException('CBOR: major type $majorType invalide');
    }
  }

  /// Valeur de longueur indéfinie (additional info 31), terminée par 0xFF.
  static (dynamic, int) _decodeIndefinite(List<int> bytes, int majorType, int start) {
    var cursor = start;
    bool atBreak() {
      if (cursor >= bytes.length) {
        throw const FormatException('CBOR: fin de données avant 0xFF');
      }
      return bytes[cursor] == _break;
    }

    switch (majorType) {
      case 2 || 3: // chaîne découpée en morceaux de longueur définie
        final chunks = <int>[];
        while (!atBreak()) {
          if (bytes[cursor] >> 5 != majorType || bytes[cursor] & 0x1F == 31) {
            throw const FormatException('CBOR: morceau de chaîne invalide');
          }
          final (chunk, next) = decode(bytes, cursor);
          chunks.addAll(chunk is String ? utf8.encode(chunk) : chunk as List<int>);
          cursor = next;
        }
        final value = majorType == 2 ? chunks : utf8.decode(chunks, allowMalformed: true);
        return (value, cursor + 1);

      case 4: // array
        final list = <dynamic>[];
        while (!atBreak()) {
          final (value, next) = decode(bytes, cursor);
          list.add(value);
          cursor = next;
        }
        return (list, cursor + 1);

      case 5: // map
        final map = <dynamic, dynamic>{};
        while (!atBreak()) {
          final (key, afterKey) = decode(bytes, cursor);
          final (value, afterValue) = decode(bytes, afterKey);
          map[key] = value;
          cursor = afterValue;
        }
        return (map, cursor + 1);

      default: // 0xFF hors conteneur, ou entier/tag « indéfini »
        throw FormatException('CBOR: longueur indéfinie invalide (major type $majorType)');
    }
  }

  static const int _break = 0xFF;

  static int _readUint(List<int> bytes, int offset, int length) {
    _checkBounds(bytes, offset, length);
    var value = 0;
    for (var i = 0; i < length; i++) {
      value = (value << 8) | bytes[offset + i];
    }
    return value;
  }

  static void _checkBounds(List<int> bytes, int offset, int length) {
    // length < 0 : une longueur 64 bits >= 2^63 devient négative en Dart et
    // contournerait le check d'addition — rejeter explicitement
    if (length < 0 || offset < 0 || offset + length > bytes.length) {
      throw const FormatException('CBOR: dépassement de buffer');
    }
  }

  /// IEEE 754 half-precision (16 bits) — utilisé pour density etc.
  static double _decodeHalfFloat(int h) {
    final sign = (h >> 15) & 0x1;
    final exp = (h >> 10) & 0x1F;
    final frac = h & 0x3FF;

    double value;
    if (exp == 0) {
      value = frac * 5.9604644775390625e-8; // subnormal: 2^-24
    } else if (exp == 0x1F) {
      value = frac == 0 ? double.infinity : double.nan;
    } else {
      value = (frac / 1024.0 + 1.0) * _pow2(exp - 15);
    }
    return sign == 1 ? -value : value;
  }

  static double _pow2(int e) {
    var v = 1.0;
    if (e >= 0) {
      for (var i = 0; i < e; i++) {
        v *= 2;
      }
    } else {
      for (var i = 0; i < -e; i++) {
        v /= 2;
      }
    }
    return v;
  }

  static double _decodeFloat32(int bits) {
    final sign = (bits >> 31) & 0x1;
    final exp = (bits >> 23) & 0xFF;
    final frac = bits & 0x7FFFFF;

    double value;
    if (exp == 0) {
      value = frac * _pow2(-149);
    } else if (exp == 0xFF) {
      value = frac == 0 ? double.infinity : double.nan;
    } else {
      value = (frac / 8388608.0 + 1.0) * _pow2(exp - 127);
    }
    return sign == 1 ? -value : value;
  }

  static double _decodeFloat64(int bits) {
    final sign = (bits >> 63) & 0x1;
    final exp = (bits >> 52) & 0x7FF;
    final frac = bits & 0xFFFFFFFFFFFFF;

    double value;
    if (exp == 0) {
      value = frac * _pow2(-1074);
    } else if (exp == 0x7FF) {
      value = frac == 0 ? double.infinity : double.nan;
    } else {
      value = (frac / 4503599627370496.0 + 1.0) * _pow2(exp - 1023);
    }
    return sign == 1 ? -value : value;
  }
}
