import 'package:flutter/material.dart';
import 'package:soar_quest/app/app_navigator.dart';
import 'package:soar_quest/components/buttons/sq_button.dart';
import 'package:soar_quest/data/db.dart';
import 'package:soar_quest/data/types.dart';
import 'package:soar_quest/screens/collection_filter_screen.dart';
import 'package:soar_quest/screens/collection_screen.dart';
import 'package:soar_quest/screens/doc_create_screen.dart';
import 'package:soar_quest/screens/doc_screen.dart';
import 'package:soar_quest/screens/screen.dart';

import 'config.dart';
import 'favourite_class_types_filter.dart';

Screen classesCollectionScreen() {
  return CollectionFilterScreen(
    title: "Classes",
    collection: classes,
    filters: [
      FavouriteClassTypesFilter(
        favouritesFeature: favouriteClassTypes,
      )
    ],
    prebody: (_) => Column(
      children: [Text("Available Classes"), Text("Based On Your Interests")],
    ),
    postbody: (context) =>
        CollectionScreen(title: "All Classes", collection: classes)
            .button(context),
  );
}

class BookClassScreen extends DocScreen {
  final SQCollection requests;

  BookClassScreen(super.doc, {required this.requests, super.key})
      : super(canEdit: false, canDelete: false);

  @override
  State<BookClassScreen> createState() => _BookClassScreenState();
}

class _BookClassScreenState extends DocScreenState<BookClassScreen> {
  @override
  Widget screenBody(BuildContext context) {
    return Column(children: [
      super.screenBody(context),
      SQButton(
        'Request Class',
        onPressed: () => goToScreen(
            DocCreateScreen(
              title: "Book Class",
              submitButtonText: "Submit Request",
              widget.requests,
              initialFields: [
                widget.requests.getFieldByName("Requested Class").copy()
                  ..value = SQDocReference.fromDoc(doc)
                  ..readOnly = true
              ],
              hiddenFields: [
                "Status",
                "Attendee",
                "Video Meeting Link",
                "Reschedule Comment"
              ],
            ),
            context: context),
      ),
    ]);
  }
}
