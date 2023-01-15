import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../fields/video_link_field.dart';
import '../collection_screen.dart';
import '../doc_screen.dart';

class VideoCollectionScreen extends CollectionScreen {
  VideoCollectionScreen({
    required super.collection,
    required this.videoField,
    super.title,
  });

  final SQVideoLinkField videoField;

  @override
  docDisplay(doc) => VideoDocDisplay(doc, videoField: videoField).toWidget();
}

class VideoDocDisplay extends DocScreen {
  VideoDocDisplay(super.doc, {required this.videoField});

  final SQVideoLinkField videoField;

  YoutubePlayerController? _controller;

  @override
  void initScreen() {
    super.initScreen();
    final videoFieldValue = doc.getValue<String>(videoField.name);

    if (videoFieldValue == null) return;

    final videoId = YoutubePlayer.convertUrlToId(videoFieldValue);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget screenBody() => Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              Text(doc.label),
              if (_controller != null)
                YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                )
              else
                const Text('No video here')
            ],
          ),
        ),
      );
}
