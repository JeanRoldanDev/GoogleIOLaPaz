import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleiolapaz/page/principal/bloc/principal_bloc.dart';

import 'package:googleiolapaz/page/principal/widgets/widgets.dart';

class PrincipalScreen extends StatelessWidget {
  PrincipalScreen({super.key});

  final cameraWeb = CameraWeb();

  Future<void> openCamera(BuildContext context) async {
    await cameraWeb.turnON();
    if (context.mounted) {
      context.read<PrincipalBloc>().add(LoadModelIAEv());
    }
  }

  Future<void> proccessVideo(BuildContext context) async {
    if (context.mounted) {
      context.read<PrincipalBloc>().add(ScannerIAEv());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            HeaderPrincipal(
              onTapCamera: () => openCamera(context),
              onTapIA: () => proccessVideo(context),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: cameraWeb,
            ),
          ],
        ),
      ),
    );
  }
}
