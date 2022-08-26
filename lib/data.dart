import 'app/app.dart';
import 'data/firestore.dart';

export 'data/sq_collection.dart';
export 'data/sq_doc.dart';
export 'data/sq_doc_field.dart';
export 'data/docs_filter.dart';
export 'data/sq_file.dart';

FirestoreCollection userCollection = FirestoreCollection(
    id: "users/${App.instance.currentUser.userId}/data", fields: []);
