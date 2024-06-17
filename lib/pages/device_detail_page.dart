import 'package:flutter/material.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCurrentDeviceDetail();
    });
  }

  Future<void> getCurrentDeviceDetail() async {
    AddedDeviceData? foundDeviceData = await addedDeviceService.getDeviceDetailByMacAddress(widget.macAddress);
    if(foundDeviceData == null) return;
    setState(() {
      deviceData = foundDeviceData;
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

            ],
          ),
        ),
      ),
    );
  }
}
