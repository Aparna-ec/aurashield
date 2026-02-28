import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'alert_screen.dart'; // Ensure you import your new AlertScreen file

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color darkBlue = const Color(0xFF0D47A1);
  final databaseRef = FirebaseDatabase.instance.ref();
  
  // 📈 Lists to store history for the 4 moving graphs
  List<FlSpot> bpmHistory = [];
  List<FlSpot> gsrHistory = [];
  List<FlSpot> luxHistory = [];
  List<FlSpot> audioHistory = [];
  int timeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("AuraShield Monitor", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: databaseRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // 1. Data Parsing
          Map<dynamic, dynamic> fullData = snapshot.data!.snapshot.value as Map;
          Map<dynamic, dynamic> vitals = fullData['live_vitals'] ?? {};
          
          int bpm = vitals['bpm'] ?? 0;
          int gsr = vitals['gsm_signal'] ?? 0; // Using gsm_signal as GSR for demo
          int lux = vitals['lux'] ?? 0;
          int audio = vitals['audio_db'] ?? 0;
          int stressLevel = fullData['alerts']?['stress_percent'] ?? 0;
          bool isHigh = stressLevel >= 70;

          // 📍 TRIGGER ALERT SCREEN
          if (stressLevel >= 70) {
            // Use a post-frame callback to avoid building while navigating
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlertScreen(stressLevel: stressLevel)),
              );
            });
          }

          // 2. Update Graph History (Limit to 15 points for performance)
          if (timeIndex % 1 == 0) { // Update logic
             _updateHistory(bpmHistory, bpm.toDouble());
             _updateHistory(gsrHistory, gsr.toDouble());
             _updateHistory(luxHistory, lux.toDouble());
             _updateHistory(audioHistory, audio.toDouble());
             timeIndex++;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // 📍 AI PREDICTION HEADER
                _buildAIHeader(stressLevel, isHigh),
                const SizedBox(height: 20),

                // 🌡️ PRESENT VALUES (Grid)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildMetricTile("Heart", "$bpm", "BPM", Colors.red),
                    _buildMetricTile("Skin Res.", "$gsr", "GSR", Colors.green),
                    _buildMetricTile("Light", "$lux", "Lux", Colors.orange),
                    _buildMetricTile("Noise", "$audio", "dB", Colors.blue),
                  ],
                ),
                const SizedBox(height: 25),

                // 📊 THE 4 LIVE GRAPHS
                _buildGraphSection("BPM Trend (Heart Rate)", bpmHistory, Colors.red, 60, 120),
                _buildGraphSection("GSR Trend (Sweat/Stress)", gsrHistory, Colors.green, 0, 100),
                _buildGraphSection("LUX Trend (Light)", luxHistory, Colors.orange, 0, 1000),
                _buildGraphSection("Audio Trend (Sound)", audioHistory, Colors.blue, 30, 100),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateHistory(List<FlSpot> list, double value) {
    if (list.length > 15) list.removeAt(0);
    list.add(FlSpot(timeIndex.toDouble(), value));
  }

  Widget _buildAIHeader(int level, bool isHigh) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHigh ? Colors.red : darkBlue,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Text("AI SENSORY PREDICTION", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          Text("$level%", style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
          Text(isHigh ? "⚠️ ALERT: POTENTIAL OVERLOAD" : "✅ STATUS: STABLE", 
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String val, String unit, Color color) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGraphSection(String title, List<FlSpot> spots, Color color, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Container(
          height: 150,
          padding: const EdgeInsets.only(right: 20, top: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: LineChart(
            LineChartData(
              minY: min, maxY: max,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(getTooltipColor: (spot) => color),
              ),
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  dotData: const FlDotData(show: true), // Clickable points
                  belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}