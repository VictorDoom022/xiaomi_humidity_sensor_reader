import 'package:flutter/material.dart';
import 'package:xiaomi_thermometer_ble/services/added_device_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AddedDeviceService addedDeviceCubit = AddedDeviceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
