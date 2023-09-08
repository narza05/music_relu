part of 'music_bloc.dart';

@immutable
abstract class MusicEvent {}

class MusicInitialFetchEvent extends MusicEvent{}
class TrackClickEvent extends MusicEvent{}
