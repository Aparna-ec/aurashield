#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>

// Helper login info
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

// 1. WiFi Credentials
#define WIFI_SSID "Meritta"
#define WIFI_PASSWORD "eliz1234"

// 2. Firebase Credentials (Use Database Secret for Legacy Auth)
#define DATABASE_SECRET "YOUR_DATABASE_SECRET_KEY_HERE"
#define DATABASE_URL "https://aurashield-a5e04-default-rtdb.firebaseio.com/"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

void setup() {
  Serial.begin(115200);
  
  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(300);
    Serial.print(".");
  }
  Serial.println("\nConnected!");

  // 📍 FIX: Correct Legacy Auth Setup
  config.database_url = DATABASE_URL;
  config.signer.tokens.legacy_token = DATABASE_SECRET; // This replaces auth.user.legacy_token

  // 📍 FIX: Move these lines INSIDE the setup() brackets
  config.token_status_callback = tokenStatusCallback; 
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  
  signupOK = true; 
}

void loop() {
  // 🕒 10-SECOND DELAY (Better for a fast-paced demo)
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 10000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    
    // 📍 INCREASED RANGES: Trigger the AI and Alert Screen
    int dummyBPM = random(95, 125);    // Higher Heart Rate
    int dummyLux = random(600, 950);   // Brighter Light
    int dummyAudio = random(75, 98);   // Louder Noise
    int dummyGSR = random(60, 90);     // 📍 ADDED: Stress/Sweat value
    int dummyGSM = random(20, 31);

    // 1. Send BPM
    Firebase.RTDB.setInt(&fbdo, "live_vitals/bpm", dummyBPM);

    // 2. Send Lux
    Firebase.RTDB.setInt(&fbdo, "live_vitals/lux", dummyLux);

    // 3. Send Audio
    Firebase.RTDB.setInt(&fbdo, "live_vitals/audio_db", dummyAudio);

    // 4. Send GSR (Fixed path for Flutter dashboard)
    Firebase.RTDB.setInt(&fbdo, "live_vitals/gsr", dummyGSR);

    // 5. Send GSM Status
    Firebase.RTDB.setInt(&fbdo, "live_vitals/gsm_signal", dummyGSM);

    Serial.printf("SENT ALERT DATA >> BPM: %d | Lux: %d | Audio: %d | GSR: %d\n", 
                  dummyBPM, dummyLux, dummyAudio, dummyGSR);
  }
}