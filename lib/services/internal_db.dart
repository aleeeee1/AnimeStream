import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:baka_animestream/objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  Store store;

  ObjectBox._create(this.store) {
    //don't make this growable
  }

  static Future<ObjectBox> create() async {
    final docsDir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getLibraryDirectory();

    final store = await openStore(
      directory: p.join(docsDir.path, "obx"),
      macosApplicationGroup: "AnimeStream",
    );
    return ObjectBox._create(store);
  }
}
