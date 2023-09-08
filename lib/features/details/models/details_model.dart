class DetailsModel{
  final String trackName;
  final String albumName;
  final String artistName;
  final String rating;

  DetailsModel(this.trackName, this.albumName, this.artistName, this.rating);

  factory DetailsModel.fromJson(Map<String,dynamic> map){
    return DetailsModel(map['track_name'],map['artist'],map['track_name'],map['track_name']);
  }

}