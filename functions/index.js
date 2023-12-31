const functions = require("firebase-functions");
const admin = require("firebase-admin");

var serviceAccount = require("./keyket-bc537-firebase-adminsdk-e1zsd-92d0421d09.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.createCustomToken = functions.https.onRequest(async (request, response) => {
    const user = request.body;

    const uid = user.uid;
    const updateParams = {
        email: user.email,
        photoURL: user.photoURL,
        displayName: user.displayName
    };
    

    try{    // 바뀐 부분 있으면 update
        await admin.auth().updateUser(uid, updateParams);
    } catch(e){ // 없으면 새로 생성
        updateParams["uid"] = uid;
        await admin.auth().createUser(updateParams);
    }


    const token = await admin.auth().createCustomToken(uid); 

    response.send(token);
  
});

exports.deleteUser = functions.https.onRequest(async (request, response) => {
    // 요청으로부터 uid를 가져옵니다.
    const uid = request.body.uid;

    if (!uid) {
        response.status(400).send({ error: 'UID is required' });
        return;
    }

    try {
        await admin.auth().deleteUser(uid);
        response.send({ success: true });
    } catch (error) {
        console.error('Error deleting user:', error);
        response.status(500).send({ error: 'Failed to delete user' });
    }
});