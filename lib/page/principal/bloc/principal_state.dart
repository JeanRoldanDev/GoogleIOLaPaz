part of 'principal_bloc.dart';

abstract class PrincipalState extends Equatable {
  const PrincipalState(this.robots);

  final List<Robot> robots;
}

class Initial extends PrincipalState {
  const Initial(super.robots);

  @override
  List<Object> get props => [robots];
}

class LoadingCamera extends PrincipalState {
  const LoadingCamera(super.robots);

  @override
  List<Object> get props => [robots];
}

class SuccessCamera extends PrincipalState {
  const SuccessCamera(super.robots);

  @override
  List<Object> get props => [robots];
}

class NewRobot extends PrincipalState {
  const NewRobot(super.robots);

  @override
  List<Object> get props => [robots];
}

class Detect extends PrincipalState {
  const Detect(
    this.iaEvent,
    super.robots,
  );

  final IAEvent iaEvent;

  @override
  List<Object> get props => [iaEvent, robots];
}

class Error extends PrincipalState {
  const Error(
    this.message,
    super.robots,
  );

  final String message;

  @override
  List<Object> get props => [message];
}
