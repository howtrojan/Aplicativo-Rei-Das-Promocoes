import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reidaspromocoes/admob/intersticial.dart';

Future<void> initializeServices() async {
  await Firebase.initializeApp();
  await initializeOneSignal();
  await MobileAds.instance.initialize();

  final InterstitialAdManager interstitialAdManager = InterstitialAdManager();
  interstitialAdManager.initialize();
}

Future<void> initializeOneSignal() async {
  OneSignal.initialize(dotenv.get('ONESIGNAL'));
  OneSignal.LiveActivities.setupDefault();
  OneSignal.Notifications.clearAll();
  OneSignal.User.pushSubscription.addObserver((state) {
    print(OneSignal.User.pushSubscription.optedIn);
    print(OneSignal.User.pushSubscription.id);
    print(OneSignal.User.pushSubscription.token);
    print(state.current.jsonRepresentation());
  });
}
