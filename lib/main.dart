import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:reidaspromocoes/admob/intersticial.dart';
import 'package:reidaspromocoes/provider/like_provider.dart';
import 'package:reidaspromocoes/services/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp()); 
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeServices();
  }

  Future<void> _initializeServices() async {
    await Firebase.initializeApp();
    await initializeOneSignal();
    await MobileAds.instance.initialize();

    final InterstitialAdManager interstitialAdManager = InterstitialAdManager();
    interstitialAdManager.initialize();
  }

  Future<void> initializeOneSignal() async {
    OneSignal.initialize("36edbd8b-a967-4f9d-bbdb-390da7c4f96d");
    OneSignal.LiveActivities.setupDefault();   
    OneSignal.Notifications.clearAll();
    OneSignal.User.pushSubscription.addObserver((state) {
      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("Erro na inicialização dos serviços"),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LikeProvider()),
          ],
          child: MaterialApp(
            title: 'Rei das Promoções',
            theme: buildThemeData(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', ''),
            ],
            initialRoute: '/',
            routes: appRoutes,
          ),
        );
      },
    );
  }
}
