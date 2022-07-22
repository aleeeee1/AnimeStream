class AnimeObj {
  String title;
  String imageUrl;
  int id;
  String description;
  List episodes;
  String status;
  List genres;
  int episodesCount;
  String slug;
  AnimeObj({
    required this.title,
    required this.imageUrl,
    required this.id,
    required this.description,
    required this.episodes,
    required this.status,
    required this.genres,
    required this.episodesCount,
    required this.slug,
  });
}

AnimeObj searchToObj(dynamic json) {
  return AnimeObj(
      title: json['title'],
      imageUrl: json['imageurl'],
      id: json['id'],
      description: json['plot'], //archivio
      episodes: json['episodes'],
      status: json['status'],
      genres: json['genres'],
      episodesCount: json['episodes_count'] ?? 0,
      slug: json['slug']);
}

AnimeObj popularToObj(dynamic json) {
  return AnimeObj(
      title: json['title'],
      imageUrl: json['imageurl'],
      id: json['id'],
      description: json['plot'], //popolari
      episodes: [],
      status: json['status'],
      genres: [],
      episodesCount: json['episodes_count'] ?? 0,
      slug: json['slug']);
}

AnimeObj latestToObj(dynamic json) {
  return AnimeObj(
      title: json["anime"]['title'],
      imageUrl: json["anime"]['imageurl'],
      id: json['anime']['id'],
      description: json["anime"]['plot'], //ultimi usciti
      episodes: [json['link']],
      status: json["anime"]['status'],
      genres: [],
      episodesCount: json["anime"]['episodes_count'] ?? 0,
      slug: json["anime"]['slug']);
}
