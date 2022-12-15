import '../../data/collections/collection_slice.dart';
import '../../data/fields/ref_field.dart';
import '../collection_screen.dart';
import '../screen.dart';
import 'gallery_screen.dart';

class CategorySelectScreen extends GalleryScreen {
  CategorySelectScreen({
    required this.itemsCollection,
    required this.categoryField,
    super.title,
  }) : super(collection: categoryField.collection);

  final SQRefField categoryField;
  final SQCollection itemsCollection;

  @override
  Screen docScreen(SQDoc doc) {
    final slice = CollectionSlice(itemsCollection,
        filter: RefFilter(categoryField.name, doc.ref));
    return CollectionScreen(
        title: '${doc.label} ${itemsCollection.id}', collection: slice);
  }
}
