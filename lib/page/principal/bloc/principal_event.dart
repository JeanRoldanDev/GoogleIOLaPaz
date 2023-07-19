part of 'principal_bloc.dart';

abstract class PrincipalEvent extends Equatable {
  const PrincipalEvent();

  @override
  List<Object> get props => [];
}

class LoadModelIAEv extends PrincipalEvent {}

class ScannerIAEv extends PrincipalEvent {}

class StopScannerEv extends PrincipalEvent {}

class SendResultEv extends PrincipalEvent {
  const SendResultEv(this.data);

  final String data;

  @override
  List<Object> get props => [data];
}

class SendSignalEv extends PrincipalEvent {
  const SendSignalEv(this.event);

  final IAEvent event;

  @override
  List<Object> get props => [event];
}
