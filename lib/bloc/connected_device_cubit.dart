import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectedDeviceCubit extends Cubit<List<BluetoothDevice>> {
  ConnectedDeviceCubit() : super([]);

  void addConnectedDevice(BluetoothDevice device) {
    state.add(device);
    print('Device added to cubit: ${state.length}');
    emit(state);
  }

  void removeConnectedDevice(BluetoothDevice device){
    state.remove(device);
    emit(state);
  }
}