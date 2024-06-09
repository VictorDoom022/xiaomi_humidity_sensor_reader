import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isBluetoothSupported = false;
  bool isBluetoothEnabled = false;
  bool isBluetoothScanning = false;
  List<ScanResult> scanResults = [];
  BluetoothDevice? connectedDevice;

  StreamSubscription<BluetoothAdapterState>? bluetoothStateSubscription;
  StreamSubscription<List<ScanResult>>? scannedBluetoothDevice;
  StreamSubscription<BluetoothConnectionState>? bluetoothConnectedDeviceState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
          connectedDevice = device;
        });
        await discoverDeviceServices();
      }else{
        setState(() {
          connectedDevice = null;
        });
      }
    });

    if(bluetoothConnectedDeviceState != null) {
      device.cancelWhenDisconnected(bluetoothConnectedDeviceState!,
        delayed: true,
        next: true
      );
    }
  }

  Future<void> discoverDeviceServices() async {
    List<BluetoothService>? bluetoothDeviceServices = await connectedDevice?.discoverServices();
    bluetoothDeviceServices?.forEach((BluetoothService bluetoothService) {
      bluetoothService.characteristics.forEach((BluetoothCharacteristic bluetoothCharacteristic) async {
        if(bluetoothCharacteristic.properties.read){
          List<int> data = await bluetoothCharacteristic.read();
          print(data);
        }
      });
    });
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
              connectedDevice != null ? _buildBluetoothStatusItem(
                title: 'Connected Device',
                value: '${connectedDevice?.advName}'
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
              _buildScannedXiaomiDevices(),
            ],
          ),
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
          bool isCurrentConnectedDevice = connectedDevice?.remoteId.str == scanResults[index].device.remoteId.str;
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
          Text(value ?? '')
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
