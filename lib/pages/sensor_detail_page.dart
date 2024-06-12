import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xiaomi_thermometer_ble/bloc/sensor_data_cubit.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data.dart';

class SensorDetailPage extends StatefulWidget {

  final String sensorID;
  final String sensorName;

  const SensorDetailPage({
    super.key,
    required this.sensorID,
    required this.sensorName
  });

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

class _SensorDetailPageState extends State<SensorDetailPage> {


  @override
  Widget build(BuildContext context) {
    SensorDataCubit sensorDataCubit = context.watch<SensorDataCubit>();
    List<XiaomiSensorData> sensorDataList = sensorDataCubit.getSensorDataListByMacAddress(
      widget.sensorID
    );
    print(sensorDataList.length);
    return BlocProvider.value(
      value: context.read<SensorDataCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.sensorID
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: sensorDataList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          sensorDataList[index].temperature.toString() ?? '-'
                      ),
                      subtitle: Text(
                          sensorDataList[index].lastUpdateTime ?? '-'
                      ),
                    );
                  }
                )
                // BlocBuilder<SensorDataCubit, List<XiaomiSensorData>>(
                //   builder: (context, sensorDataList) {
                //     print(sensorDataList.length);
                //     return ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: sensorDataList.length,
                //       itemBuilder: (context, index) {
                //         return ListTile(
                //           title: Text(
                //             sensorDataList[index].temperature.toString() ?? '-'
                //           ),
                //           subtitle: Text(
                //             sensorDataList[index].lastUpdateTime ?? '-'
                //           ),
                //         );
                //       }
                //     );
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
