import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../data/fields/video_link_field.dart';
import '../../data/sq_doc.dart';
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
  Widget docDisplay(SQDoc doc, ScreenState screenState) =>
      VideoDocDisplay(doc, videoField: videoField);
}

class VideoDocDisplay extends DocScreen {
  VideoDocDisplay(super.doc, {required this.videoField, super.isInline});

  final SQVideoLinkField videoField;

  @override
  State<VideoDocDisplay> createState() => _VideoDocDisplayState();
}

class _VideoDocDisplayState extends ScreenState<VideoDocDisplay> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    final videoFieldValue = widget.doc.getValue<String>(widget.videoField.name);

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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              Text(widget.doc.label),
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
