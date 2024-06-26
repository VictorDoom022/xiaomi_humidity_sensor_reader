import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xiaomi_thermometer_ble/bloc/sensor_data_cubit.dart';
import 'package:xiaomi_thermometer_ble/pages/add_new_sensor_page.dart';
import 'package:xiaomi_thermometer_ble/pages/home_page.dart';
import 'package:xiaomi_thermometer_ble/pages/test_page.dart';

import 'bloc/connected_device_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SensorDataCubit>(
          create: (BuildContext context) => SensorDataCubit(),
        ),
        BlocProvider<ConnectedDeviceCubit>(
          create: (BuildContext context) => ConnectedDeviceCubit(),
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/' : (context) => const HomePage(),
          '/add-new-sensor' : (context) => const AddNewSensorPage(),
          '/test-page' : (context) => const TestPage(),
        },
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          scaffoldBackgroundColor: const Color(0xfff4f7fe),
          appBarTheme: const AppBarTheme(
            color: Color(0xfff4f7fe),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Color(0xfff4f7fe)
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.black12,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)
            )
          )
        ),
      ),
    )
  );
}
