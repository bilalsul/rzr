**English** | [简体中文](README_zh.md)

<br>

<p align="center">
  <img src="./assets/icons/git-explorer-icon.png" alt="RZR" width="100" style="border: 2px ; border-radius: 25px; padding: 2px;" />
</p>
<h1 align="center">Repo Zip Reader (RZR)</h1>

<p align="center">
  <a href="https://github.com/bilalsul/rzr#platform-support"><img src="https://img.shields.io/badge/platform-%20%20Android-lightgrey" alt="Platforms"></a>
  <a href="https://github.com/bilalsul/rzr/releases/latest"><img src="https://img.shields.io/github/v/release/bilalsul/rzr" alt="Latest Release"></a>
  <a href="https://github.com/bilalsul/rzr/releases"><img src="https://img.shields.io/github/v/release/bilalsul/rzr?include_prereleases" alt="Pre-release"></a>
  <a href="https://github.com/bilalsul/rzr/blob/main/LICENSE"><img src="https://img.shields.io/github/license/bilalsul/rzr" alt="License" ></a>
</p>

A mobile code reader for reading git projects in a code editor. Download source code from GitHub, GitLab or Bitbucket in "owner/repo" format and read it on the go.

![Repo Zip Reader (RZR) Banner](screens/export/store.png)  

<table border="1">
  <tr>
    <th>OS</th>
    <th>Source</th>
  </tr>
  <tr>
    <td>Android</td>
    <td>
    <a href="https://f-droid.org/packages/bilalsul.rzr">
    <img src="https://upload.wikimedia.org/wikipedia/commons/9/96/%22Get_it_on_F-droid%22_Badge.png" alt="Get it on F-droid" height="45">
    <!-- <a href="https://codeberg.org/bws/rzv/releases/latest">
    <img src="https://codeberg.org/Codeberg/GetItOnCodeberg/raw/branch/main/get-it-on-blue-on-white.png" alt="Get it on Codeberg" height="45"> -->
      <a href="https://github.com/bilalsul/rzr/releases/latest">
    <img src="screens/github-badge.png" alt="Download from GitHub" height="45">
    </a>
  </a>
    </td>
  </tr>
</table>
<br>

Explore any Github, Gitlab or Bitbucket repository – just download it as a .zip and open it instantly in a beautiful, read-only code editor.

## Features

- Download GitHub, GitLab and Bitbucket repos as zip with the in-app Zip Manager plugin.
- Read source code in the Monaco editor with support for 100+ programming languages. Customizable with plugins.
- In-app folder/file tree browser for managing extracted zip projects once enabled.
- Read-only code editor with Monaco syntax highlighting (via WebView).
- Instant Markdown preview for READMEs and `.md` files once enabled.
- Rich Settings for managing file explorer and editor options (word wrap, minimap, line numbers, zoom) through the Plugins system.
- Supports English and 13 other languages.
- Optional AI assistant plugin, using user-supplied API keys for OpenAI, Anthropic, and Gemini.

The app uses the INTERNET permission to download repository archives and check for new versions on GitHub. No tracking or analytics.

The AI plugin is not implemented yet and will be added in upcoming versions.

| Imported Projects          | Plugins Manager            |
|----------------------------|----------------------------|
| ![Home Screen](screens/export/projects%20dir.png) | ![Plugins Manager](screens/export/plugin%20manager.png) |

| Markdown Previewer         | Code Editor                |
|----------------------------|----------------------------|
| ![Markdown Previewer](screens/export/markdown.png) | ![Code Editor](screens/export/code%20editor.png) |

| Advanced Options           | Customizable Theme         |
|----------------------------|----------------------------|
| ![Advanced Editor Options](screens/export/advanced%20editor.png) | ![Customizable Theme](screens/export/theme.png) |

| ZIP Manager                |
|----------------------------|
| ![ZIP Manager](screens/export/zip%20manager.png) |

## How to Use

1. Download any repository as `.zip` from GitHub, GitLab, etc.
2. Open **Repo Zip Reader (RZR)**
3. Tap **Import Project** → select your `.zip` file
4. Wait for extraction (progress shown for large projects)
5. Browse, search, and read code offline!

## Privacy & Permissions

- Read our Privacy policy, [view here](https://bilalsul.github.io/rzr/privacy)
- Terms of Use, [view here](https://bilalsul.github.io/rzr/terms)
- The app uses the INTERNET permission to download repository archives and check for new versions on GitHub
- No tracking, no analytics

---

**Repo Zip Reader (RZR)** – View code anywhere, anytime.  

📱 [Get the latest APK release](https://github.com/bilalsul/rzr/releases/latest)

## License

This project is licensed under the [GNU 3.0 License](./LICENSE).

## Contributing

Want to help? See the [Contributing Guide](./CONTRIBUTING.md) for how to set up the project, run it locally, add or translate strings, and open a pull request.

## Thanks

[flutter_monaco](https://github.com/omar-hanafy/flutter_monaco), which is MIT licensed, a flutter plugin for integrating the Monaco Editor (VS Code's editor) into Flutter applications via WebView.

[Anx Reader](https://github.com/Anxcye/anx-reader), MIT licensed Ebook Reader, thanks for the UI inspiration and such a plugin rich reading app. RZR UI is a reflection of this Cool Project.

And many [other open source projects](./pubspec.yaml), thanks to all the authors for their contributions.
