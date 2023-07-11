enum TypeLecture { handLandmarker, gestureRecognizer }

class IAoptions {
  IAoptions({
    required this.type,
    this.numHands = 1,
  });

  final TypeLecture type;
  final int numHands;
}

abstract class IA {
  Future<void> init(IAoptions options);
  Future<void> proccessVideo();
}
