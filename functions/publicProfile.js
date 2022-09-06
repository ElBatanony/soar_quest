const functions = require("firebase-functions");
const admin = require("firebase-admin");

const db = admin.firestore();
const auth = admin.auth();

const appPath = 'sample-apps/Tech Admin'

const userDocPath = appPath + '/users/{userId}';
const publicProfileCollectionPath = appPath + '/publicProfiles'

const publicProfileBoolField = 'Public Profile';

const publicFields = ['City', 'Birthdate']

console.log(userDocPath)

module.exports.publicProfileTrigger = functions.firestore
    .document(userDocPath)
    .onWrite(async (change, context) => {

        let userId = context.params.userId

        let oldUserDocData = change.before.data();
        let userDocData = change.after.data();

        let user = await auth.getUser(userId);

        let publicProfileDocRef = db.doc(publicProfileCollectionPath + '/' + userId);

        if (oldUserDocData[publicProfileBoolField] == userDocData[publicProfileBoolField] && userDocData[publicProfileBoolField] != true) {
            return null;
        }

        if (userDocData[publicProfileBoolField] != true) {
            return publicProfileDocRef.delete();
        }

        let publicProfileDocData = {};

        for (let field of publicFields) {
            publicProfileDocData[field] = userDocData[field] ?? null;
        }

        publicProfileDocData['Username'] = user.displayName ?? "No username";

        return publicProfileDocRef.set(publicProfileDocData);
    });