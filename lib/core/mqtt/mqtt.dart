import 'package:googleiolapaz/core/mqtt/message.dart';
import 'package:googleiolapaz/core/mqtt/options.dart';

enum LandkMarkersPosition {
  forward(1),
  back(2),
  left(3),
  right(4);

  const LandkMarkersPosition(this.data);

  final int data;
}

enum Topic {
  output('robot/movement/output'),
  input('robot/movement/input');

  const Topic(this.url);

  final String url;
}

abstract class Mqtt {
  Future<bool> connect(Options options);
  Future<void> disconnect();

  Future<int> sendMessage({
    required Topic topic,
    required int value,
  });

  Future<void> subscribeTopic(
    Topic topic,
  );

  Future<void> unsubscribe(
    Topic topic,
  );

  Stream<MessageResponse> onMessages();

  bool get isConnect;
}
