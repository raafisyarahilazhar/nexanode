import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  late MqttServerClient client;

  Future<void> connect() async {
    client = MqttServerClient(
      'f97d76b7580c43709a6dc9d50cf65233.s1.eu.hivemq.cloud',
      'flutter_hydrofarm',
    );

    client.port = 8883;
    client.secure = true;

    client.keepAlivePeriod = 20;

    client.connectionMessage = MqttConnectMessage()
        .authenticateAs(
          'Nexanode',
          'Nexanode123',
        )
        .withClientIdentifier('flutter_hydrofarm')
        .startClean();

    await client.connect();
  }

  void subscribe(String topic) {
    client.subscribe(
      topic,
      MqttQos.atLeastOnce,
    );
  }

  void publish(
    String topic,
    String message,
  ) {
    final builder = MqttClientPayloadBuilder();

    builder.addString(message);

    client.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  void disconnect() {
    client.disconnect();
  }
}