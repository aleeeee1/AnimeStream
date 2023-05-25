import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class AnimeModel {
  @Id(assignable: true)
  int? id;

  String? title;
  String? imageUrl;

  Map<dynamic, dynamic> episodes = {};
  String episodeStr = "{}";

  DateTime? lastSeenDate;
  int? lastSeenEpisodeIndex;

  encodeStr() {
    episodeStr = jsonEncode(episodes);
  }

  decodeStr() {
    episodes = jsonDecode(episodeStr);
  }
}
