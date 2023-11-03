import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleiolapaz/core/ia/ia.dart';
import 'package:googleiolapaz/features/principal/bloc/principal_bloc.dart';
import 'package:googleiolapaz/features/principal/widgets/widgets.dart';
import 'package:googleiolapaz/shared/shared.dart';

class HeaderPrincipal extends StatelessWidget {
  const HeaderPrincipal({
    required this.onReset,
    required this.onTapCamera,
    required this.onTapIA,
    required this.onTapOptions,
    super.key,
  });

  final VoidCallback onReset;
  final VoidCallback onTapCamera;
  final VoidCallback onTapIA;
  final void Function(Command command) onTapOptions;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    print('$width');
    final newPadding = width > 1220
        ? 50.0
        : width > 1220
            ? 40.0
            : 10.0;
    final isLarge = width > 1000;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 1000,
      ),
      curve: Curves.decelerate,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(newPadding),
        boxShadow: [
          BoxShadow(
            color: CColors.principal.withOpacity(0.10),
            spreadRadius: 3,
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                isLarge ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              const InfoUser(),
              if (isLarge) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BtnCircular(
                        icon: Icons.replay_rounded,
                        onTap: onReset,
                      ),
                      BtnCircular(
                        icon: Icons.camera_alt_outlined,
                        onTap: onTapCamera,
                      ),
                      BtnCircular(
                        icon: Icons.hub_outlined,
                        onTap: onTapIA,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PanelOptions(
                    onTap: onTapOptions,
                  ),
                ),
              ],
            ],
          ),
          if (!isLarge) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.lg,
                vertical: Spacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BtnCircular(
                    icon: Icons.replay_rounded,
                    onTap: onReset,
                  ),
                  BtnCircular(
                    icon: Icons.camera_alt_outlined,
                    onTap: onTapCamera,
                  ),
                  BtnCircular(
                    icon: Icons.hub_outlined,
                    onTap: onTapIA,
                  ),
                ],
              ),
            ),
            PanelOptions(
              onTap: onTapOptions,
            ),
          ],
        ],
      ),
    );
  }
}

class PanelOptions extends StatelessWidget {
  const PanelOptions({
    required this.onTap,
    super.key,
  });

  final void Function(Command command) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrincipalBloc, PrincipalState>(
      buildWhen: (previous, current) {
        return current is Detect;
      },
      builder: (context, state) {
        var command = Command.none;
        if (state is Detect) {
          command = state.iaEvent.command;
        }
        return Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            BtnIcon(
              icon: '☝🏻',
              label: 'Avanzar',
              fill: command == Command.go,
              onTap: () => onTap.call(Command.go),
            ),
            BtnIcon(
              icon: '👋🏻',
              label: 'Retrocede',
              fill: command == Command.stop,
              onTap: () => onTap.call(Command.stop),
            ),
            BtnIcon(
              icon: '👍🏻',
              label: 'Izquierda',
              fill: command == Command.left,
              onTap: () => onTap.call(Command.left),
            ),
            BtnIcon(
              icon: '👎🏻',
              label: 'Derecha',
              fill: command == Command.rigth,
              onTap: () => onTap.call(Command.rigth),
            ),
            BtnIcon(
              icon: '✌🏻',
              label: 'Saluda',
              fill: command == Command.greet,
              onTap: () => onTap.call(Command.greet),
            ),
            BtnIcon(
              icon: '✊🏻',
              label: 'Sentado',
              fill: command == Command.sit,
              onTap: () => onTap.call(Command.sit),
            ),
            BtnIcon(
              icon: '🤟🏻',
              label: 'Trajedia',
              fill: command == Command.tragedy,
              onTap: () => onTap.call(Command.tragedy),
            ),
          ],
        );
      },
    );
  }
}
