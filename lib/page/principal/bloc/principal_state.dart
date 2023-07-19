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

class Loading extends PrincipalState {
  const Loading(super.robots);

  @override
  List<Object> get props => [];
}

class Success extends PrincipalState {
  const Success(super.robots);

  @override
  List<Object> get props => [];
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
  List<Object> get props => [iaEvent];
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
