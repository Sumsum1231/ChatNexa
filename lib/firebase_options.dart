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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQrdFwL8ljSEHmuhc7YtJszWWhG71VXiU',
    appId: '1:251764299162:android:7853fe522bb2790381d623',
    messagingSenderId: '251764299162',
    projectId: 'my-chat-app-d3c4e',
    storageBucket: 'my-chat-app-d3c4e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGSqLUpIggz81TV_52qLkytJoszRoPqEw',
    appId: '1:251764299162:ios:825323505f98a28481d623',
    messagingSenderId: '251764299162',
    projectId: 'my-chat-app-d3c4e',
    storageBucket: 'my-chat-app-d3c4e.appspot.com',
    androidClientId: '251764299162-agfggkbv99doom5nr1osbfvvot2mjs6i.apps.googleusercontent.com',
    iosClientId: '251764299162-t3d0jm4ub826epd356stoiubje65g1hg.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );
}
