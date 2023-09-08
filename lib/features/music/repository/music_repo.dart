import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:music_relu/core/constants.dart';

import '../bloc/music_bloc.dart';
import '../models/music_model.dart';

class MusicRepo {
  static fetchMusic() async {
    List<MusicModel> tracks = [];
    try {
      var response = await http.get(Uri.parse(
          "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=${Constants().apiKey}"));
      var json = jsonDecode(response.body);
      print(json["message"]["body"]["track_list"].length);
      for (int i = 0; i < json["message"]["body"]["track_list"].length; i++) {
        tracks.add(MusicModel.fromMap(
            json["message"]["body"]["track_list"][i]['track']));
      }
      return tracks;
    } catch (e) {
      log(e.toString());
    }
  }
}
