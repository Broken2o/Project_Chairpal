

import threading
import time
import logging
import collections
from typing import Optional

try:
    import serial
    SERIAL_AVAILABLE = True
except ImportError:
    SERIAL_AVAILABLE = False

import sys
import os

if sys.platform == "win32":
    _default_port = os.getenv("SERIAL_PORT", "COM3")
else:
    _default_port = os.getenv("SERIAL_PORT", "/dev/ttyUSB0")

SERIAL_PORT = _default_port
BAUD_RATE   = 115200


SIMULATE = not SERIAL_AVAILABLE or os.getenv("SIMULATE", "0") == "1"

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s [%(threadName)s] %(levelname)s %(message)s")
log = logging.getLogger(__name__)


# ════════════════════════════════════════════════════════════════════
# analyze neck motion
# ════════════════════════════════════════════════════════════════════
class NeckAnalyzer:
    
    HISTORY_SIZE      = 20
    FAINT_TILT_DELTA  = 30   
    FAINT_STILL_GYRO  = 15    
    SEIZURE_GYRO_THR  = 120  
    SEIZURE_MIN_COUNT = 6
    DIZZY_GYRO_THR    = 40   
    FAINT_HOLD_SEC    = 8.0

    def __init__(self):
        self._tilt_h  = collections.deque(maxlen=self.HISTORY_SIZE)
        self._gyro_h  = collections.deque(maxlen=self.HISTORY_SIZE)
        self._faint_t = 0.0

    def update(self, tilt: float, gyro_mag: float,
               has_epilepsy: bool = False) -> dict:
        self._tilt_h.append(tilt)
        self._gyro_h.append(gyro_mag)
        now = time.time()
        res = {"faint": False, "seizure": False,
               "dizziness": False, "neck_state": "normal"}

        if len(self._tilt_h) < 5:
            return res

        # ── Faint ──────────────────────────────────────────────────
        tilt_list  = list(self._tilt_h)
        tilt_delta = abs(tilt_list[-1] - tilt_list[-5])
        if tilt_delta > self.FAINT_TILT_DELTA and gyro_mag < self.FAINT_STILL_GYRO:
            self._faint_t = now
            log.warning(f"FAINT detected! tilt_delta={tilt_delta:.1f}°")

        if now - self._faint_t < self.FAINT_HOLD_SEC:
            res["faint"]      = True
            res["neck_state"] = "faint"
            return res

        # ── (has_epilepsy) ────────────────────────
        if has_epilepsy:
            recent = list(self._gyro_h)[-self.SEIZURE_MIN_COUNT:]
            if sum(1 for g in recent if g > self.SEIZURE_GYRO_THR) >= self.SEIZURE_MIN_COUNT:
                res["seizure"]    = True
                res["neck_state"] = "seizure"
                log.warning("SEIZURE detected!")
                return res

        # ── Dizziness ───────────────────────────────────────────────────
        recent8  = list(self._gyro_h)[-8:]
        avg_gyro = sum(recent8) / len(recent8)
        if self.DIZZY_GYRO_THR < avg_gyro < self.SEIZURE_GYRO_THR:
            res["dizziness"]  = True
            res["neck_state"] = "dizziness"

        return res


# ════════════════════════════════════════════════════════════════════

class ArduinoParser:


    def parse(self, line: str) -> dict | None:
        line = line.strip()
        if not line:
            return None

        result = {}
        segments = line.split("|")

        for seg in segments:
            if ":" not in seg:
                continue
            key, _, val = seg.partition(":")
            key = key.strip()
            val = val.strip()

            try:
                if key == "H":
                    result["hr"] = int(val)

                elif key == "T":
                    result["temp"] = float(val)

                elif key == "N":
                    parts = val.split(",")
                    result["tilt"]     = float(parts[0])
                    result["gyro_mag"] = float(parts[1]) if len(parts) > 1 else 0.0

                elif key == "E":
                    parts = val.split(",")
                    result["speed_left"]  = float(parts[0])
                    result["speed_right"] = float(parts[1]) if len(parts) > 1 else 0.0

                elif key == "I":
                    parts = val.split(",")
                    result["imu_roll"]  = float(parts[0])
                    result["imu_pitch"] = float(parts[1]) if len(parts) > 1 else 0.0
                    result["imu_yaw"]   = float(parts[2]) if len(parts) > 2 else 0.0

                elif key == "U":
                    result["ultrasonic"] = float(val)

                elif key == "P":
                    parts = val.split(",")
                    result["pot_fl"] = float(parts[0])
                    result["pot_fr"] = float(parts[1]) if len(parts) > 1 else 0.0
                    result["pot_rl"] = float(parts[2]) if len(parts) > 2 else 0.0
                    result["pot_rr"] = float(parts[3]) if len(parts) > 3 else 0.0

                elif key == "J":
                    parts = val.split(",")
                    result["joy_x"] = int(parts[0])
                    result["joy_y"] = int(parts[1]) if len(parts) > 1 else 0

                elif key == "TGT":
                    parts = val.split(",")
                    result["tgt_fl"] = float(parts[0])
                    result["tgt_fr"] = float(parts[1]) if len(parts) > 1 else 0.0
                    result["tgt_rl"] = float(parts[2]) if len(parts) > 2 else 0.0
                    result["tgt_rr"] = float(parts[3]) if len(parts) > 3 else 0.0

            except (ValueError, IndexError) as e:
                log.warning(f"Parse error [{key}:{val}] → {e}")
                continue

        # ── Must have the 3 base values ──────────────────────────
        if not all(k in result for k in ("hr", "temp", "tilt", "gyro_mag")):
            log.warning(f"Incomplete line, missing H/T/N: {line}")
            return None

        return result


