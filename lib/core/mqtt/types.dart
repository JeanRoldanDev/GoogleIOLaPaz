enum RobotItem {
  cris,
  jean,
}

enum LandkMarkersPosition {
  forward(1),
  back(2),
  left(3),
  right(4);

  const LandkMarkersPosition(this.data);

  final int data;
}

enum Topic {
  human('human/register/spider'),
  output('robot/movement/output'),
  input('robot/movement/input');

  const Topic(this.url);

  final String url;
}
