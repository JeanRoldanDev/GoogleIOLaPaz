import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleiolapaz/layouts/nav/nav.dart';
import 'package:googleiolapaz/page/principal/principal_page.dart';
import 'package:googleiolapaz/page/splash/bloc/splash_bloc.dart';
import 'package:googleiolapaz/page/splash/screen/splash_screen.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc()..add(LoadAppEv()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashSuccess) {
            Nav.root(context, const PrincipalPage());
          }
        },
        child: const SplashScreen(),
      ),
    );
  }
}
