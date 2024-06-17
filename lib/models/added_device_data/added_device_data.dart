import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'added_device_data.g.dart';

@JsonSerializable()
@collection
class AddedDeviceData {
  Id id = Isar.autoIncrement;

  String? deviceName;
  String? deviceMacAddress;
  DateTime? timeAdded;

  AddedDeviceData({
    this.deviceName,
    this.deviceMacAddress,
    this.timeAdded,
  });

  factory AddedDeviceData.fromJson(Map<String, dynamic> json) => _$AddedDeviceDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddedDeviceDataToJson(this);
}