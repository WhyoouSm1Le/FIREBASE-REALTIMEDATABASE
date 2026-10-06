import 'dart:async';
import 'package:firebase_rtdb/model/sensor_model.dart';
import 'package:firebase_rtdb/service/sensor_service.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  final SensorService service = SensorService();
  SensorModel sensorData = SensorModel();

  StreamSubscription? tempSubs;
  StreamSubscription? humiditySubs;
  StreamSubscription? soilSubs;

  AppProvider() {
    tempSubs = service.streamTemp().listen((newtempvalue) {
      sensorData = sensorData.copyWith(temp: newtempvalue);
      notifyListeners();
    });

    humiditySubs = service.streamHumidity().listen((newhumidityvalue) {
      sensorData = sensorData.copyWith(humidity: newhumidityvalue);
      notifyListeners();
    });

    soilSubs = service.streamSoil().listen((newsoilvalue) {
      sensorData = sensorData.copyWith(soil: newsoilvalue);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    tempSubs?.cancel();
    humiditySubs?.cancel();
    soilSubs?.cancel();
    super.dispose();
  }
}