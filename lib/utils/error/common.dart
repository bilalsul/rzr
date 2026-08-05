import 'dart:ui';

import 'package:rzr/utils/log/common.dart';
import 'package:flutter/material.dart';

class RZRError {
  static Future<void> init() async {
    RZRLog.info('RZR Error init');
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      RZRLog.severe(details.exceptionAsString(), details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      RZRLog.severe(error.toString(), stack);
      return false;
    };
  }
}
