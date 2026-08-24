import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
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
  const NfcTagReadFailure({
    String message = 'Erreur lors de la lecture de la puce NFC',
    this.rawTagData,
    this.rawBytesCount = 0,
    this.sessionDurationMs,
    this.tagWasDetected,
  }) : super(message);

  final String? rawTagData;
  final int rawBytesCount;
  final int? sessionDurationMs;
  final bool? tagWasDetected;

  @override
  List<Object?> get props => [message, rawTagData, rawBytesCount, sessionDurationMs, tagWasDetected];
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

class NfcAuthFailure extends Failure {
  const NfcAuthFailure({
    String message = 'Authentification tag NFC échouée',
    this.sessionDurationMs,
    this.tagWasDetected,
  }) : super(message);

  final int? sessionDurationMs;
  final bool? tagWasDetected;

  @override
  List<Object?> get props => [message, sessionDurationMs, tagWasDetected];
}

class NfcTagNotDetectedFailure extends Failure {
  const NfcTagNotDetectedFailure({
    String message = 'Aucun tag NFC détecté',
    this.sessionDurationMs,
    this.tagWasDetected,
  }) : super(message);

  final int? sessionDurationMs;
  final bool? tagWasDetected;

  @override
  List<Object?> get props => [message, sessionDurationMs, tagWasDetected];
}

class NfcTagIncompatibleFailure extends Failure {
  const NfcTagIncompatibleFailure({
    String message = 'Tag NFC incompatible détecté',
    this.tagType,
    this.sessionDurationMs,
    this.tagWasDetected,
  }) : super(message);

  final String? tagType;
  final int? sessionDurationMs;
  final bool? tagWasDetected;

  @override
  List<Object?> get props => [message, tagType, sessionDurationMs, tagWasDetected];
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
