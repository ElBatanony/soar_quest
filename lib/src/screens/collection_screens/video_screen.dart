import '../../fields/video_id_field.dart';
import '../../ui/video_display.dart';
import '../collection_screen.dart';

class VideoCollectionScreen extends CollectionScreen {
  VideoCollectionScreen({
    required super.collection,
    required this.videoField,
    super.title,
  });

  final SQVideoIDField videoField;

  @override
  docDisplay(doc) => VideoDisplayWidget(doc, videoField);
}
