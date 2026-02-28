import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'login_page.dart'; 
import 'dart:async'; // Needed for the fake delay

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool isScanning = true;
  bool isVerifying = false; // New state for the "Fake Loading"

  void _fakeVerify() {
    setState(() {
      isVerifying = true; // Show the "Verifying..." UI
    });

    // 🕒 FAKE DELAY: Wait 2 seconds to make it look like it's checking the cloud
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Link AuraShield Hardware"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // 1. Real Camera Feed (Keep this so it looks real!)
          MobileScanner(
            onDetect: (capture) {
              if (isScanning) {
                setState(() => isScanning = false);
                _fakeVerify(); // Trigger the fake process
              }
            },
          ),

          // 2. Visual Scanner Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: isVerifying ? Colors.green : Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // 3. Status UI
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isVerifying 
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green)),
                        SizedBox(width: 15),
                        Text("Verifying Hardware...", style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : const Text("Align QR Code within the frame", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}