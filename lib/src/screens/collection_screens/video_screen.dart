import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../data/sq_doc.dart';
import '../../fields/video_link_field.dart';
import '../collection_screen.dart';

class VideoCollectionScreen extends CollectionScreen {
  VideoCollectionScreen({
    required super.collection,
    required this.videoField,
    super.title,
  });

  final SQVideoLinkField videoField;

  @override
  docDisplay(doc) => VideoDisplayWidget(doc, videoField);
}

class VideoDisplayWidget extends StatefulWidget {
  const VideoDisplayWidget(this.doc, this.videoField);

  final SQDoc doc;
  final SQVideoLinkField videoField;

  @override
  State<VideoDisplayWidget> createState() => _VideoDisplayWidgetState();
}

class _VideoDisplayWidgetState extends State<VideoDisplayWidget> {
  _VideoDisplayWidgetState();

  YoutubePlayerController? _controller;

  Future<void> loadVideo() async {
    final videoFieldValue = widget.doc.getValue<String>(widget.videoField.name);
    if (videoFieldValue == null) return;
    _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(showFullscreenButton: true));
    await _controller?.cueVideoById(videoId: videoFieldValue);
  }

  @override
  void initState() {
    unawaited(loadVideo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: _controller != null
              ? YoutubePlayer(controller: _controller!)
              : const Text('No video here'),
        ),
      );

  @override
  void dispose() {
    unawaited(_controller?.close());
    super.dispose();
  }
}
