import 'dart:async';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:xiaomi_thermometer_ble/services/added_device_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isBluetoothSupported = false;
  bool isBluetoothEnabled = false;
  String selectedFilterCategory = 'All Devices';

  AddedDeviceService addedDeviceCubit = AddedDeviceService();

  StreamSubscription<BluetoothAdapterState>? bluetoothStateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkBluetoothSupported();
      if(isBluetoothSupported) checkBluetoothState();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildAppHeader(),
              const SizedBox(height: 5),
              _buildControls(),
              const SizedBox(height: 5),
              _buildFilterSensorCategoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Sensors',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24
                ),
              )
            ],
          ),
        ),
        CircleAvatar(
          child: Icon(
            Icons.person,
            size: 30,
            color: Colors.black45,
          ),
        )
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildControlsItem(
              title: 'Bluetooth',
              value: isBluetoothEnabled ? 'On' : 'Off',
              icon: const Icon(
                Icons.bluetooth,
                color: Colors.blueAccent,
              ),
              onTap: () async {
                if(!Platform.isAndroid){
                  CherryToast.error(
                    title: const Text('Unsupported Action'),
                    description: const Text('Please turn on Bluetooth manually'),
                  ).show(context);
                  return;
                }
                if(isBluetoothEnabled){
                  await FlutterBluePlus.turnOn();
                  return;
                }
                await FlutterBluePlus.turnOff();
              }
            ),
          ),
          Container(
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: const VerticalDivider(
              width: 5,
              color: Colors.black26,
            ),
          ),
          Expanded(
            child: _buildControlsItem(
              title: 'New Device',
              value: 'Add',
              icon: const Icon(
                Icons.add,
                color: Colors.green,
              ),
              onTap: () async {

              }
            ),
          ),
          Container(
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            child: const VerticalDivider(
              width: 5,
              color: Colors.black26,
            ),
          ),
          Expanded(
            child: _buildControlsItem(
              title: 'Coming Soon',
              value: '...',
              icon: const Icon(
                Icons.other_houses,
                color: Colors.green,
              ),
              onTap: () async {

              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsItem({
    required String title,
    required Icon icon,
    String? value,
    VoidCallback? onTap,
  }){
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    value ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterSensorCategoryList() {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            _buildFilterSensorCategoryListItem(
              title: 'All Devices',
              isSelected: selectedFilterCategory == 'All Devices'
            ),
            _buildFilterSensorCategoryListItem(
              title: 'All Devices',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSensorCategoryListItem({
    required String title,
    bool? isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isSelected == true ? const Color(0xff11293d) : Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isSelected == true ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
