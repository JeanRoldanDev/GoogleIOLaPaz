import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:googleiolapaz/layouts/layouts.dart';
import 'package:googleiolapaz/page/principal/widgets/shims/dart_ui.dart' as ui;
import 'package:universal_html/html.dart';

class CameraWeb extends StatefulWidget {
  CameraWeb({super.key});

  final video = html.VideoElement();

  Future<void> turnON() async {
    final getUserMedia = await window.navigator.getUserMedia(video: true);
    video.srcObject = getUserMedia;
  }

  Future<void> turnOFF() async {}

  @override
  State<CameraWeb> createState() => _CameraWebState();
}

class _CameraWebState extends State<CameraWeb> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    createVideoElement();
    super.initState();
  }

  void createVideoElement() {
    widget.video
      ..id = 'VideoDart'
      ..autoplay = true
      ..style.objectFit = 'contain';

    ui.platformViewRegistry.registerViewFactory(
      'videoView',
      (_) => widget.video,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CColors.background,
      ),
      child: const HtmlElementView(viewType: 'videoView'),
    );
  }
}
