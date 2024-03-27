import 'package:animestream/helper/api.dart';
import 'package:animestream/objectbox.g.dart';
import 'package:animestream/services/internal_api.dart';
import 'package:animestream/services/internal_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DbBackup extends StatelessWidget {
  DbBackup({super.key});

  final Store objBox = Get.find<ObjectBox>().store;

  final InternalAPI internalAPI = Get.find<InternalAPI>();

  checkPermissions(context) async {
    PermissionStatus status = await Permission.storage.request();
    PermissionStatus a = await Permission.manageExternalStorage.request();
    if (!a.isGranted && !status.isGranted) {
      Get.snackbar(
        "Permessi mancanti",
        "Per poter esportare il database è necessario fornire i permessi di scrittura",
        snackPosition: SnackPosition.BOTTOM,
        barBlur: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onTap: (_) => openAppSettings(),
        colorText: Theme.of(context).colorScheme.onSecondary,
      );
      return 0;
    }
    return 1;
  }

  exportDb(context) async {
    if (await checkPermissions(context) == 0) return;

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
      allowedExtensions: ["zip"],
    );

    if (result != null) {
      await internalAPI.importDb(result.paths.first!);
      // Restart.restartApp();
    }
  }

  resetDb() {
    Get.defaultDialog(
      title: "Attenzione",
      middleText: "Sei sicuro di voler ripristinare il database allo stato iniziale?",
      textConfirm: "Si",
      textCancel: "No",
      onConfirm: () async {
        eraseDb();
        Get.back();
        // Restart.restartApp();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // make two tile, one for export database, one for import database
    return Column(
      children: [
        ListTile(
          title: const Text("Esporta database"),
          subtitle: const Text("Esporta il database in un file"),
          onTap: () => exportDb(context),
        ),
        ListTile(
          title: const Text("Importa database"),
          subtitle: const Text("Importa il database da un file"),
          onTap: importDb,
        ),
        ListTile(
          title: const Text("Ripristina database"),
          subtitle: const Text("Ripristina il database allo stato iniziale"),
          onTap: resetDb,
        )
      ],
    );
  }
}
