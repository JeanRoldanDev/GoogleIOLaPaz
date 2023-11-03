import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleiolapaz/core/ia/models/ia_event.dart';
import 'package:googleiolapaz/core/mqtt/robot.dart';
import 'package:googleiolapaz/features/principal/bloc/principal_bloc.dart';
import 'package:googleiolapaz/features/principal/widgets/widgets.dart';
import 'package:googleiolapaz/shared/utils/utils.dart';
import 'package:googleiolapaz/shared/widgets/widgets.dart';
import 'package:universal_html/html.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  final cameraWeb = CameraWeb();

  @override
  void initState() {
    window.addEventListener('message', (Event event) {
      final messageEvent = event as MessageEvent;
      final data = messageEvent.data.toString();
      context.read<PrincipalBloc>().add(SendResultEv(data));
    });

    super.initState();
  }

  Future<void> openCamera(BuildContext context) async {
    await cameraWeb.turnON();
    if (context.mounted) {
      context.read<PrincipalBloc>().add(const CameraEv(true));
    }
  }

  Future<void> proccessVideo(BuildContext context) async {
    if (context.mounted) {
      context.read<PrincipalBloc>().add(StartScannerEv());
    }
  }

  Future<void> reset(BuildContext context) async {}

  Future<void> sendSignalManual(BuildContext context, Command command) async {
    final defaultValue = IAEvent(command, Hand.left, const []);
    context.read<PrincipalBloc>()
      ..setInitIAEvent(defaultValue)
      ..add(SendSignalEv(defaultValue));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            HeaderPrincipal(
              onReset: () => reset(context),
              onTapCamera: () => openCamera(context),
              onTapIA: () => proccessVideo(context),
              onTapOptions: (command) => sendSignalManual(context, command),
            ),
            VerticalSpace.sl,
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                    width: 90,
                    child: RobotsItem(),
                  ),
                  Expanded(
                    child: BlocBuilder<PrincipalBloc, PrincipalState>(
                      buildWhen: (previous, current) {
                        return current is LoadingCamera ||
                            current is SuccessCamera;
                      },
                      builder: (context, state) {
                        return Stack(
                          children: [
                            cameraWeb,
                            if (state is LoadingCamera)
                              const Center(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RobotsItem extends StatelessWidget {
  const RobotsItem({super.key});

  Future<void> robotToggle(BuildContext context, Robot robot) async {
    if (context.mounted) {
      context.read<PrincipalBloc>().add(EnableRobotEv(robot));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrincipalBloc, PrincipalState>(
      buildWhen: (previous, current) {
        return current is NewRobot;
      },
      builder: (context, state) {
        final robotAll = context.read<PrincipalBloc>().robotALL;
        return Column(
          children: [
            BtnSpider(
              icon: '🕷️🕷️',
              label: robotAll.name,
              enable: robotAll.enable,
              status: robotAll.status,
              onTap: () => robotToggle(context, robotAll),
            ),
            ...state.robots.map((e) {
              return BtnSpider(
                icon: '🕷️',
                label: e.name,
                status: e.status,
                enable: e.enable,
                onTap: () => robotToggle(context, e),
              );
            }),
          ],
        );
      },
    );
  }
}
