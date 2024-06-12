import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xiaomi_thermometer_ble/models/xiaomi_sensor_data.dart';
import 'package:collection/collection.dart';

class SensorDataCubit extends Cubit<List<XiaomiSensorData>> {
  SensorDataCubit() : super([]);

  void addSensorData(XiaomiSensorData sensorData) {
    state.add(sensorData);
    print('added: ${state.length}');
    emit(state);
  }

  List<XiaomiSensorData> getSensorDataListByMacAddress(String macAddress) {
    return state.where(
      (sensorData) => sensorData.macAddress == macAddress
    ).toList();
  }

  XiaomiSensorData? getSensorDataByMacAddress(String macAddress) {
    return state.lastWhereOrNull(
      (sensorData) => sensorData.macAddress == macAddress
    );
  }
}