part of 'receiver_cubit.dart';

abstract class ReceiverState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceiverInitial extends ReceiverState {}

class ReceiverLoading extends ReceiverState {}

class ReceiverLoaded extends ReceiverState {
  final ReceiverModel receiver;
  ReceiverLoaded(this.receiver);

  @override
  List<Object?> get props => [receiver];
}

class ReceiverError extends ReceiverState {
  final String message;
  ReceiverError(this.message);

  @override
  List<Object?> get props => [message];
}
