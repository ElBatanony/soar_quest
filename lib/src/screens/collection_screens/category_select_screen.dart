import '../../data/collections/collection_slice.dart';
import '../../data/fields/sq_ref_field.dart';
import '../collection_screen.dart';
import '../screen.dart';
import 'gallery_screen.dart';

class CategorySelectScreen extends GalleryScreen {
  final SQRefField categoryField;
  final SQCollection itemsCollection;

  CategorySelectScreen({
    required this.itemsCollection,
    required this.categoryField,
    super.title,
  }) : super(collection: categoryField.collection);

  @override
  Screen docScreen(SQDoc doc) {
    final slice = CollectionSlice(itemsCollection,
        filter: RefFilter(categoryField.name, doc.ref));
    return CollectionScreen(
        title: "${doc.label} ${itemsCollection.id}", collection: slice);
  }
}
