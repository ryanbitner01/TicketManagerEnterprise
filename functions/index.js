const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.handleNewUserRequest = functions.firestore
    .document("requests/{newDoc}")
    .onCreate((snap, context) => {
      const data = snap.data();
      return admin.firestore().collection("users").doc(data.email).set({
        email: data.email,
        firstName: data.firstName,
        lastName: data.lastName,
        uuid: data.uuid,
        accountType: "user",
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

/**
 * @param {String} user user email
 * @param {String} orgID orginization id
 * @param {String} orgName name of orginization
 * @return {Promise} write Promise
 */
function assignOrginization(user, orgID, orgName) {
  return admin.firestore().collection("users").doc(user).update({
    orginization: orgID,
    orginizationName: orgName,
  });
}

exports.checkForDuplicateEmails = functions.https.onCall((data, context) => {
  return admin.firestore()
      .collection("users")
      .doc(data.email)
      .get()
      .then((docSnapshot) => {
        if (docSnapshot.exists) {
          console.log("Exists");
          return true;
        } else if (!docSnapshot.exists) {
          console.log("doesn't exist");
          return false;
        } else {
          console.log("WHAT IS A DOC SNAPSHOT");
        }
      }).catch((err) => {
        console.log(err);
      });
});

exports.handleNewOrgRequest = functions.firestore
    .document("OrgRequests/{newDoc}")
    .onCreate((snap, context) => {
      const data = snap.data();
      return admin.firestore().collection("Orgs")
          .doc(data.orgID
              .toString())
          .set({
            orgID: data.orgID,
            orgName: data.orgName,
            orgOwner: data.orgOwner,
            provisioned: data.provisioned,
          })
          .then(updateAccountType(data.orgOwner, "moderator"))
          .then(assignOrginization(data.orgOwner, data.orgID, data.orgName))
          .then(deleteOrgRequest(snap.id));
    });

/**
 * @param {String} docID the name of the document
 * @return {Promise} write promise
*/
function deleteOrgRequest(docID) {
  return admin.firestore()
      .collection("OrgRequests")
      .doc(docID).delete();
}

/**
 * @param {String} email email of user
 * @param {String} accountType account type you would like to update to
 * @return {Promise} update promise
 */
function updateAccountType(email, accountType) {
  return admin.firestore().collection("users").doc(email).update({
    accountType: accountType,
  });
}

exports.getOrgID = functions.https.onCall((data, context) => {
  return admin.firestore()
      .collection("Orgs")
      .get()
      .then((querySnapshot) => {
        const docs = querySnapshot.docChanges();
        console.log(docs.length);
        return docs.length;
      });
});

