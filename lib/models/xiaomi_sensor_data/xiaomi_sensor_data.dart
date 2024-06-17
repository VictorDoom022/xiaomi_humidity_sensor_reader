import 'package:isar/isar.dart';

part 'xiaomi_sensor_data.g.dart';

// flutter pub run build_runner build

@collection
class XiaomiSensorData {

  Id id = Isar.autoIncrement;

  double? temperature;
  int? humidity;
  int? battery;
  String? lastUpdateTime;
  String? sensorName;
  String? macAddress;

  XiaomiSensorData({
    this.temperature,
    this.humidity,
    this.battery,
    this.lastUpdateTime,
    this.sensorName,
    this.macAddress,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['battery'] = this.battery;
    data['lastUpdateTime'] = this.lastUpdateTime;
    data['sensorName'] = this.sensorName;
    data['macAddress'] = this.macAddress;
    return data;
  }

}

