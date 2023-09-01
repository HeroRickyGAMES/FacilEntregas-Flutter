// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBDAQQlFdStJMymcV6h7a-IWan56Ydl6gU',
    appId: '1:750985511375:web:061cf0fbeba8dcc0c612ba',
    messagingSenderId: '750985511375',
    projectId: 'facilentregas-cd4c5',
    authDomain: 'facilentregas-cd4c5.firebaseapp.com',
    storageBucket: 'facilentregas-cd4c5.appspot.com',
    measurementId: 'G-9VLVL4NJCG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3EflawlJO2aG4T0h3Ygeo3JWl6ChIClU',
    appId: '1:750985511375:android:b35b9d3fe983d640c612ba',
    messagingSenderId: '750985511375',
    projectId: 'facilentregas-cd4c5',
    storageBucket: 'facilentregas-cd4c5.appspot.com',
  );
}
