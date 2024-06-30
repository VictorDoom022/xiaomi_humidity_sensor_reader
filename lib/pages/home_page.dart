import 'dart:async';
import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:xiaomi_thermometer_ble/bloc/connected_device_cubit.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:xiaomi_thermometer_ble/pages/widgets/home_page_thermometer_detail.dart';
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

  AddedDeviceService addedDeviceService = AddedDeviceService();
  late ConnectedDeviceCubit connectedDeviceCubit;

  StreamSubscription<BluetoothAdapterState>? bluetoothStateSubscription;

  @override
  void initState() {
    super.initState();
    connectedDeviceCubit = context.read<ConnectedDeviceCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await connectedDeviceCubit.initialize();
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height
                ),
                _buildAppHeader(),
                const SizedBox(height: 5),
                _buildControls(),
                const SizedBox(height: 5),
                _buildFilterSensorCategoryList(),
                const SizedBox(height: 10),
                _buildAddedDeviceStreamBuilder(),
              ],
            ),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ]
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
                if(isBluetoothEnabled){
                  Navigator.of(context).pushNamed('/add-new-sensor');
                }else{
                  CherryToast.error(
                    title: const Text('Bluetooth Required'),
                    description: const Text('Please turn Bluetooth on'),
                  ).show(context);
                }
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            // _buildFilterSensorCategoryListItem(
            //   title: 'All Devices',
            // )
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
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ]
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

  Widget _buildAddedDeviceStreamBuilder() {
    return StreamBuilder<List<AddedDeviceData>>(
      stream: addedDeviceService.listenAddedDeviceData(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Center(child: Text('An Error Occurred'));
        }

        if(snapshot.data == null || snapshot.data?.isEmpty == true){
          return const Center(child: Text('No device added'));
        }

        return _buildAddedDeviceGridView(snapshot.data!);
      }
    );
  }

  Widget _buildAddedDeviceGridView(List<AddedDeviceData> addedDeviceList) {
    return AlignedGridView.count(
      shrinkWrap: true,
      itemCount: addedDeviceList.length,
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return HomePageThermometerDetail(
          deviceData: addedDeviceList[index]
        );
      }
    );
  }
}
