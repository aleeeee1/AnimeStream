import 'package:baka_animestream/objectbox.g.dart';
import 'package:baka_animestream/services/internal_api.dart';
import 'package:baka_animestream/services/internal_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:restart_app/restart_app.dart';
import 'package:permission_handler/permission_handler.dart';

class DbBackup extends StatefulWidget {
  const DbBackup({super.key});

  @override
  State<DbBackup> createState() => _DbBackupState();
}

class _DbBackupState extends State<DbBackup> {
  final Store objBox = Get.find<ObjectBox>().store;

  final InternalAPI internalAPI = Get.find<InternalAPI>();

  checkPermissions() async {
    await Permission.storage.request();
    if (!await Permission.storage.isGranted) {
      Get.snackbar(
        "Permessi mancanti",
        "Per poter esportare il database è necessario fornire i permessi di scrittura",
        snackPosition: SnackPosition.BOTTOM,
        barBlur: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        colorText: Theme.of(context).colorScheme.onSecondary,
      );
      return 0;
    }
    return 1;
  }

  exportDb() async {
    if (await checkPermissions() == 0) return;

    int res = await internalAPI.exportDb();
    if (res == 0) {
      Get.snackbar(
        "Esportazione completata",
        "Il database è stato esportato correttamente nella cartella dei Documenti",
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED,
        barBlur: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        colorText: Theme.of(context).colorScheme.onSecondary,
      );
    } else {
      Get.snackbar(
        "Errore",
        "Si è verificato un errore durante l'esportazione del database",
        snackPosition: SnackPosition.BOTTOM,
        barBlur: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        colorText: Theme.of(context).colorScheme.onSecondary,
      );
    }
  }

  importDb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["mdb"],
    );

    if (result != null) {
      await internalAPI.importDb(result.files.single.path!);
      Restart.restartApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    // make two tile, one for export database, one for import database
    return Column(
      children: const [
        ListTile(
          title: Text("Esporta database"),
          subtitle: Text("Esporta il database in un file"),
          onTap: null,
        ),
        ListTile(
          title: Text("Importa database"),
          subtitle: Text("Importa il database da un file"),
          onTap: null,
        ),
      ],
    );
  }
}
