const functions = require("firebase-functions");
const admin = require("firebase-admin");

const db = admin.firestore();

module.exports.getCollectionDocs = functions.https.onRequest(async (req, res) => {
    const collectionId = req.query.collectionId;
    console.log("got collectionId", collectionId);
    let snapshot = await db.collection(collectionId).limit(100).get();
    res.status(200).send({ docs: snapshot.docs.map(docRaw => { return { id: docRaw.id, data: docRaw.data() } }) });
});