import 'package:flutter/material.dart';
import 'package:googleiolapaz/app/config/env.dart';
import 'package:googleiolapaz/shared/shared.dart';

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
        HorizontalSpace.sm,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Label(
              '#: SP32 // ${Env.instance.ws}',
              color: CColors.textGray,
            ),
            VerticalSpace.md,
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
            VerticalSpace.md,
            const Label('Google IO - Bolivia La Paz', color: CColors.textGray),
          ],
        ),
      ],
    );
  }
}
