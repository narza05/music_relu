part of 'music_bloc.dart';

@immutable
abstract class MusicState {}

class MusicInitial extends MusicState {}

abstract class MusicActionState extends MusicState {}

class NoInternet extends MusicState {}

class MusicFetchLoadingState extends MusicState {}

class MusicFetchErrorState extends MusicState {}

class MusicFetchSuccessState extends MusicState {
  final List<MusicModel> tracks;

  MusicFetchSuccessState(this.tracks);
}

class TrackClickState extends MusicState {}
