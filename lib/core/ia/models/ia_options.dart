import 'package:googleiolapaz/core/ia/ia.dart';

class IAoptions {
  IAoptions({
    required this.type,
    this.numHands = 1,
  });

  final TypeLecture type;
  final int numHands;
}
