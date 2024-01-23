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
    apiKey: 'AIzaSyCtRwEWwjK4u4QJ7hNNlV4seUOvlENjy7Q',
    appId: '1:195149743395:web:9ab0717b2ad70f11c1f896',
    messagingSenderId: '195149743395',
    projectId: 'matchapp-b63fa',
    authDomain: 'matchapp-b63fa.firebaseapp.com',
    storageBucket: 'matchapp-b63fa.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqw69aBPm_7K41k6Gqb_kGBJs2s49G3DI',
    appId: '1:195149743395:android:03c9d32ece323331c1f896',
    messagingSenderId: '195149743395',
    projectId: 'matchapp-b63fa',
    storageBucket: 'matchapp-b63fa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxXZLdhu7JUV6eLdY_z9asOi25pKUu4aE',
    appId: '1:195149743395:ios:d190e524f07adc04c1f896',
    messagingSenderId: '195149743395',
    projectId: 'matchapp-b63fa',
    storageBucket: 'matchapp-b63fa.appspot.com',
    iosClientId: '195149743395-nv7jutciepe2nff0nvjf7ptu631kucp0.apps.googleusercontent.com',
    iosBundleId: 'com.example.matchApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxXZLdhu7JUV6eLdY_z9asOi25pKUu4aE',
    appId: '1:195149743395:ios:d190e524f07adc04c1f896',
    messagingSenderId: '195149743395',
    projectId: 'matchapp-b63fa',
    storageBucket: 'matchapp-b63fa.appspot.com',
    iosClientId: '195149743395-nv7jutciepe2nff0nvjf7ptu631kucp0.apps.googleusercontent.com',
    iosBundleId: 'com.example.matchApp',
  );
}