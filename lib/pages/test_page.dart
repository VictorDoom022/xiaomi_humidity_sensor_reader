import 'dart:async';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:xiaomi_thermometer_ble/bloc/sensor_data_cubit.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';
import 'package:xiaomi_thermometer_ble/pages/sensor_detail_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  bool isBluetoothSupported = false;
  bool isBluetoothEnabled = false;
  bool isBluetoothScanning = false;
  List<ScanResult> scanResults = [];
  List<BluetoothDevice> connectedDevices = [];
  List<XiaomiSensorData> sensorDataList = [];

  Timer? getSensorDataTimer;
  StreamSubscription<BluetoothAdapterState>? bluetoothStateSubscription;
  StreamSubscription<List<ScanResult>>? scannedBluetoothDevice;
  StreamSubscription<BluetoothConnectionState>? bluetoothConnectedDeviceState;

  late SensorDataCubit sensorDataCubit;

  @override
  void initState() {
    super.initState();
    AddedDeviceData addedDeviceData = AddedDeviceData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sensorDataCubit = context.read<SensorDataCubit>();
      await checkBluetoothSupported();
      if(isBluetoothSupported) checkBluetoothState();
    });
  }

  @override
  void dispose() {
    super.dispose();
    bluetoothStateSubscription?.cancel();
    scannedBluetoothDevice?.cancel();
    bluetoothConnectedDeviceState?.cancel();
    getSensorDataTimer?.cancel();
  }

  Future<void> checkBluetoothSupported() async {
    if(await FlutterBluePlus.isSupported == false){
      setState(() {
        isBluetoothSupported = false;
      });
    }else{
      setState(() {
        isBluetoothSupported = true;
      });
    }
  }

  void checkBluetoothState() {
    bluetoothStateSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState bluetoothState) {
      if(bluetoothState == BluetoothAdapterState.on){
        setState(() {
          isBluetoothEnabled = true;
        });
      }else{
        setState(() {
          isBluetoothEnabled = false;
        });
      }
    });
  }

  Future<void> scanForBluetoothDevice() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 30)
    );
    setState(() {
      isBluetoothScanning = true;
    });

    scannedBluetoothDevice = FlutterBluePlus.onScanResults.listen(
      (List<ScanResult> result) {
        setState(() {
          List<ScanResult> filteredScanResult = result.where(
            (element) => element.advertisementData.advName != ''
          ).toList();
          filteredScanResult.sort((a,b) => b.rssi.compareTo(a.rssi));
          scanResults = filteredScanResult;
        });
      },
      onDone: () {
        setState(() {
          isBluetoothScanning = false;
        });
      },
      onError: (error) {
        print(error);
        setState(() {
          isBluetoothScanning = false;
        });
      }
    );

    bool isScanStatus = await FlutterBluePlus.isScanning.where((value) {
      return value == false;
    }).first;
    setState(() {
      isBluetoothScanning = isScanStatus;
    });
    if(scannedBluetoothDevice != null) FlutterBluePlus.cancelWhenScanComplete(scannedBluetoothDevice!);
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();

    bluetoothConnectedDeviceState = device.connectionState.listen((BluetoothConnectionState connectionState) async {
      if(connectionState ==  BluetoothConnectionState.connected){
        setState(() {
          connectedDevices.add(device);
        });
        await discoverDeviceServices();
      }else{
        setState(() {
          connectedDevices.remove(device);
        });
      }
    });

    if(connectedDevices.isNotEmpty){
      print('timer set');
      getSensorDataTimer = Timer.periodic(
        const Duration(minutes: 1), (timer) async {
          return await discoverDeviceServices();
        }
      );
    }

    if(bluetoothConnectedDeviceState != null) {
      device.cancelWhenDisconnected(bluetoothConnectedDeviceState!,
        delayed: true,
        next: true
      );
    }
  }

  Future<void> discoverDeviceServices() async {
    connectedDevices.forEach((BluetoothDevice connectedDevice) async {
      List<BluetoothService>? bluetoothDeviceServices = await connectedDevice.discoverServices();

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
      _processSensorData(connectedDevice.remoteId.str, data);
    });
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
        lastUpdateTime: DateTime.now(),
        macAddress: deviceRemoteID,
      );

      sensorDataCubit.addSensorData(result);

      setState(() {
        XiaomiSensorData? existingSensorData = sensorDataList.firstWhereOrNull(
          (element) => element.sensorName == deviceRemoteID
        );
        if(existingSensorData != null) {
          setState(() {
            sensorDataList.remove(existingSensorData);
          });
        }

        setState(() {
          sensorDataList.add(result);
        });
      });
    }catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xiaomi Thermometer BLE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBluetoothStatusItem(
                title: 'Is Bluetooth Supported:',
                value: isBluetoothSupported.toString()
              ),
              _buildBluetoothStatusItem(
                title: 'Is Bluetooth On:',
                value: isBluetoothEnabled.toString()
              ),
              connectedDevices.isNotEmpty ? _buildBluetoothStatusItem(
                title: 'Connected Device:',
                value: connectedDevices.map(
                  (element) => element.advName
                ).toList().join(', ')
              ) : Container(),
              _buildActionItem(
                title: 'Start Scan',
                buttonTitle: isBluetoothScanning ? 'Scanning...' : 'Scan',
                onPressed: isBluetoothEnabled ? () async {
                 if(isBluetoothScanning){
                   await FlutterBluePlus.stopScan();
                   setState(() {
                     isBluetoothScanning = false;
                   });
                 }else{
                   await scanForBluetoothDevice();
                 }
                } : null
              ),
              connectedDevices.isNotEmpty ? _buildActionItem(
                title: 'Read Data',
                buttonTitle: 'Read',
                onPressed: () async {
                  await discoverDeviceServices();
                }
              ) : Container(),
              _buildSensorData(),
              _buildScannedXiaomiDevices(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorData(){
    if(sensorDataList.isEmpty) return Container();

    return SizedBox(
      height: 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: connectedDevices.length,
          itemBuilder: (context, index) {
            XiaomiSensorData? latestSensorData = sensorDataCubit.getSensorDataByMacAddress(connectedDevices[index].remoteId.str);
            return SizedBox(
              width: 180,
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SensorDetailPage(
                          sensorID: latestSensorData?.macAddress ?? '',
                          sensorName: latestSensorData?.sensorName ?? ''
                        )
                      )
                    );
                  },
                  leading: const Icon(Icons.thermostat),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${latestSensorData?.temperature.toString() ?? '-'}\u2103',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        '${latestSensorData?.humidity.toString() ?? '-'}%',
                        style: const TextStyle(
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                  subtitle: Text(
                    DateFormat.jm().format(latestSensorData!.lastUpdateTime!),
                    style: const TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildScannedXiaomiDevices(){
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          bool isCurrentConnectedDevice = connectedDevices.firstWhereOrNull(
            (element) => element.remoteId.str == scanResults[index].device.remoteId.str
          ) != null;
          return ListTile(
            leading: Tooltip(
              message: 'Higher value is better',
              child: Text(
                scanResults[index].rssi.toString()
              ),
            ),
            title: Text(
              scanResults[index].advertisementData.advName,
              style: TextStyle(
                fontWeight: isCurrentConnectedDevice ? FontWeight.w700 : null,
              ),
            ),
            subtitle: Text(
              scanResults[index].device.remoteId.str,
              style: const TextStyle(
                fontSize: 10
              ),
            ),
            trailing: TextButton(
              child: Text(
                isCurrentConnectedDevice ? 'Disconnect' : 'Connect',
              ),
              onPressed: () async {
                if(isCurrentConnectedDevice){
                  await scanResults[index].device.disconnect();
                }else{
                  await connectToDevice(scanResults[index].device);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBluetoothStatusItem({
    required String title,
    String? value
  }) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(value ?? '')
          )
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required String buttonTitle,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(width: 5),
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonTitle
            ),
          )
        ],
      ),
    );
  }
}
