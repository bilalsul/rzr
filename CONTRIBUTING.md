# Contributing to RZR (Repo Zip Reader)

Thanks for your interest in contributing! RZR is a free, open-source Flutter app. This guide covers how to set up the project, run it locally, work with translations, and open a pull request.

## Table of Contents

- [Getting Started](#getting-started)
- [Project Layout](#project-layout)
- [Running Locally](#running-locally)
- [Running Tests](#running-tests)
- [Linting & Analysis](#linting--analysis)
- [Translations](#translations)
  - [Adding a New String](#adding-a-new-string)
  - [Translating a String](#translating-a-string)
  - [Checking Untranslated Strings](#checking-untranslated-strings)
  - [Adding a New Locale](#adding-a-new-locale)
  - [Localizing Images & Screenshots](#localizing-images--screenshots)
- [Opening a Pull Request](#opening-a-pull-request)
- [Code of Conduct](#code-of-conduct)

## Getting Started

**Requirements:**

- [Flutter](https://docs.flutter.dev/get-started/install) (the version pinned in `pubspec.yaml` / the release workflow, e.g. `3.35.6`)
- A code editor with the Flutter / Dart plugins (optional but recommended)
- An [Android device or emulator](https://docs.flutter.dev/get-started/test-drive?tab=androidstudio) (or your platform of choice)

**Clone the repository:**

```sh
git clone https://github.com/bilalsul/rzr.git
cd rzr
```

> The project targets Android as the primary platform. iOS, Linux, macOS, Windows and web builds are also supported by Flutter, but Android is what is released on F-Droid.

**Install dependencies:**

```sh
flutter pub get
```

## Project Layout

```
lib/
  l10n/              # Localization source files (.arb) and generated code
    app_en.arb       # English template (the source of truth for keys)
    app_<locale>.arb # Translations for each language
    generated/       # Generated L10n.dart (do not edit; created by gen-l10n)
  main.dart          # App entry point
  app/               # App shell / navigation
  screens/           # UI screens (home, editor, settings, zip manager, ...)
  services/          # Network, filesystem, initialization services
  utils/             # Logging, error handling, toast, helpers
  widgets/           # Reusable widgets
  models/            # Data models
  data/              # Static data (plugin definitions, ...)
test/                # Unit / widget tests
fastlane/            # Store metadata and screenshots
screens/             # Source screenshots for the store and docs
```

## Running Locally

**Run the app on an emulator or connected device:**

```sh
flutter run
```

To choose a specific device:

```sh
flutter devices
flutter run -d <device-id>
```

**Build a release APK:**

```sh
flutter build apk --release --split-per-abi --target-platform="android-arm"
flutter build apk --release --split-per-abi --target-platform="android-arm64"
flutter build apk --release --split-per-abi --target-platform="android-x64"
```

The APKs are written to `build/app/outputs/flutter-apk/`.

**Common troubleshooting:**

- `flutter pub get` fails or the lockfile complains → run `flutter pub get --enforce-lockfile`.
- A stale build cache causes odd behavior → run `flutter clean` and `flutter pub get` again.
- Your Flutter version differs from the pinned one → install the version in `.github/workflows/release.yml` (`flutter-version`) or update it deliberately.

## Linting & Analysis

The project uses `flutter_lints`. Check for issues before committing:

```sh
flutter analyze
```

There should be **no errors and no warnings**. A few informational lints (`info`) are acceptable, but try to keep the diff clean.

## Translations

RZR is localized with Flutter's built-in localization. The **English template** is `lib/l10n/app_en.arb`; every other file is a translation.

After any change to `.arb` files, regenerate the Dart code:

```sh
flutter gen-l10n
```

This writes to `lib/l10n/generated/L10n.dart` (gitignored, regenerated at build time).

### Adding a New String

1. Open `lib/l10n/app_en.arb`.
2. Add a new key/value pair, e.g.:
   ```json
   "settingsMyNewSetting": "My New Setting",
   ```
3. (Optional, recommended) Add a description that helps translators:
   ```json
   "@settingsMyNewSetting": {
     "description": "Shown in the Settings screen"
   }
   ```
4. Run `flutter gen-l10n` to regenerate the code.
5. Use it in Dart code:
   ```dart
   L10n.of(context).settingsMyNewSetting
   ```
6. Add the **same key** to every other `app_*.arb` file with its translation.

> Keys are auto-named from the English text (see `auto-name-key` in `l10n.yaml`). Keep the pattern `camelCase`, prefixed with the feature area when it makes sense (e.g. `settings`, `home`, `zipManager`).

### Translating a String

1. Open the `.arb` file for your language (e.g. `app_fr.arb` for French).
2. Add the key with the translated value:
   ```json
   "settingsMyNewSetting": "Mon nouveau réglage",
   ```
3. Keep placeholders intact. If the English string contains `{param}`, the translation must contain the same `{param}`:
   ```json
   "importFailed": "Failed to import {name}",
   ```
   →
   ```json
   "importFailed": "Échec de l'importation de {name}",
   ```
4. Preserve formatting markers like `*`, `\n`, and Markdown (e.g. `#` headings) — they are used by the UI.
5. Do not translate the app name or brand terms (`RZR`, `Monaco`, `README`) unless it makes sense in your language.

### Checking Untranslated Strings

After `flutter gen-l10n`, any keys missing from a locale are written to `untranslated_messages.txt` at the repo root.

```sh
flutter gen-l10n
cat untranslated_messages.txt
```

The file lists missing keys per locale, e.g.:

```json
{
  "ar": ["appName"],
  "zh_CN": ["appName"]
}
```

Add the missing keys to the relevant `app_*.arb` files and re-run `flutter gen-l10n` until the file is empty or only contains keys you intentionally leave untranslated (for example `appName`, which is the same everywhere).

> Note: the locale names in `untranslated_messages.txt` use the underscore form (`zh_CN`), while the `.arb` files use the dash form (`app_zh-CN.arb`). They refer to the same locale.

### Adding a New Locale

1. Create `lib/l10n/app_<locale>.arb` (e.g. `app_hi.arb`) with:
   ```json
   {
     "@@locale": "hi",
     ...all keys with translations...
   }
   ```
2. Run `flutter gen-l10n` — the locale is picked up automatically.
3. Verify the locale appears in the app's language picker (the picker is driven by `L10n.supportedLocales`).

> Special locales such as `zh-CN`, `zh-TW`, `zh-LZH` use the dash form in the filename (`app_zh-CN.arb`) and the corresponding BCP-47 tag in `@@locale`.

### Localizing Images & Screenshots

The store listing and README use localized screenshots (`screens/export/` and `screens/export/zh/`). If you update a screenshot with baked-in text, provide the matching localized versions and reference them in `README.md` / `README_zh.md` and the `fastlane/metadata/android/<locale>/` folders.

## Opening a Pull Request

1. **Fork** the repository and create a branch:
   ```sh
   git checkout -b my-change
   ```
2. Make your changes, then run the checks locally:
   ```sh
   flutter pub get
   flutter gen-l10n   # if you touched .arb files
   flutter analyze
   flutter test
   ```
3. Commit with a clear, concise message. Follow the existing style (e.g. `fix: ...`, `feat: ...`, `docs: ...`).
4. Push your branch:
   ```sh
   git push -u origin my-change
   ```
5. Open a pull request against the default branch and describe:
   - what changed and why,
   - how you tested it,
   - screenshots if the change affects the UI.

## Code of Conduct

Be kind and respectful. This is a community project — treat every contributor the way you would like to be treated.
