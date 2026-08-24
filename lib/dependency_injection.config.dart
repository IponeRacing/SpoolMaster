// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource.dart'
    as _i154;
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource_impl.dart'
    as _i181;
import 'package:nfc_filament/features/nfc_reader/data/datasources/scan_history_local_datasource.dart'
    as _i1023;
import 'package:nfc_filament/features/nfc_reader/data/datasources/scan_history_local_datasource_impl.dart'
    as _i1024;
import 'package:nfc_filament/features/nfc_reader/data/repositories/nfc_repository_impl.dart'
    as _i474;
import 'package:nfc_filament/features/nfc_reader/data/repositories/scan_history_repository_impl.dart'
    as _i580;
import 'package:nfc_filament/features/nfc_reader/domain/repositories/nfc_repository.dart'
    as _i1053;
import 'package:nfc_filament/features/nfc_reader/domain/repositories/scan_history_repository.dart'
    as _i622;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/check_nfc_availability.dart'
    as _i323;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/clear_scan_history.dart'
    as _i682;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/delete_scan.dart'
    as _i2;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/get_scan_history.dart'
    as _i416;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_bobbin_data.dart'
    as _i313;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_bobbin_data_auto_detect.dart'
    as _i916;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_nfc_tag.dart'
    as _i221;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/save_scan_to_history.dart'
    as _i787;
import 'package:nfc_filament/features/nfc_reader/domain/usecases/write_bobbin_data.dart'
    as _i906;
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart'
    as _i396;
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/scan_history_bloc.dart'
    as _i780;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i154.NfcDataSource>(() => _i181.NfcDataSourceImpl());
    gh.lazySingleton<_i1053.NfcRepository>(
      () => _i474.NfcRepositoryImpl(gh<_i154.NfcDataSource>()),
    );
    gh.lazySingleton<_i1023.ScanHistoryLocalDataSource>(
      () =>
          _i1024.ScanHistoryLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i323.CheckNfcAvailability>(
      () => _i323.CheckNfcAvailability(gh<_i1053.NfcRepository>()),
    );
    gh.lazySingleton<_i313.ReadBobbinData>(
      () => _i313.ReadBobbinData(gh<_i1053.NfcRepository>()),
    );
    gh.lazySingleton<_i916.ReadBobbinDataAutoDetect>(
      () => _i916.ReadBobbinDataAutoDetect(gh<_i1053.NfcRepository>()),
    );
    gh.lazySingleton<_i221.ReadNfcTag>(
      () => _i221.ReadNfcTag(gh<_i1053.NfcRepository>()),
    );
    gh.factory<_i906.WriteBobbinData>(
      () => _i906.WriteBobbinData(gh<_i1053.NfcRepository>()),
    );
    gh.lazySingleton<_i622.ScanHistoryRepository>(
      () => _i580.ScanHistoryRepositoryImpl(
        gh<_i1023.ScanHistoryLocalDataSource>(),
      ),
    );
    gh.factory<_i682.ClearScanHistory>(
      () => _i682.ClearScanHistory(gh<_i622.ScanHistoryRepository>()),
    );
    gh.factory<_i2.DeleteScan>(
      () => _i2.DeleteScan(gh<_i622.ScanHistoryRepository>()),
    );
    gh.factory<_i416.GetScanHistory>(
      () => _i416.GetScanHistory(gh<_i622.ScanHistoryRepository>()),
    );
    gh.factory<_i787.SaveScanToHistory>(
      () => _i787.SaveScanToHistory(gh<_i622.ScanHistoryRepository>()),
    );
    gh.factory<_i396.NfcReaderBloc>(
      () => _i396.NfcReaderBloc(
        checkNfcAvailability: gh<_i323.CheckNfcAvailability>(),
        readNfcTag: gh<_i221.ReadNfcTag>(),
        readBobbinData: gh<_i313.ReadBobbinData>(),
        writeBobbinData: gh<_i906.WriteBobbinData>(),
        saveScanToHistory: gh<_i787.SaveScanToHistory>(),
        readBobbinDataAutoDetect: gh<_i916.ReadBobbinDataAutoDetect>(),
      ),
    );
    gh.factory<_i780.ScanHistoryBloc>(
      () => _i780.ScanHistoryBloc(
        getScanHistory: gh<_i416.GetScanHistory>(),
        saveScanToHistory: gh<_i787.SaveScanToHistory>(),
        deleteScan: gh<_i2.DeleteScan>(),
        clearScanHistory: gh<_i682.ClearScanHistory>(),
      ),
    );
    return this;
  }
}
