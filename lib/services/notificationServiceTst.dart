import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'NotificationApi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyHomePageState());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

class MyHomePageState extends StatefulWidget {
  const MyHomePageState({Key? key}) : super(key: key);

  @override
  State<MyHomePageState> createState() => MyHomePageStateState();
}

class MyHomePageStateState extends State<MyHomePageState> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    IniciarApp();

    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');

      NotificationApi.showNotification(
          title: '${message.data['title']}',
          body: '${message.data['title']}',
          payload: 'hrg.ntf'
      );

      print('Message data: ${message.data}');
      print('Message data: ${message.data['title']}');
      print('Message data: ${message.data['body']}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  IniciarApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tst'),
      ),
      body: Center(
        child: Text('Firebase Messaging'),
      ),
    );
  }
}
