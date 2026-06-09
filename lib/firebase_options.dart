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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'dummy-api-key',
    appId: '1:1234567890:web:dummy1234',
    messagingSenderId: '1234567890',
    projectId: 'stravun-dummy',
    authDomain: 'stravun-dummy.firebaseapp.com',
    storageBucket: 'stravun-dummy.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_-5y82Oylh788iAzqdQxf4uCqf2iF_Uo',
    appId: '1:102327170017:android:065d0e6b8d4337f68e18a0',
    messagingSenderId: '102327170017',
    projectId: 'a2fe4bcw',
    storageBucket: 'a2fe4bcw.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'dummy-api-key',
    appId: '1:1234567890:ios:dummy1234',
    messagingSenderId: '1234567890',
    projectId: 'stravun-dummy',
    storageBucket: 'stravun-dummy.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'dummy-api-key',
    appId: '1:1234567890:ios:dummy1234',
    messagingSenderId: '1234567890',
    projectId: 'stravun-dummy',
    storageBucket: 'stravun-dummy.appspot.com',
    iosBundleId: 'com.example.app',
  );
}
