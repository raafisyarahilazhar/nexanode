import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../models/farm_models.dart';
import '../services/mqtt_service.dart';

class FarmProvider extends ChangeNotifier {
  final MQTTService _mqtt = MQTTService();

  SensorData _sensorData = SensorData(
    ph: 6.5,
    ppm: 1200.0,
    waterTemp: 24.5,
    airTemp: 28.0,
    humidity: 72.0,
    timestamp: DateTime.now(),
  );

  MotorStatus _motorStatus = MotorStatus();

  FarmSettings _settings = FarmSettings();

  SensorData get sensorData => _sensorData;
  MotorStatus get motorStatus => _motorStatus;
  FarmSettings get settings => _settings;

  FarmProvider() {
    _initializeMQTT();
  }

  Future<void> _initializeMQTT() async {
    try {
      await _mqtt.connect();

      // Sensor Data
      _mqtt.subscribe("nexanode/hidroponik/sensor");

      // Status Relay/Motor
      _mqtt.subscribe("nexanode/hidroponik/status");

      _mqtt.client.updates?.listen((events) {
        final recMess = events[0].payload as MqttPublishMessage;

        final payload =
            MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );

        final topic = events[0].topic;

        if (topic == "nexanode/hidroponik/sensor") {
          _handleSensorData(payload);
        }

        if (topic == "nexanode/hidroponik/status") {
          _handleStatusData(payload);
        }
      });

      debugPrint("MQTT Connected");
    } catch (e) {
      debugPrint("MQTT Error : $e");
    }
  }

  void _handleSensorData(String payload) {
    try {
      final json = jsonDecode(payload);

      _sensorData = _sensorData.copyWith(
        ph: (json['ph'] ?? 0).toDouble(),
        ppm: (json['tds'] ?? 0).toDouble(),

        // Jika nanti ESP32 mengirim data ini
        waterTemp:
            (json['waterTemp'] ?? _sensorData.waterTemp)
                .toDouble(),

        airTemp:
            (json['airTemp'] ?? _sensorData.airTemp)
                .toDouble(),

        humidity:
            (json['humidity'] ?? _sensorData.humidity)
                .toDouble(),

        timestamp: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Sensor Parse Error : $e");
    }
  }

  void _handleStatusData(String payload) {
    try {
      final json = jsonDecode(payload);

      _motorStatus = _motorStatus.copyWith(
        pump: json['pump'] ?? _motorStatus.pump,
        phUp: json['phUp'] ?? _motorStatus.phUp,
        phDown: json['phDown'] ?? _motorStatus.phDown,
        nutrisiA:
            json['nutrisiA'] ?? _motorStatus.nutrisiA,
        nutrisiB:
            json['nutrisiB'] ?? _motorStatus.nutrisiB,
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Status Parse Error : $e");
    }
  }

  void toggleMotor(String motor) {
    switch (motor) {
      case 'phUp':
        _motorStatus =
            _motorStatus.copyWith(
          phUp: !_motorStatus.phUp,
        );

        _mqtt.publish(
          "nexanode/hidroponik/control",
          _motorStatus.phUp
              ? "PH_UP_ON"
              : "PH_UP_OFF",
        );
        break;

      case 'phDown':
        _motorStatus =
            _motorStatus.copyWith(
          phDown: !_motorStatus.phDown,
        );

        _mqtt.publish(
          "nexanode/hidroponik/control",
          _motorStatus.phDown
              ? "PH_DOWN_ON"
              : "PH_DOWN_OFF",
        );
        break;

      case 'nutrisiA':
        _motorStatus =
            _motorStatus.copyWith(
          nutrisiA: !_motorStatus.nutrisiA,
        );

        _mqtt.publish(
          "nexanode/hidroponik/control",
          _motorStatus.nutrisiA
              ? "NUTRISI_A_ON"
              : "NUTRISI_A_OFF",
        );
        break;

      case 'nutrisiB':
        _motorStatus =
            _motorStatus.copyWith(
          nutrisiB: !_motorStatus.nutrisiB,
        );

        _mqtt.publish(
          "nexanode/hidroponik/control",
          _motorStatus.nutrisiB
              ? "NUTRISI_B_ON"
              : "NUTRISI_B_OFF",
        );
        break;

      case 'pump':
        _motorStatus =
            _motorStatus.copyWith(
          pump: !_motorStatus.pump,
        );

        _mqtt.publish(
          "nexanode/hidroponik/control",
          _motorStatus.pump
              ? "POMPA_ON"
              : "POMPA_OFF",
        );
        break;
    }

    notifyListeners();
  }

  void updateSettings(FarmSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void setMode(String mode) {
    _settings = _settings.copyWith(mode: mode);
    notifyListeners();
  }

  void selectVegetable(VegetableCategory veg) {
    _settings = _settings.copyWith(
      selectedVegetable: veg,
      targetPh: (veg.phMin + veg.phMax) / 2,
      targetPpm: (veg.ppmMin + veg.ppmMax) / 2,
    );

    notifyListeners();
  }

  String getPhStatus() {
    if (_settings.selectedVegetable == null) {
      if (_sensorData.ph < 6.0) return 'low';
      if (_sensorData.ph > 7.0) return 'high';
      return 'normal';
    }

    final veg = _settings.selectedVegetable!;

    if (_sensorData.ph < veg.phMin) return 'low';
    if (_sensorData.ph > veg.phMax) return 'high';

    return 'normal';
  }

  String getPpmStatus() {
    if (_settings.selectedVegetable == null) {
      if (_sensorData.ppm < 800) return 'low';
      if (_sensorData.ppm > 2000) return 'high';
      return 'normal';
    }

    final veg = _settings.selectedVegetable!;

    if (_sensorData.ppm < veg.ppmMin) return 'low';
    if (_sensorData.ppm > veg.ppmMax) return 'high';

    return 'normal';
  }

  @override
  void dispose() {
    _mqtt.client.disconnect();
    super.dispose();
  }
}