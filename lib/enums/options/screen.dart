enum Screen {
  home,
  editor,
  fileExplorer,
  settings,
  zipManager
}

// convert Screen enum to string
String screenToString(Screen screen) {
  switch (screen) {
    case Screen.home:
      return 'home';
    case Screen.editor:
      return 'editor';
    case Screen.fileExplorer:
      return 'file_explorer';
    case Screen.settings:
      return 'settings';
    case Screen.zipManager:
      return 'zip_manager';
  }
}