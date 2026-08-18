class EnvVar {
  static const bool isAppStore =
      String.fromEnvironment('isAppStore', defaultValue: 'false') == 'true';

  static const bool isPlayStore =
      String.fromEnvironment('isPlayStore', defaultValue: 'false') == 'true';
  
  static const bool isFdroid =
      String.fromEnvironment('isFdroid', defaultValue: 'false') == 'true';

    static String get buildSource {
        if (isFdroid) return 'F-Droid';
        if (isPlayStore) return 'Google Play';
        if (isAppStore) return 'App Store';
        return 'Source build';
    }
}