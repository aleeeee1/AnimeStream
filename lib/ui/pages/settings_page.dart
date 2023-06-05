import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/ui/widgets/link_button.dart';
import 'package:baka_animestream/ui/widgets/settings_fragments/app_update.dart';
import 'package:baka_animestream/ui/widgets/settings_fragments/db_backup_handler.dart';
import 'package:baka_animestream/ui/widgets/settings_fragments/theme_settings.dart';
import 'package:baka_animestream/ui/widgets/settings_fragments/time_handler.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  InternalAPI internalAPI = Get.find<InternalAPI>();

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
                  ThemeSettings(),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  UpdateApp(),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  DbBackup(),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  const TimeHandler(),
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
