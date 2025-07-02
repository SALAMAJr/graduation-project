import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/adress/address_model.dart';
import 'package:furniswap/data/repository/Adress/address_repo.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepo addressRepo;

  AddressCubit(this.addressRepo) : super(AddressInitial());

  Future<void> createNewAddress(AddressModel address) async {
    try {
      print("🔄 AddressCubit: creating new address...");
      emit(AddressLoading());

      final result = await addressRepo.createAddress(address);

      result.fold(
        (failure) {
          final errorMessage = _getFailureMessage(failure);
          print("❌ Failed to create address: $errorMessage");
          emit(AddressError(errorMessage));
        },
        (createdAddress) {
          print("✅ Address created successfully: ${createdAddress.toJson()}");
          emit(AddressCreatedSuccessfully(createdAddress));
        },
      );
    } catch (e, stackTrace) {
      print("❌ Unknown error during address creation: $e");
      print("📌 StackTrace: $stackTrace");
      emit(AddressError("حدث خطأ غير متوقع أثناء إنشاء العنوان"));
    }
  }

  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is NetworkFailure) return failure.message;
    if (failure is UnknownFailure) return failure.message;
    return "حدث خطأ غير متوقع";
  }

  Future<void> getAllAddresses() async {
    try {
      print("📥 AddressCubit: fetching all addresses...");
      emit(AddressLoading());

      final result = await addressRepo.getAllAddresses();

      result.fold(
        (failure) {
          final errorMessage = _getFailureMessage(failure);
          print("❌ Failed to fetch addresses: $errorMessage");
          emit(AddressError(errorMessage));
        },
        (addressList) {
          print("✅ Fetched ${addressList.length} addresses");
          emit(AddressListLoaded(addressList));
        },
      );
    } catch (e, stackTrace) {
      print("❌ Unknown error during address fetching: $e");
      print("📌 StackTrace: $stackTrace");
      emit(AddressError("حدث خطأ غير متوقع أثناء تحميل العناوين"));
    }
  }
}
