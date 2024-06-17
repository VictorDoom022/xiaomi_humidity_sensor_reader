import 'package:isar/isar.dart';

part 'added_device_data.g.dart';

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
}