import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class InternalAPI {
  late SharedPreferences prefs;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  String getFakeServer() {
    return prefs.getString('fakeServer') ??
        'https://d3df-79-40-231-54.ngrok-free.app';
  }

  Future<void> setFakeServer(String value) async {
    await prefs.setString('fakeServer', value);
  }

  bool getDarkThemeStatus() {
    return prefs.getBool('darkTheme') ?? false;
  }

  bool getDynamicThemeStatus() {
    return prefs.getBool('dynamicTheme') ?? false;
  }

  Future<void> setDarkThemeStatus(bool value) async {
    await prefs.setBool('darkTheme', value);
  }

  Future<void> setDynamicThemeStatus(bool value) async {
    await prefs.setBool('dynamicTheme', value);
  }

  Future<String> getVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

  void setWaitTime(int parse) {
    prefs.setInt('waitTime', parse);
  }

  int getWaitTime() {
    return prefs.getInt('waitTime') ?? 2;
  }

  void setKeyValue(String key, String value) {
    prefs.setString(key, value);
  }

  String getKeyValue(String key) {
    return prefs.getString(key) ?? '';
  }

  Future<int> exportDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = p.join(docsDir.path, "obx-example", "data.mdb");

    var file = File(path);
    if (file.existsSync()) {
      var dir =
          await getExternalStorageDirectories(type: StorageDirectory.documents);
      await file.copy('$dir/data.mdb');
      return 0;
    } else {
      return 1;
    }
  }

  importDb(String dbPath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = p.join(docsDir.path, "obx-example", "data.mdb");

    var file = File(dbPath);
    if (file.existsSync()) {
      file.copy(path);
    }
  }
}
