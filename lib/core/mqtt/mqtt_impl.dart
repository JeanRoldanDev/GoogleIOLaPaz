// ignore_for_file: avoid_print

import 'dart:async';

import 'package:googleiolapaz/core/mqtt/message.dart';
import 'package:googleiolapaz/core/mqtt/mqtt.dart';
import 'package:googleiolapaz/core/mqtt/options.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart' hide Topic;

class MqttImpl implements Mqtt {
  MqttBrowserClient? _client;

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
      messagesSubscription;

  final _sCtrl = StreamController<MessageResponse>();
  final _builder = MqttClientPayloadBuilder();

  @override
  bool get isConnect =>
      _client!.connectionStatus?.state == MqttConnectionState.connected;

  @override
  Future<bool> connect(Options options) async {
    try {
      print('entro $_client');
      _client ??= MqttBrowserClient(options.host, options.clientId);

      _client!.port = options.port;
      _client!.keepAlivePeriod = 30;
      _client!.logging(on: false);
      _client!.setProtocolV311();
      _client!.keepAlivePeriod = 20;
      _client!.connectTimeoutPeriod = 2000;
      _client!.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

      final connMess = MqttConnectMessage()
          .withClientIdentifier(options.clientId)
          .startClean()
          .withWillQos(MqttQos.atMostOnce);

      print('[MQTT client] MQTT client connecting....');

      _client!.connectionMessage = connMess;

      await _client!.connect();
      print('[MQTT client] MQTT client connected');

      final result =
          _client!.connectionStatus?.state == MqttConnectionState.connected;
      return result;
    } catch (e) {
      print(e);
      _client!.disconnect();
      print('[MQTT client] MQTT client disconnected');
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    if (_client != null) {
      _client?.disconnect();
    }
    _dispose();
    print('[MQTT client] MQTT client disconnected');
  }

  @override
  Future<int> sendMessage({
    required Topic topic,
    // required LandkMarkersPosition landkMarkers,
    required int value,
  }) async {
    if (_client == null) throw Exception('[Error]: Required connect first');

    if (_client!.connectionStatus == null) {
      throw Exception('[Error]: Error connect not found');
    }

    if (_client!.connectionStatus!.state != MqttConnectionState.connected) {
      throw Exception('[Error]: fail can not send message');
    }

    print('[MQTT client] MQTT client sending message');

    _builder
      ..clear()
      ..addString(value.toString());

    final result = _client!.publishMessage(
      topic.url,
      MqttQos.exactlyOnce,
      _builder.payload!,
    );

    print('[MQTT client] MQTT client sended message $result $value');
    return result;
  }

  @override
  Future<void> subscribeTopic(
    Topic topic,
  ) async {
    if (_client == null) throw Exception('[Error]: Required connect first');

    print('[MQTT client] MQTT client subcribing topic...');

    _client!.subscribe(topic.url, MqttQos.exactlyOnce);

    print('[MQTT client] MQTT client subcribed topic');
    messagesSubscription = _client!.updates?.listen((event) {
      if (event.isNotEmpty) {
        final mqttMessage = event.first;
        final recMess = mqttMessage.payload as MqttPublishMessage;
        final message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print('[MQTT client] MQTT message: topic is <${mqttMessage.topic}>, '
            'payload is <-- $message -->');

        _sCtrl.add(
          MessageResponse(
            message: message,
            topic: mqttMessage.topic,
          ),
        );
      }
    });
  }

  @override
  Stream<MessageResponse> onMessages() {
    return _sCtrl.stream;
  }

  @override
  Future<void> unsubscribe(Topic topic) async {
    if (_client == null) throw Exception('[Error]: Required connect first');

    _client!.unsubscribe(topic.url);
    print('[MQTT client] MQTT unsubscribe');
    _dispose();
  }

  void _dispose() {
    messagesSubscription?.cancel();
    print('[MQTT client] MQTT dispose');
  }
}
