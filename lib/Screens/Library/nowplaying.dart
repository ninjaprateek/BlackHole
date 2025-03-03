import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playbackState = snapshot.data;
                  final processingState = playbackState?.processingState;
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: processingState != AudioProcessingState.idle
                        ? null
                        : AppBar(
                            title: const Text('Now Playing'),
                            centerTitle: true,
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.transparent
                                    : Theme.of(context).colorScheme.secondary,
                            elevation: 0,
                          ),
                    body: processingState == AudioProcessingState.idle
                        ? EmptyScreen().emptyScreen(context, 3, 'Nothing is ',
                            18.0, 'PLAYING', 60, 'Go and Play Something', 23.0)
                        : StreamBuilder<MediaItem?>(
                            stream: audioHandler.mediaItem,
                            builder: (context, snapshot) {
                              final mediaItem = snapshot.data;
                              return mediaItem == null
                                  ? const SizedBox()
                                  : CustomScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      slivers: [
                                          SliverAppBar(
                                            elevation: 0,
                                            stretch: true,
                                            pinned: true,
                                            // floating: true,
                                            expandedHeight:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                            flexibleSpace: FlexibleSpaceBar(
                                              title: const Text(
                                                'Now Playing',
                                                textAlign: TextAlign.center,
                                              ),
                                              centerTitle: true,
                                              background: ShaderMask(
                                                  shaderCallback: (rect) {
                                                    return const LinearGradient(
                                                      begin: Alignment.center,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.black,
                                                        Colors.transparent
                                                      ],
                                                    ).createShader(
                                                        Rect.fromLTRB(
                                                            0,
                                                            0,
                                                            rect.width,
                                                            rect.height));
                                                  },
                                                  blendMode: BlendMode.dstIn,
                                                  child: mediaItem.artUri!
                                                          .toString()
                                                          .startsWith('file:')
                                                      ? Image(
                                                          image: FileImage(File(
                                                              mediaItem.artUri!
                                                                  .toFilePath())),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          errorWidget:
                                                              (BuildContext
                                                                          context,
                                                                      _,
                                                                      __) =>
                                                                  const Image(
                                                                    image: AssetImage(
                                                                        'assets/cover.jpg'),
                                                                  ),
                                                          placeholder:
                                                              (BuildContext
                                                                          context,
                                                                      _) =>
                                                                  const Image(
                                                                    image: AssetImage(
                                                                        'assets/cover.jpg'),
                                                                  ),
                                                          imageUrl: mediaItem
                                                              .artUri!
                                                              .toString())),
                                            ),
                                          ),
                                          SliverList(
                                              delegate:
                                                  SliverChildListDelegate([
                                            NowPlayingStream(
                                              audioHandler,
                                              hideHeader: true,
                                            )
                                          ])),
                                        ]);
                            },
                          ),
                  );
                }),
          ),
          MiniPlayer(),
        ],
      ),
    );
  }
}
