import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AlertScreen extends StatefulWidget {
  final int stressLevel;
  const AlertScreen({super.key, required this.stressLevel});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  Color _bgColor = Colors.red;
  bool _isActionTaken = false;

  @override
  void initState() {
    super.initState();
    // 💡 Setup the Blinking Animation
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  void _handleAction(String actionType) {
    setState(() {
      _isActionTaken = true;
      _bgColor = Colors.green; // Turn green on press
      _blinkController.stop();
    });

    // 📡 BACKEND: Tell ESP8266 to start/stop the LED
    FirebaseDatabase.instance.ref("alerts").update({
      "action_taken": actionType,
      "stress_percent": 0, // Reset to stop the loop
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context); // Return to Dashboard
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _blinkController,
        builder: (context, child) {
          return Container(
            // Blinks between Red and Dark Red unless action is taken
            color: _isActionTaken 
                ? _bgColor 
                : Color.lerp(Colors.red, Colors.red[900], _blinkController.value),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              Text("${widget.stressLevel}%", 
                  style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Chance of sensory overloading in our kid. Have a look and take necessary action.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 60),
              
              // 🔘 THE MAIN BUTTONS
              _buildActionButton("ACTIVATE CALM", Icons.music_note, () => _handleAction("calm")),
              const SizedBox(height: 20),
              _buildActionButton("CANCEL ALERT", Icons.close, () => _handleAction("cancel"), isSecondary: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, {bool isSecondary = false}) {
    return SizedBox(
      width: 280,
      height: 70,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white24 : Colors.white,
          foregroundColor: isSecondary ? Colors.white : Colors.red[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          elevation: 10,
        ),
      ),
    );
  }
}