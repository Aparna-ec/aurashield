# aurashield
<p align="center">
<img src="" alt="Project Banner" width="100%">
</p>

AuraShield 🛡️🎯
Basic Details
Team Name: Aparna Suresh
Team Member:
Aparna Suresh - Mar Athanasius College of Engineering (MACE)

Hosted Project Link: nil

Project Description
AuraShield is a sophisticated bio-sensory integration platform designed as a clinical-grade assistive ecosystem for neurodivergent individuals. It utilizes a high-fidelity sensor network and predictive machine learning (Random Forest) to analyze physiological markers and environmental stressors in real-time. The system functions as a continuous feedback loop that bridges the gap between biological stress triggers and immediate therapeutic intervention.

The Problem Statement
Individuals with Autism Spectrum Disorder (ASD) and sensory processing sensitivities often experience profound "sensory meltdowns"—acute physiological distress caused by environmental stimuli that others might ignore. Because these triggers are often internal or invisible, caregivers are frequently caught off-guard, reacting only after the child is in crisis. This lack of objective, real-time data creates a persistent state of anxiety for families and can lead to long-term developmental setbacks for the individual.

The Solution
AuraShield solves this by transforming subjective biological distress into actionable data. Our implementation model uses:

Multi-Modal Sensing: Real-time tracking of Heart Rate (BPM), Skin Resistance (GSR), Ambient Noise (dB), and Light Intensity (Lux) to map the user's "Sensory Fingerprint."

Predictive AI Analytics: A Python-based intelligence layer that calculates the probability of a sensory overload before it manifests physically, providing a critical "Golden Window" for intervention.

Automated Calming Ecosystem: An immediate response system that can trigger localized environmental adjustments (e.g., haptic feedback, "breathing" light therapy, or automated playlists) via a connected IoT framework.

Cloud-Synchronized Caregiving: A Flutter-based mobile dashboard that empowers parents with remote monitoring, historical trend analysis, and manual intervention controls through a secure, Firebase-powered backend.

Technical Details
Technologies/Components Used
For Software:

Languages used: Dart (Flutter), Python, C++ (Arduino)

Frameworks used: Flutter

Libraries used: firebase_esp_client, firebase_admin, scikit-learn, pandas, fl_chart, cloud_firestore

Tools used: VS Code, Cursor AI, Firebase Console, Arduino IDE

For Hardware:

Main components: ESP8266 (NodeMCU), Pulse Sensor (BPM), LDR (Light), Sound Module (dB), LED (Intervention)

Specifications: Wi-Fi enabled real-time data streaming; 20-second sampling interval for demo stability.

Tools required: Soldering iron (or breadboard), Jumper wires, USB power source.

Features
Real-time Vitals Monitoring: Streams BPM, Lux, and Decibel levels to the cloud via Firebase.

AI Stress Prediction: A Random Forest model analyzes multi-sensor data to predict sensory overload probability.

Interactive Live Dashboard: Four synchronized real-time graphs with interactive data points for physiological trends.

Smart Intervention: Automatic "Calm Mode" trigger that activates pulsing LED hardware and music playlists when stress exceeds 70%.

Secure Child Profile: Firestore-based registration for saving medical thresholds and a secure 4-digit safety PIN.

Implementation
For Software:
Installation
Run
For Hardware:
Components Required
ESP8266 (NodeMCU)

LDR + 10kΩ Resistor

Sound Sensor Module

LED + 220Ω Resistor

Breadboard & Jumper wires

Circuit Setup
The LDR is connected to the Analog pin (A0) using a voltage divider. The Sound module is connected to D2 (Digital input), and the intervention LED is connected to D1 (PWM output) for the breathing light effect.

Project Documentation
For Software:
Diagrams
System Architecture:

Sensors collect environmental/physiological data.

ESP8266 pushes data to Firebase Realtime Database.

Python Script listens to data, runs the Random Forest prediction, and writes the stress percentage back to Firebase.

Flutter App displays the data and pops an Alert Screen if the AI predicts >70% stress.

For Hardware:
Schematic & Circuit
The circuit utilizes the ESP8266's Wi-Fi capabilities to maintain a persistent connection to the AuraShield Firebase instance.

Additional Documentation
For Mobile Apps:
Installation Guide (Android APK)
Download the aurashield.apk from the release section.

Enable "Install from Unknown Sources" in Settings.

Complete the "Child Profile Setup" to access the dashboard.

For Hardware Projects:
Bill of Materials (BOM)
ESP32 DevBoard: ₹420 (Better for AI than 8266)

BH1750 (Lux): ₹190

MAX30102 (Pulse): ₹280

Sound Module: ₹80

WS2812B (1m): ₹250

TOTAL: ~₹1,220
AI Tools Used
Tool Used: Gemini
Purpose: - Generating boilerplate code for Firebase connectivity.

Debugging Python-Firebase library version mismatches.

Optimizing Flutter UI for real-time graph performance.

Percentage of AI-generated code: Approximately 40%

Human Contributions:

Architecture design and planning
Custom business logic implementation
Integration and testing
UI/UX design decisions
demo video:


https://github.com/user-attachments/assets/bf24c578-59ab-4e4c-b119-6a4aebcdc037



Team Contributions
Aparna Suresh:both hardware and software
License
This project is licensed under the MIT License.

Made with ❤️ at TinkerHub | Team Aparna Suresh
