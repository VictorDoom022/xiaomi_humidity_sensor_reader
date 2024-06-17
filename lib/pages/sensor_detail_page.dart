import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:xiaomi_thermometer_ble/bloc/sensor_data_cubit.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data/xiaomi_sensor_data.dart';

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
    sensorDataList = sensorDataList.reversed.toList();

    return Scaffold(
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
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    _buildTemperatureGauge(sensorDataList.first),
                    _buildHumidityGauge(sensorDataList.first),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sensorDataList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildSensorDataItem(sensorDataList[index]);
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureGauge(XiaomiSensorData sensorData){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
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
                    'Celcius',
                    style: TextStyle(
                      fontSize: 14
                    ),
                  ),
                  Text(
                    sensorData.lastUpdateTime ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 8
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              backgroundColor: Colors.black12,
              value: (sensorData.temperature ?? 0) / 60,
              strokeCap: StrokeCap.round,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHumidityGauge(XiaomiSensorData sensorData){
    return Padding(
      padding: const EdgeInsets.all(16),
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

                  Text(
                    sensorData.lastUpdateTime ?? 'Unknown',
                    style: const TextStyle(
                        fontSize: 8
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              backgroundColor: Colors.black12,
              value: (sensorData.humidity ?? 0) / 100,
              strokeCap: StrokeCap.round,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSensorDataItem(XiaomiSensorData sensorData) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.thermostat),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sensorData.temperature.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
            Text(
              '${sensorData.humidity.toString()}%',
              style: const TextStyle(
                fontSize: 16
              ),
            )
          ],
        ),
        subtitle: Text(
          sensorData.lastUpdateTime ?? '-'
        ),
      ),
    );
  }
}
