import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleiolapaz/core/ia/ia_impl.dart';
import 'package:googleiolapaz/core/mqtt/mqtt_impl.dart';
import 'package:googleiolapaz/features/principal/bloc/principal_bloc.dart';
import 'package:googleiolapaz/features/principal/screen/principal_screen.dart';
import 'package:googleiolapaz/shared/nav/nav.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrincipalBloc(
        ia: IAimpl(),
        mqtt: MqttImpl(),
      )..add(InitEv()),
      child: BlocListener<PrincipalBloc, PrincipalState>(
        listener: (context, state) {
          if (state is NewRobot) {
            Nav.toast(context, 'New Robot Detected');
          }

          if (state is Error) {
            Nav.toast(context, state.message);
          }
        },
        child: const PrincipalScreen(),
      ),
    );
  }
}
