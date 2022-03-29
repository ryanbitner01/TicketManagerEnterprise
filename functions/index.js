const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.handleNewUserRequest = functions.firestore
    .document("requests/{newDoc}")
    .onCreate((snap, context) => {
      const data = snap.data();
      return admin.firestore().collection("users").doc(data.uuid).set({
        email: data.email,
        firstName: data.firstName,
        lastName: data.lastName,
        uuid: data.uuid,
      }).then(deleteRequest(snap.id));
    });

/**
 * @param {String} docID the name of the document
 * @return {Promise} write promise
*/
function deleteRequest(docID) {
  return admin.firestore()
      .collection("requests")
      .doc(docID).delete();
}

