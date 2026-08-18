import 'dart:async';

// import 'package:rzr/providers/shared_preferences_provider.dart';
import 'package:rzr/l10n/generated/L10n.dart';
// import 'package:rzr/main.dart';
import 'package:rzr/providers/shared_preferences_provider.dart';
// import 'package:rzr/page/settings_page/developer/developer_options_page.dart';
import 'package:rzr/utils/env_var.dart';
import 'package:rzr/utils/toast/common.dart';
// import 'package:rzr/utils/toast/common.dart';
import 'package:rzr/widgets/settings/link_icon.dart';
import 'package:rzr/screens/changelog_screen.dart';
import 'package:rzr/widgets/settings/show_donate_dialog.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({
    super.key,
    this.leadingColor = false,
  });
  final bool leadingColor;

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String version = '';

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {}

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(L10n.of(context).appAboutTitle),
      leading: Icon(Icons.info_outline),
      onTap: () => openAboutDialog(context),
    );
  }
}

// const int _developerUnlockTapThreshold = 7;
// int _developerUnlockTapCount = 0;
// Timer? _developerUnlockResetTimer;

// void _handleDeveloperUnlockTap(BuildContext context) {
//   _developerUnlockTapCount++;
//   _developerUnlockResetTimer?.cancel();
//   _developerUnlockResetTimer =
//       Timer(const Duration(seconds: 2), () => _developerUnlockTapCount = 0);

//   final alreadyEnabled = Prefs().developerOptionsEnabled;
//   if (_developerUnlockTapCount < _developerUnlockTapThreshold) {
//     return;
//   }

//   _developerUnlockTapCount = 0;
//   if (!alreadyEnabled) {
//     Prefs().developerOptionsEnabled = true;
//     RZRToast.show('Developer options enabled');
//   }

//   final navigator = Navigator.of(context, rootNavigator: true);
//   if (navigator.canPop()) {
//     navigator.pop();
//   }
//   Future.microtask(_openDeveloperOptionsPage);
// }

// void _openDeveloperOptionsPage() {
//   final BuildContext? navContext = navigatorKey.currentContext;
//   if (navContext == null) return;
//   Navigator.of(navContext).push(
//     CupertinoPageRoute(
//       fullscreenDialog: false,
//       builder: (context) => const DeveloperOptionsPage(),
//     ),
//   );
// }

Future<void> openAboutDialog(BuildContext context) async {
  final pubspecContent = await rootBundle.loadString('pubspec.yaml');
  final pubspec = Pubspec.parse(pubspecContent);
  final version = pubspec.version.toString();

  showDialog(
    // context: navigatorKey.currentContext!,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 460,
          minWidth: 300,
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Center(
                    child: Text(
                      'r z r',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Prefs().secondaryColor,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(L10n.of(context).appVersion),
                  subtitle: Text(
                    '${version + (kDebugMode ? ' (debug)' : '')} · ${EnvVar.buildSource}',
                  ),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: version));
                    RZRToast.show(L10n.of(context).commonCopied);
                    // _handleDeveloperUnlockTap(context);
                  },
                ),
                ListTile(
                  title: Text(L10n.of(context).appChangelog),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChangelogScreen(),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(L10n.of(context).appDonate),
                  onTap: () {
                    showDonateDialog(context);
                  },
                ),
                ListTile(
                  title: Text(L10n.of(context).appLicense),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: L10n.of(context).appName,
                      applicationVersion: version,
                    );
                  },
                ),
                ListTile(
                  title: Text(L10n.of(context).appWebsite),
                  onTap: () {
                    launchUrl(
                      Uri.parse('https://bilalsul.github.io/rzr'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                ListTile(
                  title: Text(L10n.of(context).appPrivacyPolicy),
                  onTap: () async {
                    launchUrl(
                      Uri.parse('https://bilalsul.github.io/rzr/privacy'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                ListTile(
                  title: Text(L10n.of(context).appTerms),
                  onTap: () async {
                    launchUrl(
                      Uri.parse('https://bilalsul.github.io/rzr/terms'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    linkIcon(
                        icon: Icon(
                          IonIcons.earth,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        url: 'https://bilalsul.github.io/rzr',
                        mode: LaunchMode.externalApplication),
                    linkIcon(
                        icon: Icon(
                          IonIcons.logo_github,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        url: 'https://github.com/bilalsul/rzr',
                        mode: LaunchMode.externalApplication),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}