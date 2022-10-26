import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../db/sq_doc.dart';
import '../../db/fields/sq_video_link_field.dart';
import '../collection_screen.dart';
import '../doc_screen.dart';

class VideoCollectionScreen extends CollectionScreen {
  final VideoLinkField videoField;

  VideoCollectionScreen({
    super.title,
    required super.collection,
    required this.videoField,
    super.key,
  });

  @override
  State<VideoCollectionScreen> createState() => _VideoCollectionScreenState();
}

class _VideoCollectionScreenState
    extends CollectionScreenState<VideoCollectionScreen> {
  @override
  Widget docDisplay(SQDoc doc, BuildContext context) {
    return VideoDocDisplay(
      doc,
      videoField: widget.videoField,
    );
  }
}

class VideoDocDisplay extends DocScreen {
  final VideoLinkField videoField;

  VideoDocDisplay(super.doc,
      {required this.videoField, super.isInline, super.key});

  @override
  State<VideoDocDisplay> createState() => _VideoDocDisplayState();
}

class _VideoDocDisplayState extends DocScreenState<VideoDocDisplay> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    String? videoFieldValue = widget.doc.value<String>(widget.videoField.name);

    if (videoFieldValue == null) return;

    String? videoId = YoutubePlayer.convertUrlToId(videoFieldValue);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
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
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          children: [
            Text(widget.doc.label),
            _controller != null
                ? YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                  )
                : Text("No video here")
          ],
        ),
      ),
    );
  }
}
