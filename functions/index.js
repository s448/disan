const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteOldPosts = functions.pubsub
    .schedule("0 */6 * * *")
    .timeZone("UTC")
    .onRun(async (context) => {
      const db = admin.firestore();
      await deleteDocumentsOlderThan(db.collection("posts"), "date", 15);
      await deleteDocumentsOlderThan(db.collection("clip"), "date", 5);
      await deleteDocumentsOlderThan(db.collection("story"), "date", 1);
      return null;
    });
async function deleteDocumentsOlderThan(collection, fieldName, days) {
  const documents = await collection
      .where(fieldName, "<", getTimestampXDaysAgo(days))
      .get();
  const batch = collection.firestore.batch();
  documents.forEach((doc) => {
    batch.delete(doc.ref);
  });
  await batch.commit();
}
function getTimestampXDaysAgo(days) {
  const xDaysAgo = new Date();
  xDaysAgo.setDate(xDaysAgo.getDate() - days);
  return xDaysAgo;
}
