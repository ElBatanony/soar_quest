const functions = require("firebase-functions");
const admin = require("firebase-admin");

const db = admin.firestore();

const appPath = 'sample-apps/Tech Admin'
const postCollectionName = 'Colours'
const upvotesCollectionName = 'Upvotes'
const postCollectionPath = appPath + '/' + postCollectionName;
const upVoteDocumentPath = postCollectionPath + '/{postDocId}/' + upvotesCollectionName + '/{upvoteDocId}';

module.exports.upvotesTracker = functions.firestore
  .document(upVoteDocumentPath)
  .onWrite((change, context) => {

    let postDocId = context.params.postDocId
    let postDocRef = db.doc(postCollectionPath + '/' + postDocId);

    let incrementValue = change.after.exists == false ? -1 : 1;

    let fieldValue = admin.firestore.FieldValue.increment(incrementValue);

    return postDocRef.set({ upvotes: fieldValue }, { merge: true });
  });