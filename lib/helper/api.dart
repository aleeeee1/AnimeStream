import 'package:baka_animestream/helper/classes/anime_obj.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:async';
import 'dart:convert';
import 'package:baka_animestream/helper/models/anime_model.dart';
import 'package:baka_animestream/objectbox.g.dart';
import 'package:baka_animestream/services/internal_db.dart';
import 'package:get/get.dart';

Box objBox = Get.find<ObjectBox>().store.box<AnimeModel>();

Future<List> latestAnime() async {
  var url = Uri.parse("https://animeunity.tv/");
  var response = await http.get(url, headers: {"Accept": "application/json"});
  var document = parse(response.body);
  var bo =
      document.getElementsByTagName('layout-items')[0].attributes['items-json'];
  var json = jsonDecode(bo!);
  return json['data'];
}

Future<List> popularAnime() async {
  var url = Uri.parse("https://www.animeunity.tv/top-anime?popular=true");
  var response = await http.get(url, headers: {"Accept": "application/json"});
  var document = parse(response.body);
  var bo = document.getElementsByTagName('top-anime')[0].attributes['animes'];
  var json = jsonDecode(bo!);
  return json['data'];
}

Future<List> searchAnime({String title = ""}) async {
  var url = Uri.parse("https://animeunity.it/archivio?title=$title");
  var response = await http.get(url, headers: {"Accept": "application/json"});
  var document = parse(response.body);
  var bo = document.getElementsByTagName('archivio')[0].attributes['records'];
  var json = jsonDecode(bo!);
  return json;
}

Future<List> toContinueAnime() {
  List<AnimeModel> animes = objBox.getAll() as List<AnimeModel>;
  animes.sort((a, b) {
    if (a.lastSeenDate == null) {
      return 1;
    } else if (b.lastSeenDate == null) {
      return -1;
    } else {
      return a.lastSeenDate!.millisecondsSinceEpoch >
              b.lastSeenDate!.millisecondsSinceEpoch
          ? -1
          : 1;
    }
  });

  return Future.value(animes);
}

AnimeModel fetchAnimeModel(AnimeClass anime) {
  AnimeModel? tmp = objBox.get(anime.id);
  AnimeModel toPut = anime.toModel;
  AnimeModel animeModel;

  if (tmp != null) {
    toPut = tmp;
  }

  animeModel = toPut;
  animeModel.decodeStr();

  return animeModel;
}
