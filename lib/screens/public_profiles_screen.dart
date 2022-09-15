import '../app.dart';
import '../data/db.dart';
import '../data/docs_filter.dart';
import 'collection_filter_screen.dart';

final SQCollection publicProfilesCollection = FirestoreCollection(
  id: 'publicProfiles',
  fields: App.instance.publicProfileFields,
  readOnly: true,
);

class PublicProfilesScreen extends CollectionFilterScreen {
  PublicProfilesScreen({super.key})
      : super(
            title: "Public Profiles",
            collection: publicProfilesCollection,
            filters: [
              StringContainsFilter(
                  publicProfilesCollection.getFieldByName("Username"))
            ]);
}
