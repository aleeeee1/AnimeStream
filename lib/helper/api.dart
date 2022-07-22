import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:async';
import 'dart:convert';

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

Future<List> searchAnime(String title) async {
  var url = Uri.parse("https://animeunity.it/archivio?title=$title");
  var response = await http.get(url, headers: {"Accept": "application/json"});
  var document = parse(response.body);
  var bo = document.getElementsByTagName('archivio')[0].attributes['records'];
  var json = jsonDecode(bo!);
  return json;
}
