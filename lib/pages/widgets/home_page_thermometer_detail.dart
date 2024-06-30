import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:xiaomi_thermometer_ble/bloc/connected_device_cubit.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:collection/collection.dart';
import 'package:xiaomi_thermometer_ble/models/connect_device_state.dart';
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

  SensorDataService sensorDataService = SensorDataService();

  XiaomiSensorData? sensorData;
  ConnectedDeviceCubit connectedDeviceCubit = ConnectedDeviceCubit();
  ConnectDeviceState? connectDeviceState;
  Stream<ConnectDeviceState>? connectDeviceStream;

  @override
  void initState() {
    super.initState();
    connectedDeviceCubit = ConnectedDeviceCubit()..initialize();
    connectedDeviceCubit.stream.listen((state){
      print('setttingh');
      setState(() {
        connectDeviceState = state;
      });
    });
  }

  Future<void> getLatestSensorData() async {
    List<XiaomiSensorData> sensorDataList =  await sensorDataService.getAddedDeviceDataByMacAddress(widget.deviceData.deviceMacAddress!);
    setState(() {
      if(sensorDataList.firstOrNull != null) sensorData = sensorDataList.first;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            connectDeviceState != null ? _buildTemperatureStatus(connectDeviceState) : Container(),
            // StreamBuilder<ConnectDeviceState>(
            //   stream: connectDeviceStream,
            //   builder: (context, snapshot) {
            //     print('hasdata: ${snapshot.hasData}');
            //     print('snapshot: ${snapshot.data?.isBluetoothEnabled}');
            //     return _buildTemperatureStatus(snapshot.data);
            //   }
            // ),
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

  Widget _buildTemperatureStatus(ConnectDeviceState? connectionState) {
    String displayText = '--';
    print('rebuilt');
    print('current con ${connectionState?.connectedDeviceList.length}');
    print('current con ${connectionState?.isBluetoothScanning}');
    if(connectionState?.isBluetoothScanning == true){
      displayText = 'Scanning...';
    }

    if(connectionState?.connectedDeviceList.firstWhereOrNull(
      (element) => element.remoteId.str == widget.deviceData.deviceMacAddress) != null
    ){
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
