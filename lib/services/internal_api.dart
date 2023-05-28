import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:baka_animestream/helper/models/anime_model.dart';
import 'package:baka_animestream/objectbox.g.dart';
import 'package:baka_animestream/services/internal_db.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:archive/archive.dart';

class InternalAPI {
  late SharedPreferences prefs;
  ObjectBox objBox = Get.find<ObjectBox>();

  late final String dbPath;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();

    final docsDir = await getApplicationDocumentsDirectory();
    dbPath = p.join(docsDir.path, "obx-example");
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
    try {
      var encoder = ZipFileEncoder();
      encoder.zipDirectory(
        Directory(dbPath),
        filename: '/sdcard/Documents/obx.zip',
      );
      return 0;
    } catch (e) {
      return 1;
    }
  }

  importDb(String backupPath) async {
    try {
      var bytes = File(backupPath).readAsBytesSync();
      var archive = ZipDecoder().decodeBytes(bytes);

      for (var file in archive) {
        var filename = file.name;
        var data = file.content as List<int>;

        File(p.join(dbPath, filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }

      return 0;
    } catch (e) {
      if (kDebugMode) print(e);
      return 1;
    }
  }
}
