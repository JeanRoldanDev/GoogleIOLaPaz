part of 'principal_bloc.dart';

abstract class PrincipalState extends Equatable {
  const PrincipalState();

  @override
  List<Object> get props => [];
}

class Initial extends PrincipalState {}

class Loading extends PrincipalState {}

class Success extends PrincipalState {}

class Detect extends PrincipalState {}

class Error extends PrincipalState {
  const Error(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
