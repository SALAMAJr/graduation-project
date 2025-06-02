import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/UserModel/UpdateUserRequestModel.dart';
import 'package:furniswap/data/models/UserModel/UserModel.dart';
import 'package:furniswap/data/repository/UseDetails/UserModelRepo.dart';

part 'user_details_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo userRepo;

  UserModel? _userData;

  UserModel? get user => _userData;

  UserCubit(this.userRepo) : super(UserInitial());

  Future<void> fetchUserData() async {
    emit(UserLoading());

    final result = await userRepo.getUserData();

    result.fold(
      (failure) {
        final message =
            failure is ServerFailure ? failure.message : 'Something went wrong';
        emit(UserError(message));
      },
      (userModel) {
        _userData = userModel;
        emit(UserLoaded(userModel));
      },
    );
  }

  Future<void> updateUser({
    required UpdateUserRequestModel data,
    File? image,
  }) async {
    emit(UserLoading());

    final result = await userRepo.updateUser(data, imageFile: image);

    result.fold(
      (failure) {
        final message = failure is ServerFailure
            ? failure.message
            : 'Failed to update user';
        emit(UserError(message));
      },
      (updatedUser) {
        _userData = updatedUser;
        emit(UserLoaded(updatedUser));
      },
    );
  }
}
