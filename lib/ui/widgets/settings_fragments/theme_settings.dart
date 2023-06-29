import 'package:baka_animestream/services/internal_api.dart';
import 'package:flutter/material.dart';
import 'package:baka_animestream/ui/theme/theme_manager.dart' as theme_manager;
import 'package:get/get.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  InternalAPI internalAPI = Get.find<InternalAPI>();

  void setDarkTheme(bool value) {
    theme_manager.setUseDarkTheme(context, value);
    setState(() {});
  }

  void setDynamicTheme(bool value) {
    theme_manager.setUseDynamicTheme(context, value);
    setState(() {});
  }

  Future<bool> shouldBeVisible() async {
    return await theme_manager.shouldBeVisible();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text(
            "Dark Mode",
          ),
          subtitle: const Text("Attiva la Dark Mode"),
          value: theme_manager.getDarkThemeStatus(),
          onChanged: (value) => setDarkTheme(
            value,
          ),
        ),
        FutureBuilder(
          future: shouldBeVisible(),
          builder: (context, snapshot) => Visibility(
            visible: snapshot.data ?? false,
            child: SwitchListTile(
              title: const Text(
                "Dynamic Colors",
              ),
              subtitle: const Text("Attiva i colori dinamici"),
              value: theme_manager.getDynamicThemeStatus(),
              onChanged: (value) => setDynamicTheme(
                value,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
