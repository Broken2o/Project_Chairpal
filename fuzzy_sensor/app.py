"""
app.py  — Flask REST API
========================
Main server entry point.

Endpoints:
  GET  /health             → Check server health
  GET  /status             → Current readings + fuzzy result (for Flutter App)
  GET  /raw                → Raw readings without fuzzy
  POST /profile            → Update medical profile manually (and sync with Laravel)
  POST /patient            → Change current patient and fetch profile from Laravel

Run:
  python app.py
"""

import logging
import os
import socket
import time

from flask import Flask, jsonify, request
from flask_cors import CORS

from laravel_client import LaravelClient
from sensor_thread  import SensorThread
from fuzzy_system   import evaluate

# ════════════════════════════════════════════════════════════════════
#  Logging
# ════════════════════════════════════════════════════════════════════
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
log = logging.getLogger("app")

# ════════════════════════════════════════════════════════════════════

LARAVEL_URL   = os.getenv("LARAVEL_URL",   "http://127.0.0.1:8000")
LARAVEL_TOKEN = os.getenv("LARAVEL_TOKEN", "your-laravel-api-token")
PATIENT_ID    = int(os.getenv("PATIENT_ID", "1"))

# ════════════════════════════════════════════════════════════════════


laravel = LaravelClient(
    base_url  = LARAVEL_URL,
    api_token = LARAVEL_TOKEN,
    log_every = 20,  
)

sensor = SensorThread(
    laravel_client = laravel,
    patient_id     = PATIENT_ID,
)
sensor.start()   

app = Flask(__name__)
CORS(app)   

# ════════════════════════════════════════════════════════════════════
#  Helpers
# ════════════════════════════════════════════════════════════════════
def _local_ip() -> str:

    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "127.0.0.1"


# ════════════════════════════════════════════════════════════════════
#  Endpoints
# ════════════════════════════════════════════════════════════════════

@app.route("/health", methods=["GET"])
def health():
    
    data = sensor.latest
    return jsonify({
        "status":      "ok",
        "patient_id":  PATIENT_ID,
        "laravel_url": LARAVEL_URL,
        "simulate":    data.get("error") is None,
        "uptime_ts":   time.time(),
    })


@app.route("/status", methods=["GET"])
def status():
    

    data    = sensor.latest
    profile = sensor.get_patient_profile()

    fuzzy = data.get("fuzzy")

    if not fuzzy:
        fuzzy = evaluate(
            heart_rate_val  = data.get("heart_rate",  70),
            temperature_val = data.get("temperature", 37.0),
            accel_val       = 1.0 + (data.get("gyro_mag", 0.0) / 200.0),
            neck_state      = data.get("neck_state", "normal"),
            profile         = profile,
        )

    return jsonify({
        "patient_id": PATIENT_ID,
        "profile": profile,
        "sensors": {
            "heart_rate":  data.get("heart_rate"),
            "temperature": data.get("temperature"),
            "tilt_angle":  data.get("tilt_angle"),
            "gyro_mag":    data.get("gyro_mag"),
            "timestamp":   data.get("timestamp"),
        },
        "neck": {
            "state":            data.get("neck_state"),
            "faint_detected":   data.get("faint_detected"),
            "seizure_detected": data.get("seizure_detected"),
            "dizziness":        data.get("dizziness"),
        },
        "robot": {
            "speed_left":  data.get("speed_left"),
            "speed_right": data.get("speed_right"),
            "imu_roll":    data.get("imu_roll"),
            "imu_pitch":   data.get("imu_pitch"),
            "imu_yaw":     data.get("imu_yaw"),
            "ultrasonic":  data.get("ultrasonic"),
            "joy_x":       data.get("joy_x"),
            "joy_y":       data.get("joy_y"),
        },
        "fuzzy": fuzzy,
        "error": data.get("error"),
    })


# ──────────────────────────────
@app.route("/raw", methods=["GET"])
def raw():
    
    data = sensor.latest
    return jsonify({
        "patient_id": PATIENT_ID,
        "sensors":    data,
    })


# ─────────────────────────
@app.route("/profile", methods=["POST"])
def update_profile():
    
    body = request.get_json(silent=True) or {}
    if not body:
        return jsonify({"error": "Data is empty or invalid"}), 400

    allowed_keys = {"heart_disease", "diabetes", "hypertension", "epilepsy", "elderly"}
    profile_update = {k: bool(v) for k, v in body.items() if k in allowed_keys}

    if not profile_update:
        return jsonify({"error": f"Invalid keys — allowed: {list(allowed_keys)}"}), 400

    sensor.set_patient_profile(profile_update)
    updated_profile = sensor.get_patient_profile()
    laravel.reset_counter()  

    log.info(f" /profile: Updated → {updated_profile}")
    return jsonify({
        "message": "Medical profile updated",
        "profile": updated_profile,
    })


@app.route("/patient", methods=["POST"])
def change_patient():
   
    global PATIENT_ID

    body = request.get_json(silent=True) or {}
    new_id = body.get("patient_id")

    if not isinstance(new_id, int) or new_id <= 0:
        return jsonify({"error": "patient_id must be a positive integer"}), 400

    old_id = PATIENT_ID
    PATIENT_ID = new_id
    sensor._patient_id = new_id

    profile = laravel.fetch_profile(new_id)
    if profile:
        sensor.set_patient_profile(profile)
        laravel.reset_counter()
        log.info(f"✅ Patient changed: {old_id} → {new_id}")
        return jsonify({
            "message":    f"Changed patient to ID={new_id}",
            "patient_id": new_id,
            "profile":    profile,
        })
    else:
        PATIENT_ID = old_id
        sensor._patient_id = old_id
        return jsonify({
            "error":   f"Failed to fetch profile for patient {new_id} from Laravel",
            "patient_id": old_id,
        }), 502


# ════════════════════════════════════════════════════════════════════
# Turn On
# ════════════════════════════════════════════════════════════════════
if __name__ == "__main__":

    import sys
    if sys.platform == "win32":
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8", errors="replace")

    local_ip = _local_ip()
    port     = int(os.getenv("PORT", "5000"))

    sep = "=" * 60
    print(f"\n{sep}")
    print(f"  [*] Patient Monitor — Python Flask Backend")
    print(sep)
    print(f"  [+] Server running on:")
    print(f"      Local:   http://127.0.0.1:{port}")
    print(f"      Network: http://{local_ip}:{port}  <-- use this in Flutter")
    print(f"  [+] Patient ID : {PATIENT_ID}")
    print(f"  [+] Laravel URL: {LARAVEL_URL}")
    print(sep)
    print(f"  Available Endpoints:")
    print(f"    GET  http://{local_ip}:{port}/health   -- server health check")
    print(f"    GET  http://{local_ip}:{port}/status   -- Flutter: sensors + fuzzy")
    print(f"    GET  http://{local_ip}:{port}/raw      -- raw sensor readings")
    print(f"    POST http://{local_ip}:{port}/profile  -- update medical profile")
    print(f"    POST http://{local_ip}:{port}/patient  -- change active patient")
    print(f"{sep}\n")

    app.run(host="0.0.0.0", port=port, debug=False, threaded=True)
