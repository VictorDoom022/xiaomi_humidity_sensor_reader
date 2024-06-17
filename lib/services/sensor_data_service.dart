import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';

class SensorDataService {

  late Future<Isar> isarDB;

  SensorDataService(){
    isarDB = openIsarDB();
  }

  Future<Isar> openIsarDB() async {
    Directory applicationDir = await getApplicationDocumentsDirectory();

    if(Isar.instanceNames.isEmpty){
      return await Isar.open(
        [AddedDeviceDataSchema, XiaomiSensorDataSchema],
        directory: applicationDir.path
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> addNewSensorData(XiaomiSensorData sensorData) async {
    final Isar isar = await isarDB;
    isar.writeTxnSync(
      () => isar.xiaomiSensorDatas.putSync(sensorData)
    );
  }

  Future<List<XiaomiSensorData>> getAllAddedDeviceData() async {
    final Isar isar = await isarDB;
    return await isar.xiaomiSensorDatas.where().findAll();
  }

  Future<List<XiaomiSensorData>> getAddedDeviceDataByMacAddress(String macAddress) async {
    final Isar isar = await isarDB;
    return await isar.xiaomiSensorDatas.filter().macAddressEqualTo(macAddress).findAll();
  }

  Future<List<XiaomiSensorData>> getAddedDeviceDataByMacAddressDateSearch({
    required String macAddress,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final Isar isar = await isarDB;
    return await isar.xiaomiSensorDatas.filter().macAddressEqualTo(macAddress).lastUpdateTimeBetween(startTime, endTime).findAll();
  }

  Stream<List<XiaomiSensorData>> listenSensorDataByMacAddress(String macAddress) async* {
    final Isar isar = await isarDB;
    yield* isar.xiaomiSensorDatas.filter().macAddressEqualTo(macAddress).watch(fireImmediately: true);
  }
}