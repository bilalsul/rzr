import 'package:rzr/enums/options/plugin.dart';
import 'package:rzr/providers/shared_preferences_provider.dart';
import 'package:rzr/main.dart';
import 'package:rzr/utils/app_version.dart';
import 'package:flutter/cupertino.dart';
import 'package:rzr/screens/onboarding_screen.dart';
import 'package:rzr/utils/log/common.dart';
import 'package:flutter/material.dart';

class InitializationCheck {
  static String? _lastVersion;
  static String? _currentVersion;

  static Future<String> get lastVersion async {
    if (_lastVersion == null) {
      await _checkVersion();
    }
    return _lastVersion!;
  }

  static Future<String> get currentVersion async {
    if (_currentVersion == null) {
      await _checkVersion();
    }
    return _currentVersion!;
  }

  static Future<void> check() async {
    final firstLaunch = await _checkVersion();
    RZRLog.info('First launch: $firstLaunch');
    if (firstLaunch) {
      _handleFirstLaunch();
      _initDefaultPlugins();

    }
  }

  static Future<bool> _checkVersion() async {
    _lastVersion = Prefs().lastAppVersion;
    _currentVersion = await getAppVersion();
    if (_lastVersion == null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> _initDefaultPlugins() async {
    RZRLog.info('init default Plugins: Set Enabled');
    Prefs().setPluginEnabled(Plugin.previewMarkdown.id, true);
    Prefs().setPluginEnabled(Plugin.syntaxHighlighting.id, true);
    Prefs().setPluginEnabled(Plugin.editorWordWrap.id, true);
    Prefs().setPluginEnabled(Plugin.editorMinimap.id, true);
    Prefs().setPluginEnabled(Plugin.editorLineNumbers.id, true);
    Prefs().setPluginEnabled(Plugin.editorZoomInOut.id, true);
    Prefs().setPluginEnabled(Plugin.advancedEditorOptions.id, true);
    
    
  }

  static Future<void> _handleFirstLaunch() async {
    RZRLog.info('First launch detected, showing onboarding');
    final cv = await currentVersion;
    // wait 0.8 seconds to ensure the app is ready
    Future.delayed(const Duration(milliseconds: 800), () {
      showCupertinoSheet(
        context: navigatorKey.currentContext!,
        builder: (context) => Scaffold(
          body: OnboardingScreen(
            onComplete: () async {
              Prefs().lastAppVersion = cv;
              Navigator.pop(context);
            },
          ),
        ),
      );
    });
  }

}