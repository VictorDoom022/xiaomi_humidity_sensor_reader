import 'dart:async';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:intl/intl.dart';
import 'package:xiaomi_thermometer_ble/bloc/connected_device_cubit.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';
import 'package:xiaomi_thermometer_ble/services/added_device_service.dart';
import 'package:xiaomi_thermometer_ble/services/sensor_data_service.dart';

class DeviceDetailPage extends StatefulWidget {

  final String macAddress;

  const DeviceDetailPage({
    super.key,
    required this.macAddress
  });

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {

  AddedDeviceService addedDeviceService = AddedDeviceService();
  SensorDataService sensorDataService = SensorDataService();

  AddedDeviceData? deviceData;
  XiaomiSensorData? latestSensorData;
  StreamSubscription<List<XiaomiSensorData>>? sensorDataStream;

  BluetoothDevice? currentConnectedBluetoothDevice;
  late ConnectedDeviceCubit connectedDeviceCubit;
  List<String> dropdownButtonSelectionList = ['Connect'];

  BoxDecoration headerContainerBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 5,
        offset: const Offset(0, 2), // changes position of shadow
      ),
    ]
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      connectedDeviceCubit = context.read<ConnectedDeviceCubit>();
      await getCurrentDeviceDetail();
      await getLatestSensorData();
      checkIsDeviceConnected();
    });
  }

  @override
  void dispose() {
    super.dispose();
    sensorDataStream?.cancel();
  }

  Future<void> getCurrentDeviceDetail() async {
    AddedDeviceData? foundDeviceData = await addedDeviceService.getDeviceDetailByMacAddress(widget.macAddress);
    if(foundDeviceData == null) return;
    setState(() {
      deviceData = foundDeviceData;
    });
  }

  Future<void> getLatestSensorData() async {
    if(deviceData?.deviceMacAddress == null) return;
    sensorDataStream = sensorDataService.listenSensorDataByMacAddress(deviceData!.deviceMacAddress!).listen((sensorDataList) {
      setState(() {
        latestSensorData = sensorDataList.last;
      });
    });
  }

  void checkIsDeviceConnected() {
    BluetoothDevice? currentDeviceSearch = connectedDeviceCubit.state.connectedDeviceList.firstWhereOrNull(
      (element) => element.remoteId.str == widget.macAddress
    );
    setState(() {
      currentConnectedBluetoothDevice = currentDeviceSearch;
    });
  }

  void onDropdownMenuSelect(int index) async {
    switch (index) {
      case 0:
        await connectOrDisconnectBluetoothDevice();
        break;
    }
  }

  Future<void> connectOrDisconnectBluetoothDevice() async {
    if(currentConnectedBluetoothDevice != null){
      await currentConnectedBluetoothDevice?.disconnect();
      return;
    }else{
      await currentConnectedBluetoothDevice?.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              deviceData?.deviceName ?? 'Unknown Device',
            ),
            Text(
              currentConnectedBluetoothDevice != null ? 'Connected' : 'Disconnected',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            enableFeedback: true,
            offset: const Offset(0, 40),
            color: Colors.white,
            icon: const Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            itemBuilder: (context) {
              return dropdownButtonSelectionList.map((e) {
                return PopupMenuItem(
                  child: Text(e),
                  onTap: () {
                    onDropdownMenuSelect(dropdownButtonSelectionList.indexOf(e));
                  },
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeaderSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 2,
          child: _buildBatteryAndOtherInfo(),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: latestSensorData != null ? _buildTemperatureGauge(latestSensorData!) : Container(),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: latestSensorData != null ? _buildHumidityGauge(latestSensorData!) : Container(),
        ),
      ],
    );
  }

  Widget _buildBatteryAndOtherInfo() {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(16),
      decoration: headerContainerBoxDecoration,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Battery',
              style: TextStyle(
                fontSize: 14
              ),
            ),
            const SizedBox(height: 15),
            RotatedBox(
              quarterTurns: 3,
              child: BatteryIndicator(
                value: latestSensorData?.battery?.toDouble() ?? 0,
                trackHeight: 50,
                barColor: const Color(0xff5BC236),
                icon: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    '${latestSensorData?.battery ?? 0}%',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Last Updated',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
                fontWeight: FontWeight.w600
              ),
            ),
            Text(
              latestSensorData?.lastUpdateTime != null ? DateFormat('hh:mm a \n dd/MM/yyyy').format(latestSensorData!.lastUpdateTime!) : 'Unknown',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureGauge(XiaomiSensorData sensorData){
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.hardEdge,
      decoration: headerContainerBoxDecoration,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      sensorData.temperature.toString(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Celsius',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          MediaQuery.of(context).size.width > 320 ? RadialGauge(
            track: const RadialTrack(
              start: 0,
              end: 50,
              hideLabels: true,
              trackStyle: TrackStyle(
                showLabel: false,
                showPrimaryRulers: false,
                showSecondaryRulers: false,
              )
            ),
            valueBar: [
              RadialValueBar(
                value: latestSensorData?.temperature ?? 0,
              )
            ],
          ) : Container(),
        ],
      ),
    );
  }

  Widget _buildHumidityGauge(XiaomiSensorData sensorData){
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.hardEdge,
      decoration: headerContainerBoxDecoration,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        sensorData.humidity.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '%',
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Humidity',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          MediaQuery.of(context).size.width > 320 ? RadialGauge(
            track: const RadialTrack(
              start: 0,
              end: 100,
              hideLabels: true,
              trackStyle: TrackStyle(
                showLabel: false,
                showPrimaryRulers: false,
                showSecondaryRulers: false,
              )
            ),
            valueBar: [
              RadialValueBar(
                value: latestSensorData?.humidity?.toDouble() ?? 0,
              )
            ],
          ) : Container()
        ],
      ),
    );
  }

}
