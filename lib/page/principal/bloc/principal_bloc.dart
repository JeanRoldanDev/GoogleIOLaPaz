import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:googleiolapaz/core/ia/ia.dart';
import 'package:googleiolapaz/core/mqtt/mqtt.dart';
import 'package:googleiolapaz/core/mqtt/options.dart';
import 'package:googleiolapaz/core/mqtt/robot.dart';

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
        super(const Initial([])) {
    on<InitEv>(_onInit);
    on<AddRobotEv>(_onAddRobot);
    on<CameraEv>(_onCameraEv);
    //adasdsa
    on<ScannerIAEv>(_onScannerIA);
    on<SendResultEv>(_onSendResult);
    on<StopScannerEv>(_onStopScanner);
    on<SendSignalEv>(_onSendSignalEv);
    on<ToggleRobotoEv>(_onToggleRoboto);
  }

  final IA _ia;
  final Mqtt _mqtt;

  Future<void> _onInit(InitEv ev, PEmit emit) async {
    await _mqtt.connect(
      Options(
        host: 'ws://192.168.0.5',
        port: 9001,
        clientId: 'Google_IO_LaPaz',
      ),
    );
    await _mqtt.subscribeTopic(Topic.human);
    // TODO: matar stream listener
    _mqtt.onMessages().listen((robot) {
      add(AddRobotEv(robot));
    });
  }

  Future<void> _onAddRobot(AddRobotEv ev, PEmit emit) async {
    final newlist = List<Robot>.from([...state.robots, ev.robot]);
    emit(NewRobot(newlist));
  }

  Future<void> _onCameraEv(CameraEv ev, PEmit emit) async {
    try {
      emit(const Loading([]));
      if (ev.status) {
        final options = IAoptions(
          type: TypeLecture.gestureRecognizer,
        );
        await _ia.init(options);
      } else {
        //TODO REMOVER CAMARA
      }
    } catch (e) {
      emit(Error(e.toString(), const []));
    }
  }

  Future<void> _onScannerIA(ScannerIAEv ev, PEmit emit) async {
    try {
      emit(const Loading([]));
      await _ia.proccessVideo();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        sendSignalFunc();
      });
    } catch (e) {
      emit(Error(e.toString(), const []));
    }
  }

  Future<void> _onSendSignalEv(SendSignalEv ev, PEmit emit) async {
    emit(Detect(ev.event, const []));
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

  Future<void> _onToggleRoboto(ToggleRobotoEv ev, PEmit emit) async {
    print(ev.robot);
    final status = await _mqtt.connect(
      Options(
        host: 'ws://192.168.0.5',
        port: 9001,
        clientId: 'holisqq',
      ),
    );
    if (status) {
      await _mqtt.subscribeTopic(Topic.output);
    }
  }
}
