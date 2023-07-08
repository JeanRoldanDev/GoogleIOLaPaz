import 'package:flutter/material.dart';
import 'package:googleiolapaz/layouts/layouts.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label('Google IO', type: LabelType.max),
            Label('La Paz', type: LabelType.title),
            SizedBox(height: 10),
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                backgroundColor: CColors.background,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
