import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

import 'package:baka_animestream/services/internal_api.dart';

InternalAPI internalAPI = Get.find<InternalAPI>();

Future<void> setUseDynamicTheme(BuildContext context, bool value) async {
  internalAPI.setDynamicThemeStatus(value);

  final int currentTheme = DynamicTheme.of(context)!.themeId;
  if (currentTheme.isEven) {
    await DynamicTheme.of(context)!.setTheme(value ? 2 : 0);
  } else {
    await DynamicTheme.of(context)!.setTheme(value ? 3 : 1);
  }
}

Future<void> setUseDarkTheme(BuildContext context, bool value) async {
  internalAPI.setDarkThemeStatus(value);

  final int currentTheme = DynamicTheme.of(context)!.themeId;
  if (currentTheme < 2) {
    await DynamicTheme.of(context)!.setTheme(value ? 1 : 0);
  } else {
    await DynamicTheme.of(context)!.setTheme(value ? 3 : 2);
  }
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarIconBrightness:
          value ? Brightness.light : Brightness.dark,
    ),
  );
}

bool getDarkThemeStatus() {
  return internalAPI.getDarkThemeStatus();
}

bool getDynamicThemeStatus() {
  return internalAPI.getDynamicThemeStatus();
}

Future<bool> shouldBeVisible() async {
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 31;
  }
  return false;
}
