import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:collection/collection.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
        print('Device connected');
        setState(() {
          isDeviceConnected = true;
        });

        await discoverDeviceServices();
        checkSensorDataTimer = Timer.periodic(
          const Duration(seconds: 30), (timer) async {
            await discoverDeviceServices();
        });
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
    _processSensorData(currentBluetoothDevice!.remoteId.str, data);
  }

  void _processSensorData(String deviceRemoteID, List<int> data) {
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
        lastUpdateTime: DateFormat.jm().format(DateTime.now()),
        macAddress: deviceRemoteID,
      );

      setState(() {
        sensorData = result;
      });
    }catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
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
