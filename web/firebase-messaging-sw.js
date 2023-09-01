importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
      apiKey: "AIzaSyAZxgVG2Z0CQKBWDMjmlQDtGHN9GdG9-tk",
      authDomain: "pedefacilentregadores-f5b14.firebaseapp.com",
      projectId: "pedefacilentregadores-f5b14",
      storageBucket: "pedefacilentregadores-f5b14.appspot.com",
      messagingSenderId: "404344995033",
      appId: "1:404344995033:web:8a8a4e0fc212f67dbd92c8",
      measurementId: "G-4YGDCSBPQG"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});