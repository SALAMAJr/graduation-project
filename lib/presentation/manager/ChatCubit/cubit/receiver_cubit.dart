import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniswap/core/errors/failures.dart';
import 'package:furniswap/data/models/socketModel/ReceiverModel.dart';
import 'package:furniswap/data/repository/chating/chat_repo.dart';

part 'receiver_state.dart';

class ReceiverCubit extends Cubit<ReceiverState> {
  final ChatRepo repo;
  ReceiverCubit(this.repo) : super(ReceiverInitial());

  Future<void> loadReceiver(String id) async {
    emit(ReceiverLoading());
    final result = await repo.getReceiverInfo(id);
    result.fold(
      (fail) => emit(ReceiverError(
          fail is ServerFailure ? fail.message : "فشل تحميل بيانات المستخدم")),
      (receiver) => emit(ReceiverLoaded(receiver)),
    );
  }
}
