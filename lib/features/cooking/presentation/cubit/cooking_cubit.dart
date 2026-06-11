import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cooking_state.dart';

class CookingCubit extends Cubit<CookingState> {
  final List<String> steps;
  Timer? _timer;

  CookingCubit(this.steps) : super(const CookingState());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void next() {
    if (state.stepIndex + 1 >= steps.length) {
      emit(state.copyWith(done: true));
    } else {
      emit(state.copyWith(stepIndex: state.stepIndex + 1));
    }
  }

  void prev() {
    if (state.stepIndex > 0) {
      emit(state.copyWith(stepIndex: state.stepIndex - 1));
    }
  }

  void startStop() {
    if (state.secs == 0) return;
    if (state.running) {
      _timer?.cancel();
      emit(state.copyWith(running: false));
    } else {
      emit(state.copyWith(running: true));
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (state.secs <= 1) {
          _timer?.cancel();
          emit(state.copyWith(secs: 0, running: false));
        } else {
          emit(state.copyWith(secs: state.secs - 1));
        }
      });
    }
  }

  void resetTimer() {
    _timer?.cancel();
    emit(state.copyWith(secs: 0, running: false));
  }

  void addMinutes(int m) {
    emit(state.copyWith(secs: (state.secs + m * 60).clamp(0, 5999)));
  }
}
