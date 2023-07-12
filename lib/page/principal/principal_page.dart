import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:googleiolapaz/core/ia/ia.dart';
import 'package:googleiolapaz/core/ia/ia_impl.dart';
import 'package:googleiolapaz/layouts/layouts.dart';
import 'package:googleiolapaz/page/principal/widgets/header_principal.dart';
import 'package:universal_html/html.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final globalKey = GlobalKey();

  final video = html.VideoElement();
  final IA ia = IAimpl();

  Future<void> openCamera() async {
    if (html.MediaStream.supported) {
      //Se obtiene propiedades del widget
      final ubi = _getOffset();

      //Se crea el video
      video
        ..width = ubi.w.toInt()
        ..height = ubi.h.toInt()
        ..id = 'VideoDart'
        ..autoplay = true
        ..style.objectFit = 'initial'
        ..style.position = 'absolute'
        ..style.zIndex = '100000'
        ..style.background = 'black'
        ..style.top = '${ubi.top}px'
        ..style.left = '${ubi.left}px'
        ..style.borderRadius = '30px'
        ..style.aspectRatio = 'auto ${ubi.w.toInt()} / ${ubi.h.toInt()}';

      //Se crea el video y se inserta en el body
      final getUserMedia = await window.navigator.getUserMedia(video: true);
      video.srcObject = getUserMedia;
      document.body!.append(video);

      // se inicializa el modelo
      await ia.init(
        IAoptions(
          type: TypeLecture.gestureRecognizer,
          numHands: 3,
        ),
      );
    }
  }

  Future<void> proccessVideo() async {
    await ia.proccessVideo();
  }

  Ubi _getOffset() {
    final box = globalKey.currentContext?.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(Offset.zero);
    return Ubi(
      top: position!.dy,
      left: position.dx,
      w: box!.size.width,
      h: box.size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            HeaderPrincipal(
              onTapCamera: openCamera,
              onTapIA: proccessVideo,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                key: globalKey,
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

class Ubi {
  Ubi({
    required this.top,
    required this.left,
    required this.w,
    required this.h,
  });
  final double top;
  final double left;
  final double w;
  final double h;
}
