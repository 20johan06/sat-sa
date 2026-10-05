abstract class Failure {
  final String message;
  final String code;

  const Failure({required this.message, required this.code});

  @override
  String toString() => '[$code] $message';
}

class CryptographicFailure extends Failure {
  const CryptographicFailure(String message)
      : super(message: message, code: 'AEAD_AUTHENTICATION_FAILED');
}

class InvalidPackageFailure extends Failure {
  const InvalidPackageFailure(String message, [String code = 'INVALID_PACKAGE_FORMAT'])
      : super(message: message, code: code);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message)
      : super(message: message, code: 'DATABASE_ERROR');
}

class PlaintextProhibitedFailure extends Failure {
  const PlaintextProhibitedFailure()
      : super(
          message: 'Security violation: Unencrypted plaintext payload detected in package archive.',
          code: 'PLAINTEXT_PAYLOAD_REJECTED',
        );
}
