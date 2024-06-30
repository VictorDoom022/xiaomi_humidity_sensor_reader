import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connect_device_state.g.dart';

@JsonSerializable()
class ConnectDeviceState {
  bool isBluetoothSupported = false;
  bool isBluetoothEnabled = false;
  bool isBluetoothScanning = false;

  @JsonKey(includeFromJson: false)
  List<BluetoothDevice> connectedDeviceList = [];
}