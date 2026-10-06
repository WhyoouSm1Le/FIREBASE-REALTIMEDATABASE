class SensorModel {
  final double temp;
  final double humidity;
  final double soil;

  SensorModel({
    this.temp = 0.0,
    this.humidity = 0.0,
    this.soil = 0.0,
  });

  SensorModel copyWith({
    double? temp,
    double? humidity,
    double? soil,
  }) {
    return SensorModel(
      temp: temp ?? this.temp,
      humidity: humidity ?? this.humidity,
      soil: soil ?? this.soil,
    );
  }
}