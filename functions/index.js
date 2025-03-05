const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendWorkoutReminder = functions.firestore
  .document("Users/{email}/Reminders/{reminderId}")
  .onCreate(async (snap, context) => {
    const reminderData = snap.data();
    const userId = context.params.userId;
    const userRef = admin.firestore().collection("Users").doc(email);
    const userDoc = await userRef.get();

    if (userDoc.exists) {
      const fcmToken = userDoc.data().fcmToken;

      if (fcmToken) {
        const payload = {
          notification: {
            title: "Workout Reminder",
            body: `Time for your workout!`,
          },
          token: fcmToken,
        };

        try {
          await admin.messaging().send(payload);
          console.log("Notification sent successfully");
        } catch (error) {
          console.error("Error sending notification:", error);
        }
      }
    }
  });
