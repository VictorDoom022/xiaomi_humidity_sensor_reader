import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xiaomi_thermometer_ble/bloc/sensor_data_cubit.dart';
import 'package:xiaomi_thermometer_ble/pages/test_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SensorDataCubit>(
          create: (BuildContext context) => SensorDataCubit(),
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/' : (context) => const TestPage(),
        },
      ),
    )
  );
}
