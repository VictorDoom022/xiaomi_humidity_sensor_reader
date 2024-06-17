import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';

// Reference: https://medium.com/@murattaksimm/nosql-local-database-for-flutter-02b1d2a70be9
class AddedDeviceService {

  late Future<Isar> isarDB;

  AddedDeviceService(){
    isarDB = openIsarDB();
  }

  Future<void> initIsarDB() async {
    isarDB = openIsarDB();
  }

  Future<Isar> openIsarDB() async {
    Directory applicationDir = await getApplicationDocumentsDirectory();

    if(Isar.instanceNames.isEmpty){
      return await Isar.open(
        [AddedDeviceDataSchema],
        directory: applicationDir.path
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> addNewDevice(AddedDeviceData deviceData) async {
    final Isar isar = await isarDB;
    isar.writeTxnSync(
      () => isar.addedDeviceDatas.putSync(deviceData)
    );
  }

  Future<List<AddedDeviceData>> getAllAddedDeviceData() async {
    final Isar isar = await isarDB;
    return await isar.addedDeviceDatas.where().findAll();
  }

  Stream<List<AddedDeviceData>> listenAddedDeviceData() async* {
    final Isar isar = await isarDB;
    yield* isar.addedDeviceDatas.where().watch(fireImmediately: true);
  }
}