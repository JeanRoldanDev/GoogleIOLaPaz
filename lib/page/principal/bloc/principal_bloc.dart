import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:googleiolapaz/core/ia/ia.dart';
import 'package:googleiolapaz/core/mqtt/mqtt.dart';

part 'principal_event.dart';
part 'principal_state.dart';

typedef PEmit = Emitter<PrincipalState>;

class MyModel {}

class PrincipalBloc extends Bloc<PrincipalEvent, PrincipalState> {
  PrincipalBloc({
    required IA ia,
    required Mqtt mqtt,
  })  : _ia = ia,
        _mqtt = mqtt,
        super(Initial()) {
    on<ScannerIAEv>(_onScannerIA);
    on<LoadModelIAEv>(_onLoadModelIA);
    on<SendResultEv>(_onSendResult);
    on<StopScannerEv>(_onStopScanner);
    on<SendSignalEv>(_onSendSignalEv);
  }

  final IA _ia;
  final Mqtt _mqtt;

  final _ctrl = StreamController<MyModel>();

  StreamController<MyModel> get controller => _ctrl;

  Future<void> _onLoadModelIA(LoadModelIAEv ev, PEmit emit) async {
    try {
      emit(Loading());
      final options = IAoptions(
        type: TypeLecture.gestureRecognizer,
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
      // final status = await _mqtt.connect(
      //   Options(
      //     host: 'ws://192.168.18.75',
      //     port: 9001,
      //     clientId: 'holisqq',
      //   ),
      // );
      // if (status) {
      //   await _mqtt.subscribeTopic(Topic.output);
      // }
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        sendSignalFunc();
      });
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> _onSendSignalEv(SendSignalEv ev, PEmit emit) async {
    emit(Detect(ev.event));
  }

  IAEvent? iaEvent;
  Timer? timer;
  Future<void> sendSignalFunc() async {
    if (iaEvent != null) {
      print('SIGNAL ${iaEvent!.command}');
      add(SendSignalEv(iaEvent!));
      // if (_mqtt.isConnect) {
      //   await _mqtt.sendMessage(
      //     topic: Topic.output,
      //     value: iaEvent!.command.value,
      //   );
      // }
    }
  }

  Future<void> _onSendResult(SendResultEv ev, PEmit emit) async {
    final data = json.decode(ev.data) as Map<String, dynamic>;

    final gl1 = data['gestures'] as List<dynamic>;
    final gl2 = (gl1.first as List<dynamic>).first;
    final gMap = gl2 as Map<String, dynamic>;
    final gesture = gMap['categoryName'].toString();

    final han1 = data['handednesses'] as List<dynamic>;
    final han2 = (han1.first as List<dynamic>).first;
    final hMap = han2 as Map<String, dynamic>;
    final handStr = hMap['categoryName'].toString();

    final ll1 = data['landmarks'] as List<dynamic>;
    final listData = ll1.first as List<dynamic>;
    final listLandmark = listData
        .map<Landmark>(
          (e) => Landmark.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    final hand = Hand.getHand(handStr);
    final command = Command.getCommand(gesture, hand);

    iaEvent = IAEvent(
      command,
      hand,
      listLandmark,
    );
  }

  Future<void> _onStopScanner(StopScannerEv ev, PEmit emit) async {}
}
