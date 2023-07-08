import 'package:flutter/material.dart';
import 'package:googleiolapaz/layouts/layouts.dart';
import 'package:googleiolapaz/page/principal/widgets/header_principal.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const HeaderPrincipal(),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: CColors.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
