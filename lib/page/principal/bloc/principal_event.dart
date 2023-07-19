part of 'principal_bloc.dart';

abstract class PrincipalEvent extends Equatable {
  const PrincipalEvent();

  @override
  List<Object> get props => [];
}

class InitEv extends PrincipalEvent {}

class AddRobotEv extends PrincipalEvent {
  const AddRobotEv(this.robot);

  final Robot robot;

  @override
  List<Object> get props => [robot];
}

class CameraEv extends PrincipalEvent {
  const CameraEv(this.status);

  final bool status;

  @override
  List<Object> get props => [status];
}

class ScannerIAEv extends PrincipalEvent {}

class StopScannerEv extends PrincipalEvent {}

class SendResultEv extends PrincipalEvent {
  const SendResultEv(this.data);

  final String data;

  @override
  List<Object> get props => [data];
}

class ToggleRobotoEv extends PrincipalEvent {
  const ToggleRobotoEv(this.robot);

  final RobotItem robot;

  @override
  List<Object> get props => [robot];
}

class SendSignalEv extends PrincipalEvent {
  const SendSignalEv(this.event);

  final IAEvent event;

  @override
  List<Object> get props => [event];
}
