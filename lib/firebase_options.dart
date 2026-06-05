import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Replace this file by running `flutterfire configure` after creating your
/// Firebase project. The values below are compile-time placeholders only.
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
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDj93wvcvfRXo6cEj0x8WoY8nup9V33pX8',
    appId: '1:71449805795:web:064633dd0e856097bd56d6',
    messagingSenderId: '71449805795',
    projectId: 'final-app-8aff9',
    authDomain: 'final-app-8aff9.firebaseapp.com',
    storageBucket: 'final-app-8aff9.firebasestorage.app',
    measurementId: 'G-JKSCN6MV9H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9dQ0WfF23sGnwXsdEfapi7tEmBo6cNe0',
    appId: '1:71449805795:android:bc9c85a0ec768396bd56d6',
    messagingSenderId: '71449805795',
    projectId: 'final-app-8aff9',
    storageBucket: 'final-app-8aff9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqo-DHSvakpDcli0sj69Uin8oxhw2XFVs',
    appId: '1:71449805795:ios:05ef818238f079a7bd56d6',
    messagingSenderId: '71449805795',
    projectId: 'final-app-8aff9',
    storageBucket: 'final-app-8aff9.firebasestorage.app',
    iosClientId: '71449805795-at4dvo40bev8vjdekkid17i83t07argv.apps.googleusercontent.com',
    iosBundleId: 'com.nurbakyt.copyapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCqo-DHSvakpDcli0sj69Uin8oxhw2XFVs',
    appId: '1:71449805795:ios:2bb3ef0cf6b9e56bbd56d6',
    messagingSenderId: '71449805795',
    projectId: 'final-app-8aff9',
    storageBucket: 'final-app-8aff9.firebasestorage.app',
    iosClientId: '71449805795-57tg6lobj7e8i9dvhaqsgvvft0hkrhsd.apps.googleusercontent.com',
    iosBundleId: 'com.example.copyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDj93wvcvfRXo6cEj0x8WoY8nup9V33pX8',
    appId: '1:71449805795:web:556db1771ab79991bd56d6',
    messagingSenderId: '71449805795',
    projectId: 'final-app-8aff9',
    authDomain: 'final-app-8aff9.firebaseapp.com',
    storageBucket: 'final-app-8aff9.firebasestorage.app',
    measurementId: 'G-M9XLVN92TR',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'REPLACE_WITH_LINUX_API_KEY',
    appId: '1:000000000000:linux:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'replace-with-your-project-id',
    authDomain: 'replace-with-your-project-id.firebaseapp.com',
    storageBucket: 'replace-with-your-project-id.appspot.com',
  );
}