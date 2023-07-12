import 'dart:js' as js;

import 'package:googleiolapaz/core/ia/ia.dart';

class IAimpl implements IA {
  @override
  Future<void> init(IAoptions options) async {
    await js.context.callMethod('Init', [
      options.type,
      options.numHands,
    ]);
  }

  @override
  Future<void> proccessVideo() async {
    await js.context.callMethod('ProcessVideoIA');
  }
}
