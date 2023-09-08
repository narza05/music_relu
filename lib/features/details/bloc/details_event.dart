part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent {}

class DetailFetchEvent extends DetailsEvent {
  final int trackId;

  DetailFetchEvent(this.trackId);
}

class LyricsFetchEvent extends DetailsEvent {
  final int trackId;

  LyricsFetchEvent(this.trackId);
}
