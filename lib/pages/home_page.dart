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

  StreamSubscription<BluetoothAdapterState>? bluetoothStateSubscription;

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
      print(bluetoothState);
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
            ],
          ),
        ),
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
}
