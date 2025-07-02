part of 'address_cubit.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressCreatedSuccessfully extends AddressState {
  final AddressModel address;

  const AddressCreatedSuccessfully(this.address);

  @override
  List<Object?> get props => [address];
}

class AddressListLoaded extends AddressState {
  final List<AddressModel> addresses;

  const AddressListLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
