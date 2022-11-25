import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../data/fields/sq_video_link_field.dart';
import '../../data/sq_doc.dart';
import '../collection_screen.dart';
import '../doc_screen.dart';

class VideoCollectionScreen extends CollectionScreen {
  final SQVideoLinkField videoField;

  VideoCollectionScreen({
    required super.collection,
    required this.videoField,
    super.title,
  });

  @override
  Widget docDisplay(SQDoc doc, ScreenState screenState) {
    return VideoDocDisplay(doc, videoField: videoField);
  }
}

class VideoDocDisplay extends DocScreen {
  final SQVideoLinkField videoField;

  VideoDocDisplay(super.doc, {required this.videoField, super.isInline});

  @override
  State<VideoDocDisplay> createState() => _VideoDocDisplayState();
}

class _VideoDocDisplayState extends ScreenState<VideoDocDisplay> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    final videoFieldValue = widget.doc.value<String>(widget.videoField.name);

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
  Widget build(BuildContext context) {
    return Padding(
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
              const Text("No video here")
          ],
        ),
      ),
    );
  }
}
