import 'package:flutter/material.dart';
import 'package:xiaomi_thermometer_ble/pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => HomePage(),
      },
    )
  );
}
