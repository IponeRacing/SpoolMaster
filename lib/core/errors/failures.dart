import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// NFC Failures
class NfcNotAvailableFailure extends Failure {
  const NfcNotAvailableFailure([
    super.message = 'NFC non disponible sur cet appareil',
  ]);
}

class NfcTagReadFailure extends Failure {
  const NfcTagReadFailure([
    super.message = 'Erreur lors de la lecture de la puce NFC',
    this.rawTagData,
    this.rawBytesCount = 0,
  ]);

  final String? rawTagData;
  final int rawBytesCount;

  @override
  List<Object?> get props => [message, rawTagData, rawBytesCount];
}

class NfcTagWriteFailure extends Failure {
  const NfcTagWriteFailure([
    super.message = "Erreur lors de l'écriture sur la puce NFC",
  ]);
}

class NfcPermissionDeniedFailure extends Failure {
  const NfcPermissionDeniedFailure([
    super.message = 'Permissions NFC refusées',
  ]);
}

class NfcSessionCancelledFailure extends Failure {
  const NfcSessionCancelledFailure([super.message = 'Scan NFC annulé']);
}

class NfcTagNotDetectedFailure extends Failure {
  const NfcTagNotDetectedFailure([
    super.message = 'Aucun tag NFC détecté',
  ]);
}

class NfcTagIncompatibleFailure extends Failure {
  const NfcTagIncompatibleFailure([
    super.message = 'Tag NFC incompatible détecté',
    this.tagType,
  ]);

  final String? tagType;

  @override
  List<Object?> get props => [message, tagType];
}

// Generic Failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de cache']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erreur serveur']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Erreur inconnue']);
}
