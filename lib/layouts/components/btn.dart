import 'package:flutter/material.dart';
import 'package:googleiolapaz/layouts/layouts.dart';

class BtnIcon extends StatelessWidget {
  const BtnIcon({
    required this.icon,
    this.fill = true,
    this.onTap,
    super.key,
  });

  final String icon;
  final bool fill;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      color: fill ? CColors.text : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          width: 80,
          height: 40,
          child: Center(
            child: Text(
              icon,
              style: TextStyle(
                color: fill ? Colors.white : CColors.principal,
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BtnCircular extends StatelessWidget {
  const BtnCircular({
    required this.icon,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.5),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Icon(
              icon,
              color: CColors.principal,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
