import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';
import 'package:xiaomi_thermometer_ble/services/added_device_service.dart';
import 'package:collection/collection.dart';
import 'package:xiaomi_thermometer_ble/services/sensor_data_service.dart';

class ConnectedDeviceCubit extends Cubit<List<BluetoothDevice>> {
  ConnectedDeviceCubit() : super([]);

  AddedDeviceService addedDeviceService = AddedDeviceService();
  List<AddedDeviceData> addedDeviceData = [];

  SensorDataService sensorDataService = SensorDataService();

  bool isBluetoothSupported = false;
  bool isBluetoothEnabled = false;
  bool isBluetoothScanning = false;

  Timer? checkSensorDataTimer;
  StreamSubscription<BluetoothAdapterState>? bluetoothStateSubscription;
  StreamSubscription<List<ScanResult>>? scanResultSubscription;
  StreamSubscription<BluetoothConnectionState>? bluetoothConnectedDeviceState;

  Future<void> initialize() async {
    addedDeviceData = await addedDeviceService.getAllAddedDeviceData();

    await checkBluetoothSupported();
    if(isBluetoothSupported) checkBluetoothState();
    if(isBluetoothEnabled && isBluetoothEnabled) await scanForDevice();
  }

  Future<void> checkBluetoothSupported() async {
    if(await FlutterBluePlus.isSupported == false){
      isBluetoothSupported = false;
    }else{
      isBluetoothSupported = true;
    }
  }

  void checkBluetoothState() {
    bluetoothStateSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState bluetoothState) {
      if(bluetoothState == BluetoothAdapterState.on){
        isBluetoothEnabled = true;
      }else{
        isBluetoothEnabled = false;
      }
    });
  }

  Future<void> scanForDevice() async {
    await FlutterBluePlus.startScan(
        timeout: const Duration(minutes: 1)
    );
    isBluetoothScanning = true;


    scanResultSubscription = FlutterBluePlus.onScanResults.listen((List<ScanResult> result) {
      addedDeviceData.forEach((addedDeviceData) async {
        ScanResult? scanResult = result.firstWhereOrNull(
          (element) => element.device.remoteId.str == addedDeviceData.deviceMacAddress
        );
        if(scanResult != null) await connectToDevice(scanResult.device);
      });
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();

    bluetoothConnectedDeviceState = device.connectionState.listen((BluetoothConnectionState connectionState) async {
      if(connectionState == BluetoothConnectionState.connected){
        addConnectedDevice(device);

        await discoverDeviceServices(device);
        checkSensorDataTimer = Timer.periodic(
          const Duration(seconds: 30), (timer) async {
          await discoverDeviceServices(device);
        });
      }else{
        removeConnectedDevice(device);
      }
    });
  }

  Future<void> discoverDeviceServices(BluetoothDevice device) async {
    List<BluetoothService>? bluetoothDeviceServices = await device.discoverServices();

    BluetoothService? temperatureDataService = bluetoothDeviceServices.firstWhereOrNull((BluetoothService service) {
      return service.uuid.str.toLowerCase() == 'ebe0ccb0-7a0a-4b0c-8a1a-6ff2997da3a6'.toLowerCase();
    });
    if(temperatureDataService == null) {
      print('No temperature data service available');
      return;
    }

    BluetoothCharacteristic? tempDataCharacteristic = temperatureDataService.characteristics.firstWhereOrNull((BluetoothCharacteristic bluetoothCharacteristic) {
      return bluetoothCharacteristic.uuid.str.toLowerCase() == 'ebe0ccc1-7a0a-4b0c-8a1a-6ff2997da3a6'.toLowerCase();
    });
    if(tempDataCharacteristic == null) {
      print('No tempData characteristic available');
      return;
    }
    List<int> data = await tempDataCharacteristic.read();

    await _processSensorData(device.remoteId.str, data);
  }

  Future<void> _processSensorData(String deviceRemoteID, List<int> data) async {
    try {
      ByteData byteData = Uint8List.fromList(data).buffer.asByteData();
      int temperature = byteData.getInt16(0, Endian.little);
      int humidity = byteData.getUint8(2);
      int voltage = byteData.getInt16(3, Endian.little);
      double tempDouble = temperature / 100;
      double voltDouble = voltage / 1000;

      int battery = ((voltDouble - 2.1).roundToDouble() * 100).toInt().clamp(0, 100);

      XiaomiSensorData result = XiaomiSensorData(
        temperature: tempDouble,
        humidity: humidity,
        battery: battery,
        lastUpdateTime: DateTime.now(),
        macAddress: deviceRemoteID,
      );


      await sensorDataService.addNewSensorData(result);
    }catch(e) {
      print(e);
    }
  }

  void addConnectedDevice(BluetoothDevice device) {
    state.add(device);
    print('Device added to cubit: ${state.length}');
    emit(state);
  }

  void removeConnectedDevice(BluetoothDevice device){
    state.remove(device);
    emit(state);
  }
}