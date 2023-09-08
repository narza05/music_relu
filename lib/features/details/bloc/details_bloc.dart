import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_relu/features/details/models/details_model.dart';

import '../repository/detail_repo.dart';

part 'details_event.dart';

part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc() : super(DetailsInitial()) {
    on<DetailFetchEvent>(detailFetchEvent);
    on<LyricsFetchEvent>(lyricsFetchEvent);
  }

  FutureOr<void> detailFetchEvent(
      DetailFetchEvent event, Emitter<DetailsState> emit) async {
    emit(DetailsLoadingState());
    final DetailsModel = await DetailRepo.fetchDetail(event.trackId);
    emit(DetailsSuccessState(DetailsModel));
  }

  FutureOr<void> lyricsFetchEvent(
      LyricsFetchEvent event, Emitter<DetailsState> emit) async {
    emit(LyricsLoadingState());
    final String lyrics = await DetailRepo.fetchLyrics(event.trackId);
    emit(LyricsSuccessState(lyrics));
    // emit(LyricsCallState());
  }
}
