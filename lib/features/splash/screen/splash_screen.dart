import 'package:flutter/material.dart';
import 'package:googleiolapaz/shared/shared.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Label('Google IO', type: LabelType.max),
            VerticalSpace.md,
            const Label('La Paz', type: LabelType.title),
            VerticalSpace.xl,
            const SizedBox(
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
