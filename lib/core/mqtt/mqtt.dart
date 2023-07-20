import 'package:googleiolapaz/core/mqtt/options.dart';
import 'package:googleiolapaz/core/mqtt/robot.dart';
import 'package:googleiolapaz/core/mqtt/types.dart';

export 'types.dart';

abstract class Mqtt {
  Future<bool> connect(Options options);
  bool get isConnect;
  Future<void> disconnect();

  Future<void> sendMessage({
    required Topic topic,
    required String clientId,
    required int command,
  });

  Future<void> subscribeTopic(
    Topic topic,
  );

  Future<void> unsubscribe(
    Topic topic,
  );

  Stream<Robot> onMessages();
}
