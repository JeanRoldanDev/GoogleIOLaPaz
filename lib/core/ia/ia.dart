import 'package:googleiolapaz/core/ia/models/ia_options.dart';

export 'models/ia_event.dart';
export 'models/ia_options.dart';
export 'models/land_mark.dart';

enum TypeLecture { handLandmarker, gestureRecognizer }

abstract class IA {
  Future<void> init(IAoptions options);
  Future<void> proccessVideo();
  Future<void> stop();
}
