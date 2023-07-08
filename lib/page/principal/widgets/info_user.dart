import 'package:flutter/material.dart';
import 'package:googleiolapaz/layouts/layouts.dart';

class InfoUser extends StatelessWidget {
  const InfoUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/user.jpeg'),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Label('#: SP32 // IP: 192.168.0.34', color: CColors.textGray),
            RichText(
              text: TextSpan(
                text: 'Jean Carlos ',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                  height: 0,
                  letterSpacing: -2,
                  fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                ),
                children: const [
                  TextSpan(
                    text: 'Roldan Alava',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      height: 0,
                      letterSpacing: -2,
                    ),
                  ),
                ],
              ),
            ),
            const Label('Google IO - Bolivia La Paz', color: CColors.textGray),
          ],
        ),
      ],
    );
  }
}
