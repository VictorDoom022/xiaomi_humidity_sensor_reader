import 'dart:async';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:intl/intl.dart';
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
      await getCurrentDeviceDetail();
      await getLatestSensorData();
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
    print('test');
    if(deviceData?.deviceMacAddress == null) return;
    sensorDataStream = sensorDataService.listenSensorDataByMacAddress(deviceData!.deviceMacAddress!).listen((sensorDataList) {
      setState(() {
        latestSensorData = sensorDataList.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          deviceData?.deviceName ?? 'Unknown Device'
        ),
        actions: [
          TextButton(
            child: const Icon(Icons.more_vert),
            onPressed: () {},
          )
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
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: headerContainerBoxDecoration,
              padding: const EdgeInsets.all(16),
              child: Column(
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
                      barColor: Color(0xff5BC236),
                      icon: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '${latestSensorData?.battery ?? 0}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: headerContainerBoxDecoration,
                    child: Column(
                      children: [
                        latestSensorData != null ? _buildTemperatureGauge(latestSensorData!) : Container()
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: headerContainerBoxDecoration,
                    child: Column(
                      children: [
                        latestSensorData != null ? _buildHumidityGauge(latestSensorData!) : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTemperatureGauge(XiaomiSensorData sensorData){
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sensorData.temperature.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
                const Text(
                  'Celsius',
                  style: TextStyle(
                    fontSize: 14
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: RadialGauge(
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
          ),
        ),
      ],
    );
  }

  Widget _buildHumidityGauge(XiaomiSensorData sensorData){
    return Stack(
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
                const Text(
                  'Humidity',
                  style: TextStyle(
                    fontSize: 14
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: RadialGauge(
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
          ),
        )
      ],
    );
  }

}
