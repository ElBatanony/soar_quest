import '../../fields/video_link_field.dart';
import '../../ui/video_display.dart';
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
