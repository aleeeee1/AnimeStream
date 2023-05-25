import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
}
