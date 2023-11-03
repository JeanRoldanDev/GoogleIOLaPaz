import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleiolapaz/core/ia/ia.dart';
import 'package:googleiolapaz/core/ia/ia_impl.dart';
import 'package:googleiolapaz/core/mqtt/mqtt.dart';
import 'package:googleiolapaz/core/mqtt/mqtt_impl.dart';
import 'package:googleiolapaz/features/splash/splash_page.dart';
import 'package:googleiolapaz/shared/shared.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IA>(
          create: (context) => IAimpl(),
        ),
        RepositoryProvider<Mqtt>(
          create: (context) => MqttImpl(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: CFonst.jetbrainsmono,
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: const Color.fromARGB(255, 234, 236, 238),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
