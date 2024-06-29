import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:xiaomi_thermometer_ble/models/added_device_data/added_device_data.dart';
import 'package:xiaomi_thermometer_ble/services/added_device_service.dart';
import 'package:collection/collection.dart';

class AddNewSensorPage extends StatefulWidget {
  const AddNewSensorPage({super.key});

  @override
  State<AddNewSensorPage> createState() => _AddNewSensorPageState();
}

class _AddNewSensorPageState extends State<AddNewSensorPage> {

  bool isBluetoothScanning = false;

  AddedDeviceService addedDeviceService = AddedDeviceService();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController deviceNameTextEditingController = TextEditingController();

  List<ScanResult> scanResults = [];
  List<AddedDeviceData> addedDeviceList = [];

  StreamSubscription<List<ScanResult>>? scanBluetoothDeviceSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAddedDeviceList();
      await scanForBluetoothDevice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBluePlus.stopScan();
    scanBluetoothDeviceSubscription?.cancel();
  }

  Future<void> getAddedDeviceList() async {
    List<AddedDeviceData> dataFromDB = await addedDeviceService.getAllAddedDeviceData();
    setState(() {
      addedDeviceList = dataFromDB;
    });
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

  Future<void> connectBluetoothDevice(BluetoothDevice device) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: formKey,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Give your new device a name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: deviceNameTextEditingController,
                      validator: (value) {
                        if(value == null || value == ''){
                          return 'Device name cannot be empty';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color(0xff11293d)
                          )
                        ),
                        onPressed: () async {
                          if(formKey.currentState?.validate() != true) return;
                          await addNewDeviceToIsar(device);
                          if(!mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Future<void> addNewDeviceToIsar(BluetoothDevice device) async {
    AddedDeviceData deviceData = AddedDeviceData(
      deviceName: deviceNameTextEditingController.text,
      deviceMacAddress: device.remoteId.str,
      timeAdded: DateTime.now(),
    );

    await addedDeviceService.addNewDevice(deviceData);

    CherryToast.success(
      title: const Text('Success'),
      description: const Text('Device added successfully'),
    ).show(context);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeviceScanningSection(),
              const SizedBox(height: 10),
              _buildScannedDeviceList(),
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

  Widget _buildScannedDeviceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scanned Device(s)'
        ),
        AlignedGridView.count(
          shrinkWrap: true,
          itemCount: scanResults.length,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 8,
          itemBuilder: (context, index) {
            return _buildScannedDeviceItem(
              rssi: scanResults[index].rssi,
              device: scanResults[index].device,
              onTap: () async {
                BluetoothDevice device = scanResults[index].device;
                if(device.advName != 'LYWSD03MMC'){
                  CherryToast.info(
                    title: const Text('Unsupported Device'),
                  ).show(context);
                  return;
                }

                await connectBluetoothDevice(device);
              }
            );
          }
        )
      ],
    );
  }

  Widget _buildScannedDeviceItem({
    required BluetoothDevice device,
    int? rssi,
    VoidCallback? onTap,
  }) {
    bool isDeviceAlreadyConnected = checkDeviceAlreadyAdded(device);
    return GestureDetector(
      onTap: !isDeviceAlreadyConnected ? onTap : null,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
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
                SizedBox(
                  width: 50,
                  child: device.advName == 'LYWSD03MMC' ? Image.asset(
                    'assets/images/xiaomi-sensor-image.png',
                    width: 50,
                  ) : const Icon(
                    Icons.device_unknown,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          device.advName,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Range: $rssi',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          isDeviceAlreadyConnected ? Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8)
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }

  bool checkDeviceAlreadyAdded(BluetoothDevice device){
    return addedDeviceList.firstWhereOrNull((element) {
      return element.deviceMacAddress == device.remoteId.str;
    }) == null ? false : true;
  }
}
