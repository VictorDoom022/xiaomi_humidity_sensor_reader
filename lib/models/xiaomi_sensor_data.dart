class XiaomiSensorData {
  final double? temperature;
  final int? humidity;
  final int? battery;
  final String? lastUpdateTime;
  final String? sensorName;

  XiaomiSensorData({
    this.temperature,
    this.humidity,
    this.battery,
    this.lastUpdateTime,
    this.sensorName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['battery'] = this.battery;
    data['lastUpdateTime'] = this.lastUpdateTime;
    data['sensorName'] = this.sensorName;
    return data;
  }

}

