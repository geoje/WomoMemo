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
    apiKey: 'AIzaSyBegDS_abY3Jl9FsldvKR2sP_YpSkzobjc',
    appId: '1:296416469462:web:cef551e8a15749f46c4477',
    messagingSenderId: '296416469462',
    projectId: 'womoso',
    authDomain: 'womoso.firebaseapp.com',
    storageBucket: 'womoso.appspot.com',
    measurementId: 'G-2PMT7NJ7WX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCTsOF_ucopN2EVO-nGkO1_6hfc4vqoT8',
    appId: '1:296416469462:android:e73ca6a4ac9a9aa06c4477',
    messagingSenderId: '296416469462',
    projectId: 'womoso',
    storageBucket: 'womoso.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUp7pKETdQ4asXUId_UjXBHxAwTKR5ZLo',
    appId: '1:296416469462:ios:d8b49450020894746c4477',
    messagingSenderId: '296416469462',
    projectId: 'womoso',
    storageBucket: 'womoso.appspot.com',
    iosClientId: '296416469462-2bgdlhhgqionh12dauc82eqqf8pvsce9.apps.googleusercontent.com',
    iosBundleId: 'com.womosoft.memo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUp7pKETdQ4asXUId_UjXBHxAwTKR5ZLo',
    appId: '1:296416469462:ios:3add0d0545fbc6ff6c4477',
    messagingSenderId: '296416469462',
    projectId: 'womoso',
    storageBucket: 'womoso.appspot.com',
    iosClientId: '296416469462-hm9j4q7c1e52qh989aa518g5em2ojuge.apps.googleusercontent.com',
    iosBundleId: 'com.womosoft.memo.RunnerTests',
  );
}
