import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {

  static Future<void> initializeBackgroundService() async {
    FlutterBackgroundService backgroundService = FlutterBackgroundService();

    await backgroundService.configure(
      iosConfiguration: IosConfiguration(
        onBackground: onBackgroundServiceStart
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onBackgroundServiceStart,
        isForegroundMode: true
      )
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onBackgroundServiceStart(ServiceInstance instance) async {
    DartPluginRegistrant.ensureInitialized();


    return true;
  }
}