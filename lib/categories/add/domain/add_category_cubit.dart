import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../common/data/models/transaction_type.dart';
import '../../../common/domain/name_validator.dart';
import '../../common/data/local_category_repository.dart';
import 'add_category_state.dart';

class AddCategoryCubit extends Cubit<NewCategoryState> with NameValidator {
  final LocalCategoryRepository _categoryRepo;

  AddCategoryCubit(this._categoryRepo)
      : super(NewCategoryState(TransactionType.expense, null, null, null));

  void changeType(TransactionType newType) {
    emit(
        state.copyWith(
          type: newType,
          error: null,
        )
    );
  }

  void changeIcon(IconData newIcon) async {
    emit(
        state.copyWith(
          icon: newIcon,
          error: null,
        )
    );
  }

  void changeName(String newName) async {
    emit(
        state.copyWith(
          name: newName,
          error: null,
        )
    );
  }

  Future<void> saveCategory() async {
    final currentState = state;

    final titleError = validateName(currentState.name);

    if (titleError != null) {
      emit(
          currentState.copyWith(
            error: titleError,
          )
      );
      return;
    }

    if (currentState.type == null) {
      emit(
          currentState.copyWith(
            error: "Select type, please",
          )
      );
      return;
    }

    if (currentState.icon == null) {
      emit(
          currentState.copyWith(
            error: "Select icon, please",
          )
      );
      return;
    }

    final category = await _categoryRepo.create(currentState.name!, currentState.type!, currentState.icon!);
    //TODO Add error handling
    Get.back();
  }

}
