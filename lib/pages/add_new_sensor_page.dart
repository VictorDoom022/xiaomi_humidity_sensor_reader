import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AddNewSensorPage extends StatefulWidget {
  const AddNewSensorPage({super.key});

  @override
  State<AddNewSensorPage> createState() => _AddNewSensorPageState();
}

class _AddNewSensorPageState extends State<AddNewSensorPage> {

  bool isBluetoothScanning = false;

  List<ScanResult> scanResults = [];

  StreamSubscription<List<ScanResult>>? scanBluetoothDeviceSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await scanForBluetoothDevice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBluePlus.stopScan();
    scanBluetoothDeviceSubscription?.cancel();
  }

  Future<void> scanForBluetoothDevice() async {
    await FlutterBluePlus.startScan();
    setState(() {
      isBluetoothScanning = true;
    });

    scanBluetoothDeviceSubscription = FlutterBluePlus.onScanResults.listen(
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
    if(!mounted) return;
    setState(() {
      isBluetoothScanning = isScanStatus;
    });
    if(scanBluetoothDeviceSubscription != null) FlutterBluePlus.cancelWhenScanComplete(scanBluetoothDeviceSubscription!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Add New Device'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildDeviceScanningSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceScanningSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          const Text(
            'Scanning for Devices',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
          ),
          const Text(
            'Tap on the icon to start/stop the scan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              isBluetoothScanning ? SizedBox(
                height: 150,
                child: LoadingIndicator(
                  colors: [
                    Colors.blueAccent.withOpacity(0.2)
                  ],
                  indicatorType: Indicator.ballScaleMultiple,
                ),
              ) : Container(height: 150),
              GestureDetector(
                onTap: () async {
                  if(isBluetoothScanning){
                    await FlutterBluePlus.stopScan();
                  }else{
                    await scanForBluetoothDevice();
                  }
                },
                child: Icon(
                  isBluetoothScanning ? Icons.phonelink_ring : Icons.phone_android,
                  size: 50,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
