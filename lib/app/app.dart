import 'package:flutter/material.dart';
import 'package:googleiolapaz/layouts/layouts.dart';
import 'package:googleiolapaz/page/splash/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: CFonst.jetbrainsmono,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromARGB(255, 234, 236, 238),
        ),
      ),
      home: const SplashPage(),
    );
  }
}
