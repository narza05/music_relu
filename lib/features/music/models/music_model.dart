class MusicModel {
  final int trackId;
  final String trackName;
  final String albumName;
  final String artistName;

  MusicModel(this.trackId, this.trackName, this.albumName, this.artistName);

  Map<String, dynamic> toMap() {
    return {
      'track_id': trackId,
      'track_name': trackName,
      'album_name': albumName,
      'artist_name': artistName,
    };
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(map['track_id'] ?? 0, map['track_name'] ?? "", map['album_name'] ?? "",
        map['artist_name'] ?? "");
  }
}
