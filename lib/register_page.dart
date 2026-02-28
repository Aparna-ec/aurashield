import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart'; // Placeholder for post-registration landing page
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Theme Colors
  final Color darkBlue = const Color(0xFF0D47A1);
  final Color iceWhite = Colors.white;

  // Controllers
  final _childName = TextEditingController();
  final _age = TextEditingController();
  final _soundThreshold = TextEditingController(); // dB
  final _lightThreshold = TextEditingController(); // Lux
  final _playlistLink = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  
  String _gender = "Male"; 

 void _saveProfile() async {
    if (_pinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PINs do not match!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      // 1. Save data to Firestore
      await FirebaseFirestore.instance.collection('child_profiles').add({
        'name': _childName.text,
        'age': _age.text,
        'gender': _gender,
        'thresholds': {
          'sound_db': _soundThreshold.text,
          'light_lux': _lightThreshold.text,
        },
        'calm_playlist': _playlistLink.text,
        'secure_pin': _pinController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. ✅ FIXED: Uncomment these lines to actually move to the HomePage
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: darkBlue),
      filled: true,
      fillColor: Colors.blue.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkBlue.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iceWhite,
      appBar: AppBar(
        title: const Text("Child Profile Setup", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: darkBlue,
        foregroundColor: iceWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Basic Details", 
              style: TextStyle(color: darkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: _childName, decoration: _inputStyle("Child's Name", Icons.person)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: TextField(controller: _age, decoration: _inputStyle("Age", Icons.cake), keyboardType: TextInputType.number)),
                const SizedBox(width: 15),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: _inputStyle("Gender", Icons.wc),
                    onChanged: (v) => setState(() => _gender = v!),
                    items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text("Sensory Thresholds", 
              style: TextStyle(color: darkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: _soundThreshold, decoration: _inputStyle("Sound Threshold (dB)", Icons.volume_up), keyboardType: TextInputType.number),
            const SizedBox(height: 15),
            TextField(controller: _lightThreshold, decoration: _inputStyle("Light Threshold (Lux)", Icons.light_mode), keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            Text("Calm Playlist", 
              style: TextStyle(color: darkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: _playlistLink, decoration: _inputStyle("Spotify/Music Link", Icons.music_note)),
            const SizedBox(height: 30),
            Text("Security PIN", 
              style: TextStyle(color: darkBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: _pinController, obscureText: true, decoration: _inputStyle("4-Digit PIN", Icons.lock)),
            const SizedBox(height: 15),
            TextField(controller: _confirmPinController, obscureText: true, decoration: _inputStyle("Confirm PIN", Icons.lock_outline)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  foregroundColor: iceWhite,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: const Text("COMPLETE SETUP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}