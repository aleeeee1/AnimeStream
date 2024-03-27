import 'package:animestream/helper/classes/anime_obj.dart';
import 'package:animestream/services/internal_api.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:async';
import 'dart:convert';
import 'package:animestream/helper/models/anime_model.dart';
import 'package:animestream/objectbox.g.dart';
import 'package:animestream/services/internal_db.dart';
import 'package:get/get.dart';

Box objBox = Get.find<ObjectBox>().store.box<AnimeModel>();
InternalAPI internalAPI = Get.find<InternalAPI>();

Future<Document> makeRequestAndGetDocument(String url) async {
  var response = await http.get(
    Uri.parse(url),
    headers: {"Accept": "application/json"},
  );
  return parse(response.body);
}

Future<List<Element>> getElements(
  String tagName, {
  int maxTry = 10,
  required String url,
}) async {
  Document document = await makeRequestAndGetDocument(url);
  List<Element> elements = document.getElementsByTagName(tagName);
  int i = 0;
  while (elements.isEmpty && i < maxTry) {
    document = await makeRequestAndGetDocument(url);
    elements = document.getElementsByTagName(tagName);
    i++;
  }
  return elements;
}

Future<List> latestAnime() async {
  List<Element> elements = await getElements(
    'layout-items',
    url: "https://animeunity.it/",
  );

  if (elements.isEmpty) {
    throw Exception("No elements found");
  }

  var data = elements[0].attributes['items-json'];
  var json = jsonDecode(data!);
  return json['data'];
}

Future<List> popularAnime() async {
  List<Element> elements = await getElements(
    'top-anime',
    url: "https://www.animeunity.it/top-anime?popular=true",
  );

  if (elements.isEmpty) {
    return [];
  }

  var data = elements[0].attributes['animes'];
  var json = jsonDecode(data!);
  return json['data'];
}

Future<List> searchAnime({String title = ""}) async {
  List<Element> elements = await getElements(
    'archivio',
    url: "https://animeunity.it/archivio?title=$title",
  );

  if (elements.isEmpty) {
    return [];
  }

  var data = elements[0].attributes['records'];
  var json = jsonDecode(data!);
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
      return a.lastSeenDate!.millisecondsSinceEpoch > b.lastSeenDate!.millisecondsSinceEpoch ? -1 : 1;
    }
  });

  return Future.value(animes);
}

AnimeModel fetchAnimeModel(AnimeClass anime) {
  AnimeModel? tmp = objBox.get(anime.id);
  AnimeModel toPut = anime.toModel;

  if (tmp != null) {
    toPut = tmp;
  }

  toPut.decodeStr();

  return toPut;
}

Future<String> getLatestVersionUrl(version) async {
  String url = "${internalAPI.repoLink}/releases/download/$version/app-release.apk";

  return url;
}

Future<String> getLatestVersion() async {
  var url = Uri.parse(
    "${internalAPI.repoLink}/releases/latest",
  );

  try {
    var response = await http.get(url);
    var document = parse(response.body);

    var release = document.getElementsByTagName('h1').firstWhere((element) => element.text.startsWith("Release"));

    var version = release.text.replaceAll("Release ", "");
    // version = version.substring(0, version.indexOf("+"));

    return version;
  } catch (e) {
    return "";
  }
}

void eraseDb() {
  objBox.removeAll();
}

Future<String> getPublicIpAddress() async {
  var url = Uri.parse("https://ifconfig.io/ip");
  try {
    var response = await http.get(url);
    return response.body.replaceAll("\n", "");
  } catch (e) {
    return "";
  }
}
