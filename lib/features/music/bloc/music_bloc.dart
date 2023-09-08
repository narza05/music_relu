import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_relu/core/constants.dart';
import 'package:music_relu/features/music/models/music_model.dart';
import 'package:music_relu/features/music/repository/music_repo.dart';

part 'music_event.dart';

part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicInitial()) {
    on<MusicInitialFetchEvent>(musicInitialFetchEvent);
    on<TrackClickEvent>(trackClickEvent);
  }

  FutureOr<void> musicInitialFetchEvent(
      MusicInitialFetchEvent event, Emitter<MusicState> emit) async {
    emit(MusicFetchLoadingState());
    List<MusicModel> tracks = await MusicRepo.fetchMusic();
    emit(MusicFetchSuccessState(tracks));
  }

  FutureOr<void> trackClickEvent(
      TrackClickEvent event, Emitter<MusicState> emit) {
    emit(TrackClickState());
  }
}
