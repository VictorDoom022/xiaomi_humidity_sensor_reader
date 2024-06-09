class XiaomiSensorData {
  final double temperature;
  final int humidity;
  final int battery;

  XiaomiSensorData({required this.temperature, required this.humidity, required this.battery});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['battery'] = this.battery;
    return data;
  }

}

