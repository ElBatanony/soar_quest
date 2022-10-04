import 'package:flutter/material.dart';

import '../../src/ui/buttons/sq_button.dart';
import '../../src/ui/wrappers/signed_in_content.dart';
import '../../db.dart';
import '../../data/user_data.dart';
import '../feature.dart';

class UpvotesFeature extends Feature {
  static StatefulWidget upvoteButton(SQDoc doc) {
    return _UpvoteButton(doc: doc);
  }

  static addUpvote(SQCollection upvotesCollection, String upvoteId) {
    return upvotesCollection
        .createDoc(SQDoc(upvoteId, collection: upvotesCollection));
  }

  static removeUpvote(SQCollection upvotesCollection, String upvoteId) {
    return upvotesCollection.deleteDoc(upvoteId);
  }

  static canUpvote(SQCollection upvotesCollection, String upvoteId) {
    return upvotesCollection.doesDocExist(upvoteId) == false;
  }
}

class _UpvoteButton extends StatefulWidget {
  final SQDoc doc;

  const _UpvoteButton({required this.doc});

  @override
  State<_UpvoteButton> createState() => _UpvoteButtonState();
}

class _UpvoteButtonState extends State<_UpvoteButton> {
  late final SQCollection upvotesCollection;

  void loadUpvotesCollection() async {
    await upvotesCollection.loadCollection();
    setState(() {});
  }

  void addUpvote(SignedInUser user) async {
    await UpvotesFeature.addUpvote(upvotesCollection, user.userId);
    setState(() {});
  }

  void removeUpvote(SignedInUser user) async {
    await UpvotesFeature.removeUpvote(upvotesCollection, user.userId);
    setState(() {});
  }

  @override
  void initState() {
    upvotesCollection = FirestoreCollection(
        id: "Upvotes",
        fields: [],
        singleDocName: "Upvote",
        parentDoc: widget.doc);
    loadUpvotesCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SignedInContent(builder: ((context, user) {
      if (UpvotesFeature.canUpvote(upvotesCollection, user.userId))
        return SQButton("Add Upvote", onPressed: () => addUpvote(user));
      return SQButton("Remove upvote", onPressed: () => removeUpvote(user));
    }));
  }
}
