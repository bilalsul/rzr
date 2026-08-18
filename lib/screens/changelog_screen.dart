import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rzr/l10n/generated/L10n.dart';
import 'package:rzr/providers/shared_preferences_provider.dart';
import 'package:rzr/utils/get_current_language_code.dart';
import 'package:rzr/utils/log/common.dart';
import 'package:rzr/widgets/markdown/styled_markdown.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({
    super.key,
    this.lastVersion,
    this.currentVersion,
    this.onComplete,
  });

  final String? lastVersion;
  final String? currentVersion;
  final VoidCallback? onComplete;

  @override
  State<ChangelogScreen> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  String _content = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadChangelog();
  }

  Future<void> _loadChangelog() async {
    try {
      final fullChangelog = await rootBundle.loadString('assets/CHANGELOG.md');
      final version = widget.currentVersion?.split('+').first;
      _content = _process(_extractVersion(fullChangelog, version));
    } catch (error) {
      RZRLog.warning('Failed to load changelog from assets: $error');
      _content = _process('- Fixed some bugs\n- 修复已知问题');
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  String _extractVersion(String changelog, String? version) {
    if (version == null) return changelog;
    final lines = changelog.split('\n');
    final start = lines.indexWhere((line) => line.trim() == '## $version');
    if (start == -1) return changelog;
    var end = lines.length;
    for (var index = start + 1; index < lines.length; index++) {
      if (lines[index].trim().startsWith('## ')) {
        end = index;
        break;
      }
    }
    return lines.sublist(start + 1, end).join('\n').trim();
  }

  String _process(String content) {
    final bullets = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.startsWith('- ') || line.startsWith('* '))
        .toList();
    if (bullets.isEmpty) return content;
    final midpoint = bullets.length ~/ 2;
    return getCurrentLanguageCode().startsWith('zh')
        ? bullets.sublist(midpoint).join('\n')
        : bullets.sublist(0, midpoint).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final currentVersion = widget.currentVersion?.split('+').first;
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).appChangelog)),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: Prefs().secondaryColor),
            )
          : Column(
              children: [
                if (currentVersion != null)
                  ListTile(
                    leading: Icon(Icons.update, color: Prefs().accentColor),
                    title: Text(L10n.of(context).welcomeToVersion(currentVersion)),
                    subtitle: widget.lastVersion == null
                        ? null
                        : Text(L10n.of(context).updateFromVersion(
                            widget.lastVersion!.split('+').first,
                          )),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: StyledMarkdown(data: _content),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        widget.onComplete?.call();
                        if (widget.onComplete == null && Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(L10n.of(context).commonOk),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
