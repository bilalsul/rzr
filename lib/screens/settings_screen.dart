import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:rzr/enums/options/font_family.dart';
import 'package:rzr/enums/options/plugin.dart';
import 'package:rzr/utils/toast/common.dart';
import 'package:rzr/widgets/settings/about.dart';
import 'package:rzr/widgets/settings/settings_tile.dart';
import 'package:rzr/widgets/settings/simple_dialog.dart';
import 'package:rzr/widgets/settings/theme_mode.dart';
import 'package:rzr/providers/shared_preferences_provider.dart';
import 'package:rzr/widgets/settings/plugin_settings_panel.dart';
import 'package:rzr/enums/options/supported_language.dart';
import 'package:rzr/l10n/generated/L10n.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, required this.controller});

  final ScrollController controller;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // late Color _tempPrimaryColor;
  late Color _tempSecondaryColor;
  late Color _tempAccentColor;
  // other temporary theme values (removed UI for now)
  @override
  Widget build(BuildContext context) {
    // single source: watch Prefs
    final prefs = ref.watch(prefsProvider);
    // final appState = ref.watch(appStateProvider);
    // Temporary theme values are initialized in initState from Prefs.
    // plugin enabled flags read from prefs (prefs.notifyListeners will rebuild)
    final fileExplorerEnabled = prefs.isPluginEnabled(Plugin.fileExplorer.id);
    final themeCustomizerEnabled = prefs.isPluginEnabled(
      Plugin.themeCustomizer.id,
    );

    final languageSubtitle = prefs.locale == null
        ? supportedLanguages[0].values.first
        : supportedLanguages
              .firstWhere(
                (element) =>
                        Text(L10n.of(context).settingsAppearanceAccentColor),
                        const SizedBox(height: 8),
                        Consumer<Prefs>(
                          builder: (context,prefs,child) {
                            return Wrap(
                              spacing: 8,
                              children: Colors.accents.take(16).map((c) {
                                // final col = c.shade400;
                                final col = c;
                                final selected = _tempAccentColor.toARGB32() == col.toARGB32();
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    _tempAccentColor = col;
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: selected
                                          ? Border.all(
                                              color: prefs.accentColor,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: col,
                                      radius: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                              //     if (Theme.of(context).brightness == Brightness.light) ...[
                              //   GestureDetector(
                              //     onTap: () {
                              //       setState(() {
                              //         _tempAccentColor = Colors.black54;
                              //         // _tempAccentColor = Colors.white70; // Set accent color to white if black is selected
                              //       });
                              //     },
                              //     child: Container(
                              //       padding: const EdgeInsets.all(3),
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: _tempAccentColor == Colors.black54 ? Border.all(color: prefs.accentColor, width: 2) : null,
                              //       ),
                              //       child: CircleAvatar(backgroundColor: Colors.black54, radius: 14),
                              //     ),
                              //   ),
                              // ],
                              // if (Theme.of(context).brightness == Brightness.dark) ...[
                              //   GestureDetector(
                              //     onTap: () {
                              //       setState(() {
                              //         _tempAccentColor = Colors.white70;
                              //       });
                              //     },
                              //     child: Container(
                              //       padding: const EdgeInsets.all(3),
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: _tempAccentColor == Colors.white70 ? Border.all(color: prefs.accentColor, width: 2) : null,
                              //       ),
                              //       child: CircleAvatar(backgroundColor: Colors.white70, radius: 14),
                              //     ),
                              //   ),
                              // ],
                              // ...[Colors.black12,Colors.white].map((color) {
                              //   final selected = _tempAccentColor == color;
                              //   return GestureDetector(
                              //     onTap: () => setState(() { _tempAccentColor = color; }),
                              //     child: Container(
                              //       padding: const EdgeInsets.all(3),
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: selected ? Border.all(color: prefs.accentColor, width: 2) : null,
                              //       ),
                              //       child: CircleAvatar(backgroundColor: color, radius: 14),
                              //     ),
                              //   );
                              // }),
                            );
                          }
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // await Prefs().savePrimaryColor(_tempPrimaryColor);
                                await Prefs().saveSecondaryColor(
                                  _tempSecondaryColor,
                                );
                                await Prefs().saveAccentColor(_tempAccentColor);
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text(
                                //       L10n.of(context).settingsThemeApplied,
                                //     ),
                                //   ),
                                // );
                                RZRToast.show(L10n.of(context).settingsThemeApplied);
                              },
                              child: Text(
                                L10n.of(context).commonApply,
                                style: TextStyle(color: prefs.accentColor),
                              ),
                            ),
                            // const SizedBox(width: 6),
                            // ElevatedButton(
                            //   onPressed: () => setState(() {
                            //     // revert temps from prefs
                            //     // final p = Prefs();
                            //     // _tempPrimaryColor = p.primaryColor;
                            //     _tempSecondaryColor = prefs.secondaryColor;
                            //     _tempAccentColor = prefs.accentColor;
                            //   }),
                            //   child: Text(L10n.of(context).settingsRevertThemeColors, style: TextStyle(color: prefs.accentColor)),
                            // ),
                            // const SizedBox(width: 2),
                            ElevatedButton(
                              // style: ButtonStyle(maximumSize: WidgetStateProperty.all(Size.infinite)),
                              onPressed: () => setState(() {
                                // reset theme customizer colors from prefs
                                Prefs().resetThemeCustomizerColors();
                              }),
                              child: Text(
                                L10n.of(context).commonReset,
                                style: TextStyle(color: prefs.accentColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Row(children: [
                        //   Expanded(child: Text(L10n.of(context).settingsBorderRadius)),
                        //   Expanded(
                        //     child: Slider(
                        //       value: _tempBorderRadius,
                        //       min: 0,
                        //       max: 32,
                        //       divisions: 16,
                        //       label: _tempBorderRadius.toStringAsFixed(0),
                        //       onChanged: (v) => setState(() { _tempBorderRadius = v; }),
                        //     ),
                        //   ),
                        // ]),
                        // const SizedBox(height: 8),
                        // Row(children: [
                        //   Expanded(child: Text(L10n.of(context).settingsElevation)),
                        //   Expanded(
                        //     child: Slider(value: _tempElevation, min: 0, max: 12, divisions: 12, label: _tempElevation.toStringAsFixed(0), onChanged: (v) => setState(() { _tempElevation = v; })),
                        //   ),
                        // ]),
                        // const SizedBox(height: 8),
                        // Row(children: [
                        //   Expanded(child: Text(L10n.of(context).settingsAppFontSize)),
                        //   Expanded(child: Slider(value: _tempAppFontSize, min: 10, max: 22, divisions: 12, label: _tempAppFontSize.toStringAsFixed(0), onChanged: (v) => setState(() { _tempAppFontSize = v; }))),
                        // ]),
                        // const SizedBox(height: 8),
                        // Row(children: [
                        //   Expanded(child: Text(L10n.of(context).settingsButtonStyle)),
                        //   DropdownButton<String>(
                        //     value: _tempButtonStyle,
                        //     items: ['elevated', 'outlined', 'text'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        //     onChanged: (v) => setState(() { if (v != null) _tempButtonStyle = v; }),
                        //   ),
                        // ]),
                        // Row(children: [
                        //   Expanded(child: Text(L10n.of(context).settingsReduceAnimations)),
                        //   Switch(value: prefs.reduceAnimations, onChanged: (v) async { await Prefs().saveReduceAnimations(v); }),
                        // ]),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(height: 15),

            // Editor settings panel (visible only when editor plugin enabled)
            prefs.isPluginEnabled(Plugin.advancedEditorOptions.id)
                ? PluginSettingsPanel(
                    title: L10n.of(context).settingsEditorSettings,
                    visible: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(L10n.of(context).settingsEditorTabSize),
                        // Slider(
                        //   activeColor: prefs.accentColor,
                        //   value: (editorCfg['tabSize'] ?? 2).toDouble(),
                        //   min: 2,
                        //   max: 8,
                        //   divisions: 6,
                        //   label: '${editorCfg['tabSize'] ?? 2}',
                        //   onChanged: (v) async => await prefs.setPluginConfig('editor', 'tabSize', v.toInt()),
                        // ),
                        const SizedBox(height: 8),
                        SettingsTile.navigation(
                          title: Text(
                            L10n.of(context).settingsEditorFontFamily,
                          ),
                          value: Text(prefs.editorFontFamily),
                          leading: const Icon(Icons.font_download),
                          onPressed: (context) {
                            showFontPickerDialog(context);
                          },
                        ),
                        // Text(L10n.of(context).settingsEditorFontFamily),
                        // const SizedBox(height: 11),

                        // DropdownButtonFormField<String>(
                        //   // current stored locale code or 'System'
                        //   value: prefs.editorFontFamily,
                        //   items: fontFamily.map((m) {
                        //     final entry = m.entries.first;
                        //     // final code = entry.key;
                        //     final label = entry.value;
                        //     final displayLabel = label[0].toUpperCase() + label.substring(1);
                        //     return DropdownMenuItem<String>(value: label, child: Text(displayLabel));
                        //   }).toList(),
                        //   onChanged: (selectedFont) async {
                        //     if (selectedFont == null) return;
                        //     // Persist the font family to prefs
                        //     await Prefs().saveEditorFontFamily(selectedFont);
                        //   },
                        // ),
                        const SizedBox(height: 25),
                        Text(L10n.of(context).settingsEditorFontSize),
                        Slider(
                          activeColor: prefs.accentColor,
                          value: prefs.editorFontSize,
                          min: 8,
                          max: 40,
                          divisions: 16,
                          label: prefs.editorFontSize.toString(),
                          onChanged: (v) async =>
                              await prefs.saveEditorFontSize(v),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                L10n.of(context).settingsEditorZoomInOut,
                              ),
                            ),
                            Switch.adaptive(
                              value: prefs.isPluginEnabled(
                                Plugin.editorZoomInOut.id,
                              ),
                              onChanged: (v) async =>
                                  await prefs.setPluginEnabled(
                                    Plugin.editorZoomInOut.id,
                                    v,
                                  ),
                              activeColor: prefs.secondaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                L10n.of(context).settingsEditorShowLineNumbers,
                              ),
                            ),
                            Switch.adaptive(
                              value: prefs.isPluginEnabled(
                                Plugin.editorLineNumbers.id,
                              ),
                              onChanged: (v) async =>
                                  await prefs.setPluginEnabled(
                                    Plugin.editorLineNumbers.id,
                                    v,
                                  ),
                              activeColor: prefs.secondaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                L10n.of(
                                  context,
                                ).settingsEditorRenderUnsupportedCharacters,
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                            Switch.adaptive(
                              value: prefs.isPluginEnabled(
                                Plugin.editorRenderControlCharacters.id,
                              ),
                              onChanged: (v) async =>
                                  await prefs.setPluginEnabled(
                                    Plugin.editorRenderControlCharacters.id,
                                    v,
                                  ),
                              activeColor: prefs.secondaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(height: 15),

            // Git settings
            // prefs.featureSupported("git_history") ?
            // PluginSettingsPanel(
            //   title: L10n.of(context).settingsGitSettings,
            //   visible: gitEnabled,
            //   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //     Row(children: [
            //       Expanded(child: Text(L10n.of(context).settingsGitAutoFetch)),
            //       Switch(value: (gitCfg['autoFetch'] ?? true) as bool, onChanged: (v) async => await prefs.setPluginConfig('git', 'autoFetch', v), activeColor: prefs.secondaryColor),
            //     ]),
            //     const SizedBox(height: 8),
            //     Text(L10n.of(context).settingsGitDefaultBranch),
            //     const SizedBox(height: 4),
            //     TextField(
            //       controller: TextEditingController(text: (gitCfg['defaultBranch'] ?? 'main') as String),
            //       decoration: const InputDecoration(hintText: 'main'),
            //       onSubmitted: (v) async => await prefs.setPluginConfig('git', 'defaultBranch', v.trim()),
            //     ),
            //   ]),
            // ) : SizedBox.shrink(),

            // AI settings
            prefs.featureSupported(Plugin.ai.id)
                ? PluginSettingsPanel(
                    title: L10n.of(context).settingsAiSettings,
                    visible: aiEnabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(L10n.of(context).settingsAiModelProvider),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _providerTile(
                              context,
                              'gpt',
                              label: 'OpenAI',
                              assetName: 'openai.png',
                            ),
                            _providerTile(
                              context,
                              'claude',
                              label: 'Anthropic',
                              assetName: 'claude.png',
                            ),
                            _providerTile(
                              context,
                              'grok',
                              label: 'Grok',
                              assetName: 'deepseek.png',
                            ),
                            _providerTile(
                              context,
                              'gemini',
                              label: 'Gemini',
                              assetName: 'gemini.png',
                            ),
                            // _providerTile(context, 'commonai', label: 'Common', assetName: 'commonAi.png'),
                            _providerTile(
                              context,
                              'openrouter',
                              label: 'OpenRouter',
                              assetName: 'openrouter.png',
                            ),
                            _providerTile(
                              context,
                              'xiaohongshu',
                              label: 'Xiaohongshu',
                              assetName: 'xiaohongshu.png',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(L10n.of(context).settingsAiMaxTokens),
                        Slider(
                          activeColor: prefs.accentColor,
                          value: _selectedAiMaxTokens.toDouble(),
                          min: 64,
                          max: 9999,
                          divisions: 32,
                          label: '$_selectedAiMaxTokens',
                          onChanged: (v) => setState(() {
                            _selectedAiMaxTokens = v.toInt();
                          }),
                        ),

                        const SizedBox(height: 12),

                        // Per-provider configuration: Configure API URL and secure API key per provider using the "Configure" button on each provider tile.
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Persist any temporary API URLs
                                for (final entry in _tempApiUrls.entries) {
                                  final full =
                                      entry.key; // '<provider>_<model>'
                                  final idx = full.indexOf('_');
                                  if (idx <= 0) continue;
                                  final provider = full.substring(0, idx);
                                  final model = full.substring(idx + 1);
                                  final urlConfigKey =
                                      '${provider}_${model}_api_url';
                                  await prefs.setPluginConfig(
                                    'ai',
                                    urlConfigKey,
                                    entry.value,
                                  );
                                  await prefs.setPluginConfig(
                                    'ai',
                                    '${provider}_last_model',
                                    model,
                                  );
                                }
                                // Persist any temporary API keys (secure)
                                for (final entry in _tempApiKeys.entries) {
                                  final pluginId =
                                      entry.key; // 'ai_<provider>_<model>'
                                  final key = entry.value;
                                  if (key.isNotEmpty) {
                                    await prefs.setPluginApiKey(pluginId, key);
                                  } else {
                                    await prefs.removePluginApiKey(pluginId);
                                  }
                                }
                                // Persist active provider/model if the user configured one
                                if (_tempActiveProvider != null) {
                                  await prefs.setPluginConfig(
                                    'ai',
                                    'provider',
                                    _tempActiveProvider,
                                  );
                                  if (_tempActiveModel != null)
                                    await prefs.setPluginConfig(
                                      'ai',
                                      'model',
                                      _tempActiveModel,
                                    );
                                }
                                // Persist max tokens
                                await prefs.setPluginConfig(
                                  'ai',
                                  'maxTokens',
                                  _selectedAiMaxTokens,
                                );
                                setState(() {});
                                final activeProvider =
                                    (prefs.getPluginConfig('ai', 'provider')
                                        as String?) ??
                                    _tempActiveProvider ??
                                    '';
                                final ok = activeProvider != ''
                                    ? await _checkApiKey(activeProvider)
                                    : false;
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text(
                                //       ok
                                //           ? L10n.of(
                                //               context,
                                //             ).connectionSuccessful
                                //           : L10n.of(context).connectionFailed,
                                //     ),
                                //   ),
                                // );
                                RZRToast.show(ok
                                          ? L10n.of(
                                              context,
                                            ).connectionSuccessful
                                          : L10n.of(context).connectionFailed);

                              },
                              child: Text(
                                L10n.of(context).commonApply,
                                style: TextStyle(color: prefs.accentColor),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      L10n.of(context).settingsResetAiSettings,
                                    ),
                                    content: Text(
                                      L10n.of(context).settingsResetAiConfirm,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          L10n.of(context).commonCancel,
                                          style: TextStyle(
                                            color: prefs.secondaryColor,
                                          ),
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                prefs.secondaryColor,
                                              ),
                                        ),
                                        child: Text(
                                          L10n.of(context).commonDelete,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm != true) return;
                                // Delete AI-related SharedPreferences keys and secure API keys
                                final sp = prefs.prefs;
                                // collect secure key flags first (plugin_<pluginId>_has_api_key)
                                final hasFlags = sp
                                    .getKeys()
                                    .where(
                                      (k) =>
                                          k.startsWith('plugin_') &&
                                          k.contains('plugin_ai_') &&
                                          k.endsWith('_has_api_key'),
                                    )
                                    .toList();
                                for (final flag in hasFlags) {
                                  final pluginId = flag.substring(
                                    'plugin_'.length,
                                    flag.length - '_has_api_key'.length,
                                  );
                                  // this will remove secure storage key and the 'has' flag, and notify
                                  await prefs.removePluginApiKey(pluginId);
                                }
                                // remove any remaining plugin_ai_ keys via setPluginConfig so Prefs notifies
                                final aiKeys = sp
                                    .getKeys()
                                    .where((k) => k.startsWith('plugin_ai_'))
                                    .toList();
                                for (final k in aiKeys) {
                                  final configKey = k.substring(
                                    'plugin_ai_'.length,
                                  );
                                  await prefs.setPluginConfig(
                                    'ai',
                                    configKey,
                                    null,
                                  );
                                }
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text(
                                //       L10n.of(context).settingsAiSettingsReset,
                                //     ),
                                //   ),
                                // );
                                RZRToast.show(L10n.of(context).settingsAiSettingsReset);

                              },
                              child: Text(
                                L10n.of(context).commonReset,
                                style: TextStyle(color: prefs.accentColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(height: 15),

            // Terminal settings
            // prefs.featureSupported("terminal") ?
            // PluginSettingsPanel(
            //   title: L10n.of(context).settingsTerminalSettings,
            //   visible: terminalEnabled,
            //   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //     Text(L10n.of(context).settingsTerminalShellExecutable),
            //     const SizedBox(height: 8),
            //     TextField(
            //       controller: TextEditingController(text: (terminalCfg['shellPath'] ?? '/bin/bash') as String),
            //       decoration: const InputDecoration(hintText: '/bin/bash'),
            //       onSubmitted: (v) async => await prefs.setPluginConfig('terminal', 'shellPath', v.trim()),
            //     ),
            //     const SizedBox(height: 8),
            //     Row(children: [
            //       Expanded(child: Text(L10n.of(context).settingsTerminalFontSize)),
            //       Slider(value: (terminalCfg['fontSize'] ?? 14).toDouble(), min: 10, max: 24, divisions: 14, onChanged: (v) async => await prefs.setPluginConfig('terminal', 'fontSize', v.toInt()),
            //       activeColor: prefs.accentColor,
            //       ),
            //     ]),
            //     Row(children: [
            //       Expanded(child: Text(L10n.of(context).settingsTerminalAudibleBell)),
            //       Switch(value: (terminalCfg['bell'] ?? true) as bool, onChanged: (v) async => await prefs.setPluginConfig('terminal', 'bell', v), activeColor: prefs.secondaryColor),
            //     ]),
            //   ]),
            // ) : SizedBox.shrink(),

            // File Explorer settings
            prefs.featureSupported(Plugin.fileExplorer.id)
                ? PluginSettingsPanel(
                    title: L10n.of(context).settingsFileExplorerSettings,
                    visible: fileExplorerEnabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(children: [
                        //   Expanded(child: Text(L10n.of(context).settingsFileExplorerShowHidden)),
                        //   Switch(value: (feCfg['show_hidden'] ?? false) as bool, onChanged: (v) async => await prefs.setPluginConfig('file_explorer', 'show_hidden', v), activeColor: prefs.secondaryColor),
                        // ]),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                L10n.of(
                                  context,
                                ).settingsFileExplorerPreviewMarkdown,
                              ),
                            ),
                            Switch.adaptive(
                              value: prefs.isPluginEnabled(
                                Plugin.previewMarkdown.id,
                              ),
                              onChanged: (v) async =>
                                  await prefs.setPluginEnabled(
                                    Plugin.previewMarkdown.id,
                                    v,
                                  ),
                              activeColor: prefs.secondaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                // Reset selected plugin flags and a few common configs to defaults via Prefs.
                // await prefs.setPluginEnabled('editor', false);
                await prefs.setPluginEnabled(Plugin.fileExplorer.id, false);
                await prefs.setPluginEnabled(Plugin.themeCustomizer.id, false);
                // await prefs.setPluginEnabled('git_history', false);
                // await prefs.setPluginEnabled('terminal', false);
                // remove a few plugin config keys
                // await prefs.setPluginConfig('editor', 'tabSize', null);
                // await prefs.setPluginConfig('editor', 'showLineNumbers', null);
                // await prefs.setPluginConfig('git', 'autoFetch', null);
                // await prefs.setPluginConfig('git', 'defaultBranch', null);
                // await prefs.setPluginConfig('file_explorer', 'show_hidden', null);
                // await prefs.setPluginConfig('file_explorer', 'preview_markdown', null);
                prefs.resetThemeCustomizerColors();
              },
              icon: Icon(Icons.restore, color: prefs.accentColor),
              label: Text(
                L10n.of(context).settingsResetPluginDefaults,
                style: TextStyle(color: prefs.accentColor),
              ),
            ),
            const SizedBox(height: 35),
            const SizedBox(height: 400),
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text(
            //         L10n.of(context).appName,
            //         style: TextStyle(fontSize: 13),
            //       ),
            //       Text(
            //         'v${appState.appVersion}',
            //         style: TextStyle(fontSize: 10),
            //       ),
            //     ],
            //   ),
            // ),

            // ad here
            // _isNativeAdLoaded && _nativeAd != null
            //     ? SizedBox(height: 250, child: AdWidget(ad: _nativeAd!))
            //     : const SizedBox.shrink(),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final p = Prefs();

    // _tempPrimaryColor = p.primaryColor;
    _tempSecondaryColor = p.secondaryColor;
    _tempAccentColor = p.accentColor;

    setState(() {});
  }

  // ScrollController get getController{
  //   return controller;
  // }

  @override
  void dispose() {
    super.dispose();
  }

  void showLanguagePickerDialog(BuildContext context) {
    final title = L10n.of(context).settingsAppearanceLanguage;
    final saveToPrefs = Prefs().saveLocaleToPrefs;

    final children = supportedLanguages.map((e) {
      final key = e.keys.first;
      // final dialogOptionLabel = key.substring(0,1).toUpperCase() + key.substring(1);
        (Prefs().getPluginConfig('ai', '${providerId}_api_url') as String?);
    try {
      if (providerId == 'gpt') {
        // OpenAI: try listing models (allow custom URL if configured)
        final url = (effectiveUrl?.isNotEmpty == true
            ? effectiveUrl!
            : 'https://api.openai.com/v1/models');
        final resp = await http
            .get(Uri.parse(url), headers: {'Authorization': 'Bearer $key'})
            .timeout(const Duration(seconds: 6));
        return resp.statusCode == 200;
      } else if (providerId == 'claude') {
        // Anthropic: try listing models endpoint (allow custom URL)
        final url = (effectiveUrl?.isNotEmpty == true
            ? effectiveUrl!
            : 'https://api.anthropic.com/v1/models');
        final resp = await http
            .get(Uri.parse(url), headers: {'x-api-key': key})
            .timeout(const Duration(seconds: 6));
        return resp.statusCode == 200;
      } else {
        // For other providers (grok/gemini) we do a simple non-network check: key presence
        return key.isNotEmpty;
      }
    } catch (e) {
      return false;
    }
  }
}
