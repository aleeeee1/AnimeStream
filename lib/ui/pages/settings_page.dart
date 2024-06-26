import 'package:animestream/services/internal_api.dart';
import 'package:animestream/ui/widgets/link_button.dart';
import 'package:animestream/ui/widgets/settings_fragments/app_update.dart';
import 'package:animestream/ui/widgets/settings_fragments/db_backup_handler.dart';
import 'package:animestream/ui/widgets/settings_fragments/theme_settings.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final InternalAPI internalAPI = Get.find<InternalAPI>();

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
                  const ThemeSettings(),
                  const Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  UpdateApp(),
                  const Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  DbBackup(),
                  const Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  // const TimeHandler(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: internalAPI.getVersion(),
                builder: (ctx, snapshot) => LinkButton(
                  urlLabel: "v${snapshot.data ?? "0.0.0"}",
                  url: internalAPI.repoLink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
