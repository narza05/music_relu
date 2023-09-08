part of 'details_bloc.dart';

@immutable
abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

abstract class DetailsActionState extends DetailsState {}

class DetailsLoadingState extends DetailsState {}

class DetailsSuccessState extends DetailsState {
  final DetailsModel detailsModel;

  DetailsSuccessState(this.detailsModel);
}

class LyricsCallState extends DetailsState{}

class LyricsLoadingState extends DetailsState {}

class LyricsSuccessState extends DetailsState {
  final String lyrics;

  LyricsSuccessState(this.lyrics);
}
