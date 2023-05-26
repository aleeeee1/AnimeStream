import 'package:baka_animestream/helper/api.dart';
import 'package:baka_animestream/services/internal_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ota_update/ota_update.dart';

class UpdateApp extends StatefulWidget {
  const UpdateApp({super.key});

  @override
  State<UpdateApp> createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  InternalAPI internalAPI = Get.find<InternalAPI>();

  beginUpdate(version) async {
    var url = await getLatestVersionUrl(version);
    print(url);

    try {
      OtaUpdate().execute(url);
    } catch (e) {
      Fluttertoast.showToast(msg: "Errore durante l'aggiornamento");
    }
  }

  checkUpdate() async {
    Fluttertoast.showToast(msg: "Controllo aggiornamenti...");

    String latest = await getLatestVersion();
    String current = await internalAPI.getVersion();

    if (latest.isEmpty) {
      Fluttertoast.showToast(
        msg: "Errore durante il controllo degli aggiornamenti",
      );
      return;
    }

    if (latest == current) {
      Fluttertoast.showToast(msg: "L'app è già aggiornata :D");
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text("Aggiornamento disponibile"),
          content: const Text(
            "È disponibile un aggiornamento per l'app, vuoi aggiornare?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Annulla"),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                Fluttertoast.showToast(msg: "Download in corso...");
                await beginUpdate(latest);
              },
              child: const Text("Aggiorna"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // tile with button
    return ListTile(
      title: Text(
        "Aggiorna l'app",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 16,
          fontFamily: "Roboto",
        ),
      ),
      subtitle: Text(
        "Aggiorna l'app all'ultima versione disponibile",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 13,
          fontFamily: "Roboto",
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          checkUpdate();
        },
        child: const Text(
          "Aggiorna",
          style: TextStyle(
            fontFamily: "Roboto",
          ),
        ),
      ),
    );
  }
}
