import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../db/sq_doc.dart';
import '../../fields/sq_video_link_field.dart';
import '../collection_screen.dart';

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
  Widget docDisplay(SQDoc doc) {
    return VideoDocDisplay(
      doc: doc,
      videoField: widget.videoField,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Scaffold(
            body: SingleChildScrollView(
                child: Column(
          children: docsDisplay(context),
        ))));
  }
}

class VideoDocDisplay extends StatefulWidget {
  final SQDoc doc;
  final VideoLinkField videoField;

  const VideoDocDisplay({required this.doc, required this.videoField, Key? key})
      : super(key: key);

  @override
  State<VideoDocDisplay> createState() => _VideoDocDisplayState();
}

class _VideoDocDisplayState extends State<VideoDocDisplay> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    String videoFieldValue = widget.doc.value(widget.videoField.name);

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
            Text(widget.doc.identifier),
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
