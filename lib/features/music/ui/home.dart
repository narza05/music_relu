import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_relu/core/network/network_bloc.dart';
import 'package:music_relu/features/details/bloc/details_bloc.dart';
import 'package:music_relu/features/music/bloc/music_bloc.dart';

import '../../details/ui/details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MusicBloc musicBloc = MusicBloc();

  @override
  void initState() {
    musicBloc.add(MusicInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MusicBloc(),
              ),
              BlocProvider(
                create: (context) => NetworkBloc(),
              )
            ],
            child: Stack(
              children: [
                BlocListener<NetworkBloc, NetworkState>(
                    child: Container(),
                    bloc: NetworkBloc(),
                    listener: (context, state) {
                      if (state is ConnectedState) {
                        print("Online");
                        musicBloc.add(MusicInitialFetchEvent());
                      } else if (state is NotConnectedState) {
                        print("Offline");
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.msg)));
                      }
                    }),
                BlocBuilder<MusicBloc, MusicState>(
                    bloc: musicBloc,
                    builder: (context, state) {
                      if (state is MusicFetchLoadingState) {
                        return SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()));
                      } else if (state is MusicFetchSuccessState) {
                        final details = state;
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.tracks.length,
                            itemBuilder: (context, position) {
                              return GestureDetector(
                                onTap: () {
// musicBloc.add(TrackClickEvent());
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Details(
                                        state.tracks[position].trackId);
                                  }));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Icon(Icons.music_note)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.tracks[position].trackName,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              state.tracks[position].albumName,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            state.tracks[position].artistName,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    }),
              ],
            )));
  }
}
