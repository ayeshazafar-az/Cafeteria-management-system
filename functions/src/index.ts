import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onOrderStatusUpdated = functions.firestore
    .document("orders/{orderId}")
    .onUpdate(async (change) => {
        const beforeData = change.before.data();
        const afterData = change.after.data();

        // Send push notification when order turns READY
        if (beforeData.status !== "ready" && afterData.status === "ready") {
            const studentId = afterData.studentId;
            const tokenNumber = afterData.tokenNumber;

            const userDoc = await admin.firestore().collection("users").doc(studentId).get();
            const fcmToken = userDoc.data()?.fcmToken;

            if (fcmToken) {
                const payload = {
                    notification: {
                        title: "Order Ready for Pickup! 🍔",
                        body: `Token #${tokenNumber} is ready at ${afterData.shopName}. Please collect your order.`,
                    },
                };
                await admin.messaging().sendToDevice(fcmToken, payload);
            }
        }
    });