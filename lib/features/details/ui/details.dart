import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_relu/core/network/network_bloc.dart';
import 'package:music_relu/features/details/bloc/details_bloc.dart';

class Details extends StatefulWidget {
  int trackId;

  Details(this.trackId);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DetailsBloc detailsBloc1 = DetailsBloc();
  DetailsBloc detailsBloc2 = DetailsBloc();
  late StreamSubscription subscription;

  @override
  void initState() {
    detailsBloc1.add(DetailFetchEvent(widget.trackId));
    detailsBloc2.add(LyricsFetchEvent(widget.trackId));
    getConnectivity();
    super.initState();
  }

  getConnectivity() async {
    subscription =
        await Connectivity().onConnectivityChanged.listen((event) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile) {
      } else if (connectivityResult == ConnectivityResult.wifi) {
      } else if (connectivityResult == ConnectivityResult.none) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => DetailsBloc(),
            ),
            BlocProvider(
              create: (context) => NetworkBloc(),
            )
          ],
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocListener<NetworkBloc, NetworkState>(
                    child: Container(),
                    bloc: NetworkBloc(),
                    listener: (context, state) {
                      if (state is ConnectedState) {
                        print("Online");
                        detailsBloc1.add(DetailFetchEvent(widget.trackId));
                        detailsBloc2.add(LyricsFetchEvent(widget.trackId));
                      } else if (state is NotConnectedState) {
                        print("Offline");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.msg)));
                      }
                    }),
                BlocBuilder<DetailsBloc, DetailsState>(
                    bloc: detailsBloc1,
                    builder: (context, state) {
                      if (state is DetailsLoadingState) {
                        return SizedBox(
                            height: 100,
                            child:
                                Center(child: CircularProgressIndicator()));
                      } else if (state is DetailsSuccessState) {
                        final details = state as DetailsSuccessState;
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(45),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(Icons.music_note)),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            details.detailsModel.trackName,
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            details.detailsModel.artistName,
                                            maxLines: 1,
                                            style: TextStyle(
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            details.detailsModel.albumName,
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Rating: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                details.detailsModel.rating,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                BlocBuilder<DetailsBloc, DetailsState>(
                    bloc: detailsBloc2,
                    builder: (context, state) {
                      if (state is LyricsLoadingState) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is LyricsSuccessState) {
                        final lyrics = state as LyricsSuccessState;
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lyrics",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                lyrics.lyrics,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          )),
    );
  }
}

class Lyrics extends StatefulWidget {
  const Lyrics({super.key});

  @override
  State<Lyrics> createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  DetailsBloc detailsBloc = DetailsBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: detailsBloc,
        builder: (context, state) {
          switch (state.runtimeType) {
            case LyricsSuccessState:
              final lyrics = state as LyricsSuccessState;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lyrics",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    Text(
                      lyrics.lyrics,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    )
                  ],
                ),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }
}
