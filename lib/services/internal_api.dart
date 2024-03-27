import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:animestream/services/internal_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as p_provider;

class InternalAPI {
  late SharedPreferences prefs;
  ObjectBox objBox = Get.find<ObjectBox>();

  late final String dbPath;
  late final String dbBackupPath;

  final String repoLink = "https://github.com/aleeeee1/AnimeStream";

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();

    final docsDir = Platform.isAndroid ? await p_provider.getApplicationDocumentsDirectory() : await p_provider.getLibraryDirectory();

    dbPath = p.join(docsDir.path, "obx");
    dbBackupPath = p.join(docsDir.path, "obx-backup");
  }

  String getFakeServer() {
    return prefs.getString('fakeServer') ?? '';
  }

  Future<void> setFakeServer(String value) async {
    await prefs.setString('fakeServer', value);
  }

  bool getDarkThemeStatus() {
    return prefs.getBool('darkTheme') ?? ThemeMode.system == ThemeMode.dark;
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
    String path = "/sdcard/Documents/obx.zip";
    if (Platform.isIOS) {
      var dir = await p_provider.getApplicationDocumentsDirectory();

      path = p.join(dir.path, "obx.zip");
      debugPrint(path);
    }

    try {
      var encoder = ZipFileEncoder();
      encoder.zipDirectory(
        Directory(dbPath),
        filename: path,
      );
      return 0;
    } catch (e) {
      if (kDebugMode) rethrow;
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
      if (kDebugMode) rethrow;
      return 1;
    }
  }
}
