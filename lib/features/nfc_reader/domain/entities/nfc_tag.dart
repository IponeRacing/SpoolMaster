import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfc_tag.freezed.dart';

@freezed
class NfcTag with _$NfcTag {
  const factory NfcTag({
    required String id,
    required String type,
    String? manufacturer,
    Map<String, dynamic>? data,
  }) = _NfcTag;
}
