const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const fcm = admin.messaging();

//* LOVE *//
// Listens for Love(Likes) state added to /loveRiddles/:loveId/original and 
// increase/decrease the counter of /riddles/:riddleId/loves
exports.manageLoveCounter = functions.firestore.document('riddles/{riddleId}/lovedBy/{loveId}')
    .onWrite((snapshot, context) => {
        const newValue = snapshot.after.data();

        //Grab the riddleId of the created loveRiddles
        const riddleId = newValue.riddleId;

        //Document referent of the current Love(Like) riddle
        const firestore = admin.firestore();
        var docRef = firestore.collection('riddles').doc(riddleId);

        //Get the LoveRiddles state field value
        const state = newValue.state;

        if (state === true) {
            //Increment the value of the referent Riddle by 1
            return docRef.update({ 'counter.loves': admin.firestore.FieldValue.increment(1) });

        } else {
            //Decrement the value of the referent Riddle by -1
            return docRef.update({ 'counter.loves': admin.firestore.FieldValue.increment(-1) });
        }
    });

//* COMMENT *//

//Listen to Comment create and increase the counter of /riddles/::riddleId/comments
exports.manageCommentCounter = functions.firestore.document('riddles/{riddleId}/comments/{commentId}')
    .onCreate((snapshot, context) => {

        const firestore = admin.firestore();
        var docRef = firestore.collection('riddles').doc(context.params.riddleId);

        return docRef.update({ 'counter.comments': admin.firestore.FieldValue.increment(1) });

    });

//* SOLVED BY*//
//Listen to solvedby subcollection CREATE to increment the solveby RIDDLE counter by 1
//Also, assign the corresponding score for the user 
exports.manageSolvedBy = functions.firestore.document('riddles/{riddleId}/solvedBy/{solvedById}').onCreate(async (snapshot, context) => {
    const firestore = admin.firestore();

    //ID of the user that solved the riddle
    const userSolved = context.params.solvedById
    var userSolvedRef = firestore.collection('users').doc(userSolved);
    //Increment the solved user counter
    var promise1 = userSolvedRef.update({ 'counter.solved': admin.firestore.FieldValue.increment(1) });

    var riddleRef = firestore.collection('riddles').doc(context.params.riddleId);
    //Increment the solvedBy's riddle counter
    var promise2 = await riddleRef.update({ 'counter.solvedBy': admin.firestore.FieldValue.increment(1) });

    return Promise.all([promise1, promise2]);

});


//* USER *//

//TODO: Send email, when a user is created.

//Listen to create user event of Firebase Auth
exports.createUser = functions.auth.user().onCreate((user) => {
    const newUser = {
        'displayName': user.displayName,
        'biography': '',
        'photoUrl': user.photoURL,
        'webSite': '',
        'createdAt': user.metadata.creationTime,
    }
    const private = {
        'email': user.email,
        'sex': '',
    }

    var firestore = admin.firestore();
    return firestore.collection('users').doc(user.uid).set(newUser).then(response => {
        console.log('Response ', response);
        return firestore.collection('users').doc(user.uid).collection('privates').doc().set(private);
    }).catch(error => console.log('Error trying to create a user: ', error));

});

//Listen to the User update, in order to update each riddles and comments (photosUrl and displayName)
exports.updateUser = functions.firestore.document('users/{userId}').onUpdate((change, context) => {
    const firestore = admin.firestore();
    //Get new/old user data
    const newData = change.after.data();
    const oldData = change.before.data();

    //!No working propertly

    //Get the userId
    var userId = context.params.userId;

    //User OBJ to be update if their property channged
    var newUser = {
        'user': {
            'uid': userId,
            'displayName': oldData.displayName,
            'photoUrl': oldData.photoUrl,
        }
    };

    if (newData.displayName !== null) {
        newUser.user.displayName = newData.displayName;
    }
    if (newData.photoUrl !== null) {
        newUser.user.photoUrl = newData.photoUrl;
    }

    if (oldData.displayName !== newData.displayName || oldData.photoUrl !== newData.photoUrl) {
        var promises = []

        //Get all riddles where user.uid == userId
        var userRiddles = firestore.collection('riddles').where('user.uid', '==', userId).get();
        userRiddles.then(querySnapshot => {
            //Update each riddle photo
            querySnapshot.docs.forEach(documentSnapshot => {
                promises.join(documentSnapshot.ref.update(newUser));
            })
            return null;
        }).catch(error => console.log('Error trying to update: ', error));


        //Get all comments where user.uid == userId
        var userComments = firestore.collectionGroup('comments').where('user.uid', '==', userId).get();
        userComments.then(querySnapshot => {
            querySnapshot.docs.forEach(document => {
                //Update each comment by user
                promises.join(document.ref.update(newUser));
            });
            return null;
        }).catch(error => console.log('Error trying to update: ', error));

        return Promise.all(promises);
    }

    return null;
});

//Listen to riddles create to increase the user.riddle counter by 1
exports.manageRiddleCounter = functions.firestore.document('riddles/{riddlesId}').onCreate((snapshot, context) => {
    const firestore = admin.firestore();
    const userId = snapshot.data().user.uid;

    var ref = firestore.collection('users').doc(userId);
    return ref.update({ 'counter.riddles': admin.firestore.FieldValue.increment(1) });
});

//* FCM *//

//Listen to love(Likes) to notificate a user
exports.notifyLove = functions.firestore.document('riddles/{riddleId}/lovedBy/{docId}')
    .onCreate((snapshot, context) => {

        const document = snapshot.data();
        //Document referent of the current Love(Like) riddle
        const firestore = admin.firestore();

        //Get the tokes of the corresponding user
        firestore.collection('users').doc(document.userId)
            .collection('tokens').get().then(query => {
                const tokens = [];
                query.forEach(doc => {
                    tokens.push(doc.id);
                });

                const payload = {
                    notification: {
                        title: 'Someone love you riddle ♥️',
                        body: `Tap here to check it out!`,
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                };

                return fcm.sendToDevice(tokens, payload);

            }).catch(error => console.log('Error sending notification: ', error));
        return null;
    });

