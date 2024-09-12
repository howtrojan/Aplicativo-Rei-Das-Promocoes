import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Aguarda 5 segundos e navega para a próxima tela
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width *
                  0.4, // Defina também uma altura
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset('assets/splash_icon.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Rei das Promoções',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 50), // Espaço entre o texto e o indicador de progresso
            CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
