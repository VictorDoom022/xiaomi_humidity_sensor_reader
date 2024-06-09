class XiaomiSensorData {
  final double? temperature;
  final int? humidity;
  final int? battery;
  final String? lastUpdateTime;

  XiaomiSensorData({
    this.temperature,
    this.humidity,
    this.battery,
    this.lastUpdateTime,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['battery'] = this.battery;
    data['lastUpdateTime'] = this.lastUpdateTime;
    return data;
  }

}

