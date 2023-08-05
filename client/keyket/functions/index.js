const functions = require("firebase-functions");
const admin = require("firebase-admin");

var serviceAccount = require("./keyket-bc537-firebase-adminsdk-e1zsd-8d927fc08b.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

exports.createCustomToken = functions.https.onRequest(async (request, response) => {
    const user = request.body;

    const uid = `kakao:${user.uid}`;
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
