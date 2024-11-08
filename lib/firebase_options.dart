import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: dotenv.get('FIREBASE_API_KEY_WEB'),
        appId: dotenv.get('FIREBASE_APP_ID_WEB'),
        messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: dotenv.get('FIREBASE_PROJECT_ID'),
        authDomain: dotenv.get('FIREBASE_AUTH_DOMAIN'),
        databaseURL: dotenv.get('FIREBASE_DATABASE_URL'),
        storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET'),
        measurementId: dotenv.get('FIREBASE_MEASUREMENT_ID'),
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: dotenv.get('FIREBASE_API_KEY_ANDROID'),
          appId: dotenv.get('FIREBASE_APP_ID_ANDROID'),
          messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID'),
          projectId: dotenv.get('FIREBASE_PROJECT_ID'),
          databaseURL: dotenv.get('FIREBASE_DATABASE_URL'),
          storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET'),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return FirebaseOptions(
          apiKey: dotenv.get('FIREBASE_API_KEY_IOS'),
          appId: dotenv.get('FIREBASE_APP_ID_IOS'),
          messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID'),
          projectId: dotenv.get('FIREBASE_PROJECT_ID'),
          databaseURL: dotenv.get('FIREBASE_DATABASE_URL'),
          storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET'),
          iosBundleId: dotenv.get('FIREBASE_IOS_BUNDLE_ID'),
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
