import 'package:flutter/material.dart';
import 'package:reidaspromocoes/screen/favorite_promotion.dart';
import 'package:reidaspromocoes/screen/home_screen.dart';
import 'package:reidaspromocoes/screen/splash_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SplashScreen(),
  '/home': (context) => HomeScreen(), 
  '/favorite': (context) => FavoriteScreen(),
};
