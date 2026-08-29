// File generated for Shilpsetu Firebase configuration.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Shilpsetu Firebase apps.
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
        return ios;
      case TargetPlatform.windows:
        return android;
      case TargetPlatform.linux:
        return android;
      case TargetPlatform.fuchsia:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDQ36oeH_mvdsWDm6sCIeI47u0f-9MR7A',
    appId: '1:817957930101:web:241acd0c013ffc3392a43c',
    messagingSenderId: '817957930101',
    projectId: 'shilpsetu-app',
    authDomain: 'shilpsetu-app.firebaseapp.com',
    storageBucket: 'shilpsetu-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDQ36oeH_mvdsWDm6sCIeI47u0f-9MR7A',
    appId: '1:817957930101:android:241acd0c013ffc3392a43c',
    messagingSenderId: '817957930101',
    projectId: 'shilpsetu-app',
    storageBucket: 'shilpsetu-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDQ36oeH_mvdsWDm6sCIeI47u0f-9MR7A',
    appId: '1:817957930101:ios:241acd0c013ffc3392a43c',
    messagingSenderId: '817957930101',
    projectId: 'shilpsetu-app',
    storageBucket: 'shilpsetu-app.firebasestorage.app',
    iosBundleId: 'in.shilpsetu.shilpsetu',
  );
}
