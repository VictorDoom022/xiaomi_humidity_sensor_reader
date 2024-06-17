import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'xiaomi_sensor_data.g.dart';

// flutter pub run build_runner build

@JsonSerializable()
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

  factory XiaomiSensorData.fromJson(Map<String, dynamic> json) => _$XiaomiSensorDataFromJson(json);

  Map<String, dynamic> toJson() => _$XiaomiSensorDataToJson(this);

}

