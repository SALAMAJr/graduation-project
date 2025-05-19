abstract class Failure {}

class ServerFailure extends Failure {
  final String message;

  ServerFailure({required this.message});
}

class NetworkFailure extends Failure {
  final String message;

  NetworkFailure({required this.message});
}

class UnknownFailure extends Failure {
  final String message;

  UnknownFailure({required this.message});
}
