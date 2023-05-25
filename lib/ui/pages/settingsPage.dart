import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/ui/widgets/link_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:baka_animestream/ui/theme/theme_manager.dart' as theme_manager;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  InternalAPI internalAPI = Get.find<InternalAPI>();

  TextEditingController waitController = TextEditingController();

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
  void initState() {
    waitController.text = internalAPI.getWaitTime().toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Impostazioni",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "Roboto",
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SwitchListTile(
                    title: const Text(
                      "Dark Mode",
                    ),
                    subtitle: const Text("Metti la Dark Mode bro"),
                    value: theme_manager.getDarkThemeStatus(),
                    onChanged: (value) => setDarkTheme(value),
                  ),
                  FutureBuilder(
                    future: shouldBeVisible(),
                    builder: (context, snapshot) => Visibility(
                      visible: snapshot.data ?? false,
                      child: SwitchListTile(
                        title: const Text(
                          "Dynamic Colors",
                        ),
                        subtitle: const Text("Metti i colori dinamici bro"),
                        value: theme_manager.getDynamicThemeStatus(),
                        onChanged: (value) => setDynamicTheme(value),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            17,
                            0,
                            12,
                            0,
                          ),
                          child: TextField(
                            controller: waitController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: "Tempo di caricamento (s)",
                              hintText: "Tempo che dai per caricare",
                              // border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 17,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            internalAPI.setWaitTime(
                              int.tryParse(waitController.text) ?? 0,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: const Text("Salva"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: internalAPI.getVersion(),
                builder: (ctx, snapshot) => LinkButton(
                  urlLabel: "v${snapshot.data ?? "0.0.0"}",
                  url: "https://github.com/aleeeee1",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
