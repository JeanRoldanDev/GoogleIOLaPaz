// ignore_for_file: cascade_invocations

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

class PrincipalBloc extends Bloc<PrincipalEvent, PrincipalState> {
  PrincipalBloc({
    required IA ia,
    required Mqtt mqtt,
  })  : _ia = ia,
        _mqtt = mqtt,
        super(const Initial([])) {
    on<InitEv>(_onInit);
    on<AddRobotEv>(_onAddRobot);
    on<EnableRobotEv>(_onEnableRobot);

    on<CameraEv>(_onCameraEv);
    on<StartScannerEv>(_onStartScanner);
    //adasdsa
    on<SendResultEv>(_onSendResult);
    on<StopScannerEv>(_onStopScanner);
    on<SendSignalEv>(_onSendSignalEv);
  }

  final IA _ia;
  final Mqtt _mqtt;
  Robot robotALL = Robot.all();
  IAEvent? iaEvent;
  Timer? timer;

  Future<void> _onInit(InitEv ev, PEmit emit) async {
    await _mqtt.connect(
      Options(
        host: 'ws://192.168.0.5',
        port: 9001,
        clientId: 'Google_IO_LaPaz',
      ),
    );
    await _mqtt.subscribeTopic(Topic.human);
    _mqtt.onMessages().listen((robot) {
      add(AddRobotEv(robot));
    });
  }

  Future<void> _onAddRobot(AddRobotEv ev, PEmit emit) async {
    final newlist = List<Robot>.from(state.robots);
    final search =
        newlist.indexWhere((el) => el.mac == ev.robot.mac && el.enable == true);

    if (search >= 0) {
      newlist.removeAt(search);
      newlist.add(ev.robot.copyWith(enable: true));
      return;
    }

    if (search == -1) {
      newlist.add(ev.robot);
    }

    robotALL = robotALL.copyWith(status: newlist.isNotEmpty);
    emit(NewRobot(newlist));
  }

  Future<void> _onEnableRobot(EnableRobotEv ev, PEmit emit) async {
    if (ev.robot.clientID == robotALL.clientID && ev.robot.status) {
      final newList = List<Robot>.from(state.robots);
      for (var i = 0; i < newList.length; i++) {
        newList[i] = newList[i].copyWith(enable: false);
      }
      robotALL = robotALL.copyWith(enable: !ev.robot.enable);
      emit(NewRobot(newList));

      return;
    }

    if (ev.robot.clientID != Robot.all().clientID && ev.robot.status) {
      robotALL = robotALL.copyWith(enable: false);
      final index = state.robots.indexWhere((el) => el.mac == ev.robot.mac);
      if (index >= 0) {
        final newList = List<Robot>.from(state.robots);
        newList[index] = newList.elementAt(index).copyWith(
              enable: !ev.robot.enable,
            );
        emit(NewRobot(newList));
      }
    }
  }

  Future<void> _onCameraEv(CameraEv ev, PEmit emit) async {
    try {
      emit(LoadingCamera(state.robots));
      if (ev.status) {
        await Future.delayed(const Duration(seconds: 3), () {});
        final options = IAoptions(
          type: TypeLecture.gestureRecognizer,
        );
        await _ia.init(options);
      }
      emit(SuccessCamera(state.robots));
    } catch (e) {
      emit(Error(e.toString(), const []));
    }
  }

  Future<void> _onStartScanner(StartScannerEv ev, PEmit emit) async {
    try {
      await _ia.proccessVideo();
      timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
        if (iaEvent != null) {
          add(SendSignalEv(iaEvent!));
        }
      });
    } catch (e) {
      emit(Error(e.toString(), const []));
    }
  }

  void setInitIAEvent(IAEvent val) {
    iaEvent = val;
  }

  Future<void> _onSendSignalEv(SendSignalEv ev, PEmit emit) async {
    emit(Detect(ev.event, state.robots));

    if (ev.event.command == Command.none) return;

    if (_mqtt.isConnect && robotALL.enable) {
      await _mqtt.sendMessage(
        topic: Topic.move,
        clientId: robotALL.clientID,
        command: iaEvent!.command.value,
      );
    }

    if (_mqtt.isConnect) {
      final robotsActive = state.robots.where((e) => e.enable);
      for (final robot in robotsActive) {
        await _mqtt.sendMessage(
          topic: Topic.move,
          clientId: robot.clientID,
          command: iaEvent!.command.value,
        );
      }
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
