import 'package:flutter/material.dart';
import 'package:googleiolapaz/layouts/layouts.dart';
import 'package:googleiolapaz/page/principal/widgets/widgets.dart';

class HeaderPrincipal extends StatelessWidget {
  const HeaderPrincipal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 93,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
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
      child: Row(
        children: [
          const InfoUser(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BtnCircular(icon: Icons.replay_rounded, onTap: () {}),
                BtnCircular(icon: Icons.camera_alt_outlined, onTap: () {}),
                BtnCircular(icon: Icons.hub_outlined, onTap: () {}),
              ],
            ),
          ),
          const Expanded(
            child: PanelOptions(),
          ),
        ],
      ),
    );
  }
}

class PanelOptions extends StatelessWidget {
  const PanelOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BtnIcon(
          icon: '👍🏻',
          onTap: () {},
        ),
        BtnIcon(
          icon: '👎🏻',
          onTap: () {},
        ),
        BtnIcon(
          icon: '✌🏻',
          onTap: () {},
        ),
        BtnIcon(
          icon: '☝🏻',
          onTap: () {},
        ),
        BtnIcon(
          icon: '✊🏻',
          onTap: () {},
        ),
        BtnIcon(
          icon: '👋🏻',
          onTap: () {},
        ),
        BtnIcon(
          icon: '🤟🏻',
          onTap: () {},
        ),
      ],
    );
  }
}
