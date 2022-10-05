import '../../../db.dart';
import '../../app/app.dart';
import 'collection_filter_screen.dart';

// TODO: public profile cloud function removed
// Update public profiles when setting user doc

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
                  publicProfilesCollection.getField("Username")!)
            ]);
}