# ════════════════════════════════════════════════════════════════════
#  SensorThread  
# ════════════════════════════════════════════════════════════════════
class SensorThread(threading.Thread):
   

    def __init__(self,
                 port: str = SERIAL_PORT,
                 baud: int = BAUD_RATE,
                 laravel_client=None,   # LaravelClient instance  None
                 patient_id: int = 1):
        super().__init__(daemon=True, name="SensorThread")
        self._port    = port
        self._baud    = baud
        self._lock    = threading.Lock()
        self._stop    = threading.Event()
        self._neck    = NeckAnalyzer()
        self._parser  = ArduinoParser()
        self._laravel = laravel_client   
        self._patient_id = patient_id

        self._wheelchair_id = os.getenv("WHEELCHAIR_ID", "WC-001")
        self._send_interval = 300  # 5  ()
        self._last_normal_send = time.time()
        self._readings_buffer = []

        self._profile = {
            "heart_disease": False,
            "diabetes":      False,
            "hypertension":  False,
            "epilepsy":      False,
            "elderly":       False,
        }
        self._latest = self._empty()

    # ── Start Thread ────────────────────────────────────────────────
    def start(self):
        self._fetch_profile_from_laravel()
        super().start()

    # ────────────────────────────────────────────────────────────────
    # Get Profile from Laravel
    # ────────────────────────────────────────────────────────────────
    def _fetch_profile_from_laravel(self):

        if self._laravel is None:
            log.info("No LaravelClient — using default profile")
            return

        log.info(f"🔄 Fetching profile from Laravel for patient ID={self._patient_id} ...")
        profile = self._laravel.fetch_profile(self._patient_id)

        if profile:
            with self._lock:
                self._profile.update(profile)
            log.info(f"Profile loaded from Laravel: {self._profile}")
        else:
            log.warning("Failed to fetch profile — using default values (all False)")

    # ── Profile (read/write thread-safe) ────────────────────────────
    def set_patient_profile(self, profile: dict):

        with self._lock:
            self._profile.update(profile)
        log.info(f"Profile updated manually: {self._profile}")

    def get_patient_profile(self) -> dict:
        with self._lock:
            return dict(self._profile)

    # ── Sensor Definitions & Stats ──────────────────────────────────
    def _get_sensor_definition(self, key: str, value: float) -> str:
        if key == "temperature":
            if value < 36.0: return "Low"
            elif value <= 37.5: return "Normal"
            elif value <= 38.5: return "Fever"
            else: return "Very High"
        elif key == "heart_rate":
            if value < 50: return "Slow"
            elif value <= 100: return "Normal"
            elif value <= 140: return "Fast"
            else: return "Critical"
        elif key == "gyro_mag":
            if value < 40: return "Stable"
            elif value < 120: return "Moderate Motion/Dizziness"
            else: return "Violent Motion/Seizure"
        elif key == "tilt_angle":
            if abs(value) < 15: return "Straight"
            elif abs(value) < 30: return "Tilted"
            else: return "Steep Tilt"
        return "Unknown"

    def _compute_stats(self, buffer: list) -> dict:
        if not buffer:
            return {}
        
        stats = {}
        keys_to_track = ["heart_rate", "temperature", "tilt_angle", "gyro_mag"]
        
        for k in keys_to_track:
            values = [b[k] for b in buffer if k in b]
            if not values:
                continue
            v_min = min(values)
            v_max = max(values)
            v_avg = round(sum(values) / len(values), 2)
            
            stats[k] = {
                "min": v_min,
                "max": v_max,
                "avg": v_avg,
                "min_def": self._get_sensor_definition(k, v_min),
                "max_def": self._get_sensor_definition(k, v_max),
                "avg_def": self._get_sensor_definition(k, v_avg),
            }
        
        stats["neck_state"] = buffer[-1].get("neck_state", "normal")
        return stats

    # ── Latest (thread-safe) ────────────────────────────────────────
    @property
    def latest(self) -> dict:
        with self._lock:
            return dict(self._latest)

    def stop(self):
        self._stop.set()

    # ── Empty reading ───────────────────────────────────────────────
    @staticmethod
    def _empty() -> dict:
        return {

            "heart_rate":       0,
            "temperature":      0.0,
            "tilt_angle":       0.0,
            "gyro_mag":         0.0,

            "neck_state":       "normal",
            "faint_detected":   False,
            "seizure_detected": False,
            "dizziness":        False,

            "speed_left":       0.0,
            "speed_right":      0.0,
            "imu_roll":         0.0,
            "imu_pitch":        0.0,
            "imu_yaw":          0.0,
            "ultrasonic":       0.0,
            "pot_fl":           0.0,
            "pot_fr":           0.0,
            "pot_rl":           0.0,
            "pot_rr":           0.0,
            "tgt_fl":           0.0,
            "tgt_fr":           0.0,
            "tgt_rl":           0.0,
            "tgt_rr":           0.0,
            "joy_x":            0,
            "joy_y":            0,
            # ── meta ──
            "timestamp":        0.0,
            "error":            None,
        }

    # ──────────────────────────
    def _enrich(self, raw: dict) -> dict:
       
        from fuzzy_system import evaluate   

        profile = self.get_patient_profile()
        neck    = self._neck.update(
            tilt         = raw.get("tilt",     0.0),
            gyro_mag     = raw.get("gyro_mag", 0.0),
            has_epilepsy = profile.get("epilepsy", False),
        )

        r = self._empty()

        r["heart_rate"]       = raw.get("hr",          0)
        r["temperature"]      = raw.get("temp",         0.0)
        r["tilt_angle"]       = raw.get("tilt",         0.0)
        r["gyro_mag"]         = raw.get("gyro_mag",     0.0)

        r["neck_state"]       = neck["neck_state"]
        r["faint_detected"]   = neck["faint"]
        r["seizure_detected"] = neck["seizure"]
        r["dizziness"]        = neck["dizziness"]

        r["speed_left"]       = raw.get("speed_left",  0.0)
        r["speed_right"]      = raw.get("speed_right", 0.0)
        r["imu_roll"]         = raw.get("imu_roll",    0.0)
        r["imu_pitch"]        = raw.get("imu_pitch",   0.0)
        r["imu_yaw"]          = raw.get("imu_yaw",     0.0)
        r["ultrasonic"]       = raw.get("ultrasonic",  0.0)
        r["pot_fl"]           = raw.get("pot_fl",      0.0)
        r["pot_fr"]           = raw.get("pot_fr",      0.0)
        r["pot_rl"]           = raw.get("pot_rl",      0.0)
        r["pot_rr"]           = raw.get("pot_rr",      0.0)
        r["tgt_fl"]           = raw.get("tgt_fl",      0.0)
        r["tgt_fr"]           = raw.get("tgt_fr",      0.0)
        r["tgt_rl"]           = raw.get("tgt_rl",      0.0)
        r["tgt_rr"]           = raw.get("tgt_rr",      0.0)
        r["joy_x"]            = raw.get("joy_x",       0)
        r["joy_y"]            = raw.get("joy_y",       0)
        r["timestamp"]        = round(time.time(), 3)
        r["error"]            = None

        # ── Turn of Fuzzy ─────────────────────────────────────────
       
        accel_approx = 1.0 + (r["gyro_mag"] / 200.0)

        fuzzy_result = evaluate(
            heart_rate_val  = r["heart_rate"],
            temperature_val = r["temperature"],
            accel_val       = accel_approx,
            neck_state      = r["neck_state"],
            profile         = profile,
        )
        r["fuzzy"] = fuzzy_result

        # ── Accumulate data and send every 5 mins or on emergency ─────────
        is_urgent = fuzzy_result.get("level") in ("Danger", "Emergency")
        now = time.time()

        with self._lock:
            self._readings_buffer.append(r)
            
            should_send = False
            if is_urgent:
                should_send = True
            elif (now - self._last_normal_send) >= self._send_interval:
                should_send = True

            if should_send:
                buffer_copy = list(self._readings_buffer)
                self._readings_buffer.clear()
                self._last_normal_send = now

        if should_send and self._laravel is not None:
            stats = self._compute_stats(buffer_copy)
            self._laravel.log_reading(
                patient_id    = self._patient_id,
                wheelchair_id = self._wheelchair_id,
                sensor_stats  = stats,
                fuzzy_result  = fuzzy_result,
                urgent        = is_urgent
            )

        return r

    # ── Simulate ────────────────────────────────────────────────────
    @staticmethod
    def _sim_line() -> str:
        import random
        sl  = round(random.uniform(0, 1), 2)
        sr  = round(random.uniform(0, 1), 2)
        jx  = random.randint(-50, 50)
        jy  = random.randint(-50, 50)
        u   = round(random.uniform(20, 150), 1)
        p   = [round(random.uniform(-10, 10), 1) for _ in range(4)]
        ro  = round(random.uniform(-5, 5), 2)
        pi  = round(random.uniform(-5, 5), 2)
        ya  = round(random.uniform(-5, 5), 2)
        hr  = random.randint(60, 130)
        tmp = round(random.uniform(36.0, 39.0), 1)
        tlt = round(random.uniform(-10, 10), 2)
        gm  = round(random.uniform(0, 30), 2)
        tgt = [round(random.uniform(-45, 45), 1) for _ in range(4)]
        return (f"E:{sl},{sr}|J:{jx},{jy}|U:{u}"
                f"|P:{p[0]},{p[1]},{p[2]},{p[3]}"
                f"|TGT:{tgt[0]},{tgt[1]},{tgt[2]},{tgt[3]}"
                f"|I:{ro},{pi},{ya}|H:{hr}|T:{tmp}|N:{tlt},{gm}")

    # ── Run ─────────────────────────────────────────────────────────
    def run(self):
        log.info(f"SensorThread started (simulate={SIMULATE})")
        if SIMULATE:
            self._run_simulated()
        else:
            self._run_serial()

    def _run_simulated(self):
        while not self._stop.is_set():
            raw = self._parser.parse(self._sim_line())
            if raw:
                enriched = self._enrich(raw)
                with self._lock:
                    self._latest = enriched
            time.sleep(0.1)   

    def _run_serial(self):
        ser = None
        while not self._stop.is_set():
            try:
                if ser is None or not ser.is_open:
                    ser = serial.Serial(self._port, self._baud, timeout=2)
                    log.info(f"Serial connected: {self._port}")

                line = ser.readline().decode("utf-8", errors="ignore").strip()
                if not line:
                    continue

                raw = self._parser.parse(line)
                if raw:
                    enriched = self._enrich(raw)
                    with self._lock:
                        self._latest = enriched
                    fuzzy_res = enriched.get('fuzzy', {})
                    log.info(
                        f"[RESULT] HR={enriched['heart_rate']} | "
                        f"Temp={enriched['temperature']} | "
                        f"Neck={enriched['neck_state']} --> "
                        f"Level={fuzzy_res.get('level', 'N/A')} "
                        f"(Score={fuzzy_res.get('score', 0)}) | "
                        f"Reason: {fuzzy_res.get('reason', '')}"
                    )

            except Exception as e:
                log.error(f"Serial error: {e} — retry in 3s")
                if ser:
                    try: ser.close()
                    except: pass
                ser = None
                with self._lock:
                    self._latest["error"] = str(e)
                time.sleep(3)


# ==============================================================================
# Raspberry Pi (Standalone)
# ==============================================================================
if __name__ == "__main__":
    import os
    from laravel_client import LaravelClient

    logging.getLogger().setLevel(logging.INFO)

    print("=" * 60)
    print("  [*] Starting Sensor and Fuzzy System on Raspberry Pi")
    print("=" * 60)

    LARAVEL_URL = os.getenv("LARAVEL_URL", "http://127.0.0.1:8000")
    LARAVEL_TOKEN = os.getenv("LARAVEL_TOKEN", "your-laravel-api-token")
    PATIENT_ID = int(os.getenv("PATIENT_ID", "1"))

    lc = LaravelClient(base_url=LARAVEL_URL, api_token=LARAVEL_TOKEN)

    st = SensorThread(laravel_client=lc, patient_id=PATIENT_ID)
    st.daemon = False  
    st.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[!] Shutting down...")
        st.stop()