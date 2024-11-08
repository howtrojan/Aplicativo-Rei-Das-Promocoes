import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reidaspromocoes/services/routes.dart';
import 'package:reidaspromocoes/provider/like_provider.dart';
import 'package:provider/provider.dart';
import 'package:reidaspromocoes/config/theme_config.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
