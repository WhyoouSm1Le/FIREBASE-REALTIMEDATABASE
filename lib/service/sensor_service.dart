import 'package:firebase_database/firebase_database.dart';

class SensorService {
  final database = FirebaseDatabase.instance.ref();

  Stream<double> streamTemp() {
    return database.child('DataSuhu').onValue.map((event) {
      return double.tryParse(event.snapshot.value.toString()) ?? 0;
    });
  }

  Stream<double> streamHumidity() {
    return database.child('DataKelembaban').onValue.map((event) {
      return double.tryParse(event.snapshot.value.toString()) ?? 0;
    });
  }

  Stream<double> streamSoil() {
    return database.child('DataTanah').onValue.map((event) {
      return double.tryParse(event.snapshot.value.toString()) ?? 0;
    });
  }
}