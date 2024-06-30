import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:xiaomi_thermometer_ble/models/connect_device_state.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';
import 'package:xiaomi_thermometer_ble/services/added_device_service.dart';
import 'package:collection/collection.dart';
import 'package:xiaomi_thermometer_ble/services/sensor_data_service.dart';

class ConnectedDeviceCubit extends Cubit<ConnectDeviceState> {
  ConnectedDeviceCubit() : super(ConnectDeviceState());

  AddedDeviceService addedDeviceService = AddedDeviceService();
  List<AddedDeviceData> addedDeviceData = [];

  SensorDataService sensorDataService = SensorDataService();

  Timer? checkSensorDataTimer;
  StreamSubscription<BluetoothAdapterState>? bluetoothStateSubscription;
  StreamSubscription<List<ScanResult>>? scanResultSubscription;
  StreamSubscription<BluetoothConnectionState>? bluetoothConnectedDeviceState;

  // @override
  // void onChange(Change<ConnectDeviceState> change){
  //   super.onChange(change);
  //   print('checkBluetoothSupported state test ${state.isBluetoothSupported}');
  // }

  Future<void> initialize() async {
    addedDeviceData = await addedDeviceService.getAllAddedDeviceData();

    await checkBluetoothSupported();
    if(state.isBluetoothSupported) await checkBluetoothState();
  }

  Future<void> checkBluetoothSupported() async {
    if(await FlutterBluePlus.isSupported == false){
      state.isBluetoothSupported = false;
    }else{
      state.isBluetoothSupported = true;
    }
    emit(state);
    print('checkBluetoothSupported state ${state.isBluetoothSupported}');
  }

  Future<void> checkBluetoothState() async {
    bluetoothStateSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState bluetoothState) async {
      if(bluetoothState == BluetoothAdapterState.on){
        state.isBluetoothEnabled = true;
        if(state.isBluetoothEnabled && state.isBluetoothSupported) await scanForDevice();
      }else{
        state.isBluetoothEnabled = false;
      }

      emit(state);
    });
  }

  Future<void> scanForDevice() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(minutes: 1)
    );
    state.isBluetoothScanning = true;
    emit(state);

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
    if(!state.connectedDeviceList.contains(device)){
      state.connectedDeviceList.add(device);
      print('New device added');
    }
    emit(state);
    print('Device added to cubit: ${state.connectedDeviceList.length}');
  }

  void removeConnectedDevice(BluetoothDevice device){
    state.connectedDeviceList.remove(device);
    emit(state);
  }
}