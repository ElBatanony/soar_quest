import 'package:flutter/material.dart';

import '../../ui/sq_button.dart';
import '../../ui/signed_in_content.dart';
import '../../../db.dart';

class UpvotesFeature {
  static StatefulWidget upvoteButton(SQDoc doc) {
    return _UpvoteButton(doc: doc);
  }

  static addUpvote(SQCollection upvotesCollection, String upvoteId) {
    return upvotesCollection
        .saveDoc(SQDoc(upvoteId, collection: upvotesCollection));
  }

  static removeUpvote(SQCollection upvotesCollection, String upvoteId) {
    return upvotesCollection.deleteDoc(
        upvotesCollection.docs.firstWhere((doc) => doc.id == upvoteId));
  }

  static canUpvote(SQCollection upvotesCollection, String upvoteId) {
    return upvotesCollection.docs.any((doc) => doc.id == upvoteId);
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
