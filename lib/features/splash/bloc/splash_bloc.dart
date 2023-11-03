import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<LoadAppEv>(_onLoadApp);
  }

  Future<void> _onLoadApp(LoadAppEv ev, Emitter<SplashState> emit) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2), () {});
    emit(SplashSuccess());
  }
}
