import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import firebase_admin
from firebase_admin import credentials, db
import time

# 1. Load the "AuraShield" Knowledge (Keep this exactly as you had it)
feature_names = ['bpm', 'audio', 'lux'] # 📍 Store the names here
data = {
    'bpm': [70, 115, 75, 120, 80, 105],
    'audio': [40, 90, 45, 95, 50, 85],
    'lux': [100, 900, 150, 950, 200, 800],
    'label': [0, 1, 0, 1, 0, 1]
}
df = pd.DataFrame(data)

# 2. Train the Model
X = df[feature_names]
y = df['label']
model = RandomForestClassifier()
model.fit(X, y)
print("AI Training Complete! 🛡️")

# 3. Connect to Firebase (Ensure your JSON is in the folder)
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://aurashield-a5e04-default-rtdb.firebaseio.com/'
})

is_paused_for_action = False

# 4. Corrected Prediction Loop
def vitals_listener(event):
    global is_paused_for_action
    
    if event.data and not is_paused_for_action:
        try:
            vitals = db.reference('live_vitals').get()
            if vitals and all(k in vitals for k in ('bpm', 'audio_db', 'lux')):
                
                # ✅ FIXED: Create a DataFrame with column names to stop the warning
                live_data_df = pd.DataFrame(
                    [[vitals['bpm'], vitals['audio_db'], vitals['lux']]], 
                    columns=feature_names
                )
                
                # Use the DataFrame for prediction instead of a raw list
                probabilities = model.predict_proba(live_data_df)
                stress_percentage = int(probabilities[0][1] * 100)
                
                if stress_percentage >= 70:
                    is_paused_for_action = True
                    db.reference('alerts').update({
                        'status': "STRESS",
                        'stress_percent': stress_percentage,
                        'action_taken': "none",
                        'last_updated': int(time.time() * 1000)
                    })
                    print(f"⚠️ ALERT: {stress_percentage}% Stress. Waiting for user...")
                else:
                    db.reference('alerts').update({
                        'status': "CALM",
                        'stress_percent': stress_percentage,
                        'last_updated': int(time.time() * 10000)
                    })

        except Exception as e:
            print(f"Error: {e}")

def action_listener(event):
    global is_paused_for_action
    if event.data in ["calm", "cancel"]:
        db.reference('alerts').update({
            'status': "CALM",
            'stress_percent': 0,
            'action_taken': "reset" 
        })
        time.sleep(5) 
        is_paused_for_action = False
        print("🤖 AI Monitoring Resumed.")

db.reference('live_vitals').listen(vitals_listener)
db.reference('alerts/action_taken').listen(action_listener)