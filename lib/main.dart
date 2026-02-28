import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'splash_screen.dart'; // We will create this next
import 'login_page.dart';    // Your original login logic
import 'qr_scanner.dart';    // The hardware link
import 'register_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AuraShieldApp());
}

class AuraShieldApp extends StatelessWidget {
  const AuraShieldApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      // The app starts at the Splash Screen
      home: const SplashScreen(), 
    );
  }
}