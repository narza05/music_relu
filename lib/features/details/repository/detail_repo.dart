import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:music_relu/features/details/models/details_model.dart';

import '../../../core/constants.dart';

class DetailRepo {
  static Future<DetailsModel> fetchDetail(int trackId) async {
    DetailsModel model;
    try {
      var response = await http.get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/track.get?track_id=${trackId.toString()}&apikey=${Constants().apiKey}"));
      var json = jsonDecode(response.body);
      model = DetailsModel(
          json["message"]["body"]["track"]["track_name"],
          json["message"]["body"]["track"]["album_name"],
          json["message"]["body"]["track"]["artist_name"],
          json["message"]["body"]["track"]["track_rating"].toString());
      print(model.artistName);
      return model;
    } catch (e) {
      log(e.toString());
      return DetailsModel("", "", "", "");
    }
  }

  static Future<String> fetchLyrics(int trackId) async {
    String lyrics;
    try {
      var response = await http.get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${trackId.toString()}&apikey=${Constants().apiKey}"));
      var json = jsonDecode(response.body);
      lyrics = json["message"]["body"]["lyrics"]["lyrics_body"];
      print(lyrics);
      return lyrics;
    } catch (e) {
      log(e.toString());
      return "";
    }
  }
}
