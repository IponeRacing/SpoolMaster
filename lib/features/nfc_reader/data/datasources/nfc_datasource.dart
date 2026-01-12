import 'package:nfc_filament/features/nfc_reader/data/models/bobbin_data_model.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/nfc_tag_model.dart';

abstract class NfcDataSource {
  /// Check if NFC is available on this device
  Future<bool> isNfcAvailable();

  /// Read an NFC tag and return its data
  Future<NfcTagModel> readNfcTag();

  /// Read bobbin data from NFC tag
  Future<BobbinDataModel> readBobbinData();

  /// Write bobbin data to NFC tag
  Future<void> writeBobbinData(BobbinDataModel data);
}
