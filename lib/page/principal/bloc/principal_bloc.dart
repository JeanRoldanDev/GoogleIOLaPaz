import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:googleiolapaz/core/ia/ia.dart';

part 'principal_event.dart';
part 'principal_state.dart';

typedef PEmit = Emitter<PrincipalState>;

class PrincipalBloc extends Bloc<PrincipalEvent, PrincipalState> {
  PrincipalBloc({
    required IA ia,
  })  : _ia = ia,
        super(Initial()) {
    on<ScannerIAEv>(_onScannerIA);
    on<LoadModelIAEv>(_onLoadModelIA);
  }

  final IA _ia;

  Future<void> _onLoadModelIA(LoadModelIAEv ev, PEmit emit) async {
    try {
      emit(Loading());
      final options = IAoptions(
        type: TypeLecture.gestureRecognizer,
        numHands: 2,
      );
      await _ia.init(options);
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> _onScannerIA(ScannerIAEv ev, PEmit emit) async {
    try {
      emit(Loading());
      await _ia.proccessVideo();
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
