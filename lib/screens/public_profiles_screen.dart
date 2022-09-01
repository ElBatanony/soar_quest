import '../data.dart';
import '../data/firestore.dart';
import 'collection_filter_screen.dart';

final SQCollection publicProfilesCollection = FirestoreCollection(
  id: 'publicProfiles',
  fields: publicProfileFields,
  readOnly: true,
);

class PublicProfilesScreen extends CollectionFilterScreen {
  PublicProfilesScreen({String title = "Public Profiles", super.key})
      : super(title, collection: publicProfilesCollection, filters: [
          StringContainsFilter(
              publicProfilesCollection.getFieldByName("Username"))
        ]);
}
