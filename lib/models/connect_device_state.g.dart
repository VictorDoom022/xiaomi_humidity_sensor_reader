// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_device_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectDeviceState _$ConnectDeviceStateFromJson(Map<String, dynamic> json) =>
    ConnectDeviceState()
      ..isBluetoothSupported = json['isBluetoothSupported'] as bool
      ..isBluetoothEnabled = json['isBluetoothEnabled'] as bool
      ..isBluetoothScanning = json['isBluetoothScanning'] as bool;

Map<String, dynamic> _$ConnectDeviceStateToJson(ConnectDeviceState instance) =>
    <String, dynamic>{
      'isBluetoothSupported': instance.isBluetoothSupported,
      'isBluetoothEnabled': instance.isBluetoothEnabled,
      'isBluetoothScanning': instance.isBluetoothScanning,
    };
