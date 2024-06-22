import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:xiaomi_thermometer_ble/bloc/connected_device_cubit.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:collection/collection.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';
import 'package:xiaomi_thermometer_ble/pages/device_detail_page.dart';
import 'package:xiaomi_thermometer_ble/services/sensor_data_service.dart';

class HomePageThermometerDetail extends StatefulWidget {

  final AddedDeviceData deviceData;

  const HomePageThermometerDetail({
    super.key,
    required this.deviceData
  });

  @override
  State<HomePageThermometerDetail> createState() => _HomePageThermometerDetailState();
}

class _HomePageThermometerDetailState extends State<HomePageThermometerDetail> {

  BluetoothDevice? currentBluetoothDevice;

  bool isBluetoothScanning = false;
  bool isDeviceConnected = false;
  XiaomiSensorData? sensorData;

  Timer? checkSensorDataTimer;
  StreamSubscription<List<ScanResult>>? scanResultSubscription;
  StreamSubscription<BluetoothConnectionState>? bluetoothConnectedDeviceState;

  SensorDataService sensorDataService = SensorDataService();

  late ConnectedDeviceCubit connectedDeviceCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      connectedDeviceCubit = context.read<ConnectedDeviceCubit>();
      await scanForDevice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scanResultSubscription?.cancel();
    bluetoothConnectedDeviceState?.cancel();
    checkSensorDataTimer?.cancel();
  }

  Future<void> scanForDevice() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(minutes: 1)
    );
    setState(() {
      isBluetoothScanning = true;
    });

    scanResultSubscription = FlutterBluePlus.onScanResults.listen((List<ScanResult> result) {
      result.forEach((scanItem) async {
        if(scanItem.device.remoteId.str == widget.deviceData.deviceMacAddress){
          setState(() {
            currentBluetoothDevice = scanItem.device;
            isBluetoothScanning = false;
          });
          await FlutterBluePlus.stopScan();
          await scanResultSubscription?.cancel();
          await connectToDevice();
        }
      });
    });
  }

  Future<void> connectToDevice() async {
    await currentBluetoothDevice?.connect();

    bluetoothConnectedDeviceState = currentBluetoothDevice?.connectionState.listen((BluetoothConnectionState connectionState) async {
      if(connectionState == BluetoothConnectionState.connected){
        if(currentBluetoothDevice != null) connectedDeviceCubit.addConnectedDevice(currentBluetoothDevice!);
        setState(() {
          isDeviceConnected = true;
        });

        await discoverDeviceServices();
        checkSensorDataTimer = Timer.periodic(
          const Duration(seconds: 30), (timer) async {
            await discoverDeviceServices();
        });
      }else{
        if(currentBluetoothDevice != null) connectedDeviceCubit.removeConnectedDevice(currentBluetoothDevice!);
      }
    });
  }

  Future<void> discoverDeviceServices() async {
    List<BluetoothService>? bluetoothDeviceServices = await currentBluetoothDevice?.discoverServices();

    BluetoothService? temperatureDataService = bluetoothDeviceServices?.firstWhereOrNull((BluetoothService service) {
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

    if(currentBluetoothDevice == null) return;
    await _processSensorData(currentBluetoothDevice!.remoteId.str, data);
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

      setState(() {
        sensorData = result;
      });

      await sensorDataService.addNewSensorData(result);
    }catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DeviceDetailPage(
              macAddress: widget.deviceData.deviceMacAddress!
            )
          )
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.thermostat,
                      size: 25,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Icon(
                  Icons.bluetooth_outlined,
                  size: 25,
                  color: Colors.black26,
                )
              ],
            ),
            const SizedBox(height: 20),
            _buildTemperatureStatus(),
            Text(
              widget.deviceData.deviceName ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureStatus() {
    String displayText = '--';
    if(isBluetoothScanning){
      displayText = 'Scanning...';
    }

    if(isDeviceConnected){
      displayText = 'Reading Data...';
    }

    if(sensorData != null){
      displayText = '${sensorData?.temperature.toString() ?? '--'}\u2103';
    }

    return Text(
      displayText,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700
      ),
    );
  }
}
