import 'package:flutter/material.dart';
import 'dart:async';
import 'qr_scanner.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Flow: After Splash, always go to QR Scanner first for hardware link
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QRScannerPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Removed 'const' from here to allow dynamic children
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_moon, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20), // Added spacing before text
            // 📍 YOUR ADDED TEXT IS HERE:
            const Text(
              "AuraShield",
              style: TextStyle(
                color: Colors.white, 
                fontSize: 24, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}