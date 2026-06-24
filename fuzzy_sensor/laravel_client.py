

import logging
import threading
import time
from typing import Optional

try:
    import requests
    REQUESTS_AVAILABLE = True
except ImportError:
    REQUESTS_AVAILABLE = False

log = logging.getLogger(__name__)


# ════════════════════════════════════════════════════════════════════
#  Default Settings — Adjust according to your environment
# ════════════════════════════════════════════════════════════════════
DEFAULT_LARAVEL_URL = "http://127.0.0.1:8000"   # Laravel URL (dev server)
DEFAULT_API_TOKEN   = "your-laravel-api-token"   # Bearer Token (Sanctum or Passport)
DEFAULT_TIMEOUT     = 5                           # Seconds
LOG_EVERY_N         = 20                          # Send every 20 readings in normal mode


class LaravelClient:
    """
    Responsible for:
      - fetch_profile(patient_id)  → dict  Patient's medical profile
      - log_reading(sensor, fuzzy) → None  Send reading + fuzzy result to Laravel

    Runs on a separate thread when sending so it doesn't block the sensor reading loop.
    """

    def __init__(self,
                 base_url:   str = DEFAULT_LARAVEL_URL,
                 api_token:  str = DEFAULT_API_TOKEN,
                 timeout:    int = DEFAULT_TIMEOUT,
                 log_every:  int = LOG_EVERY_N):

        self._base_url  = base_url.rstrip("/")
        self._headers   = {
            "Authorization": f"Bearer {api_token}",
            "Accept":        "application/json",
            "Content-Type":  "application/json",
        }
        self._timeout   = timeout
        self._lock      = threading.Lock()

        if not REQUESTS_AVAILABLE:
            log.warning("'requests' library is missing - Laravel communication disabled")

    # ────────────────────────────────────────────────────────────────
    #  Fetch patient's medical profile from Laravel
    # ────────────────────────────────────────────────────────────────
    def fetch_profile(self, patient_id: int) -> Optional[dict]:
        """
        Sends GET to: /api/patients/{patient_id}/profile
        Returns dict like: {"heart_disease": true, "diabetes": false, ...}
        or None if connection fails
        """
        if not REQUESTS_AVAILABLE:
            log.warning("requests not available — cannot fetch profile")
            return None

        url = f"{self._base_url}/api/patients/{patient_id}/profile"
        log.info(f"Fetching profile for patient {patient_id} from: {url}")

        try:
            response = requests.get(url, headers=self._headers, timeout=self._timeout)

            if response.status_code == 200:
                data = response.json()

                # Expect Laravel to return data inside "data" or directly
                profile = data.get("data", data)

                # Ensure valid fields are present, fill missing with False
                expected_keys = ["heart_disease", "diabetes", "hypertension", "epilepsy", "elderly"]
                clean_profile = {k: bool(profile.get(k, False)) for k in expected_keys}

                log.info(f"✅ Profile ready: {clean_profile}")
                return clean_profile

            elif response.status_code == 404:
                log.warning(f"⚠️ Patient {patient_id} not found in database")
                return None

            else:
                log.error(f"❌ Laravel returned error code: {response.status_code} — {response.text[:200]}")
                return None

        except requests.exceptions.ConnectionError:
            log.error(f"❌ Cannot connect to Laravel at: {self._base_url}")
            return None

        except requests.exceptions.Timeout:
            log.error(f"❌ Connection timeout ({self._timeout}s) with Laravel")
            return None

        except Exception as e:
            log.error(f"❌ Unexpected error fetching profile: {e}")
            return None

    # ────────────────────────────────────────────────────────────────
    #  Send reading + fuzzy result
    # ────────────────────────────────────────────────────────────────
    def log_reading(self, patient_id: int, wheelchair_id: str, sensor_stats: dict, fuzzy_result: dict, urgent: bool):
        """
        Immediately sends aggregated (or urgent) data in a separate Thread
        """
        if not REQUESTS_AVAILABLE:
            return

        t = threading.Thread(
            target=self._post_log,
            args=(patient_id, wheelchair_id, sensor_stats, fuzzy_result, urgent),
            daemon=True,
            name="LaravelLogThread"
        )
        t.start()

    # ────────────────────────────────────────────────────────────────
    #  Actual sending (runs in a separate thread)
    # ────────────────────────────────────────────────────────────────
    def _post_log(self, patient_id: int, wheelchair_id: str, sensor_stats: dict, fuzzy_result: dict, urgent: bool):
        url = f"{self._base_url}/api/patients/logs"

        payload = {
            "patient_id": patient_id,
            "wheelchair_id": wheelchair_id,
            "urgent":     urgent,
            "sensors_stats": sensor_stats,
            "fuzzy": {
                "score":      fuzzy_result.get("score"),
                "level":      fuzzy_result.get("level"),
                "message":    fuzzy_result.get("message"),
                "reason":     fuzzy_result.get("reason"),
                "base_score": fuzzy_result.get("base_score"),
                "neck_boost": fuzzy_result.get("neck_boost"),
            },
            "recorded_at": time.strftime("%Y-%m-%d %H:%M:%S"),
        }

        label = "🚨 URGENT" if urgent else "📊 periodic"
        log.info(f"Sending data [{label}] to Laravel ← patient_id={patient_id}, level={fuzzy_result.get('level')}")

        try:
            response = requests.post(
                url,
                json=payload,
                headers=self._headers,
                timeout=self._timeout
            )
            if response.status_code in (200, 201):
                log.info(f"✅ Sent successfully: {response.status_code}")
            else:
                log.warning(f"⚠️ Laravel returned: {response.status_code} — {response.text[:200]}")

        except requests.exceptions.ConnectionError:
            log.warning("⚠️ Laravel connection lost — skipped sending")

        except requests.exceptions.Timeout:
            log.warning(f"⚠️ Timeout sending log ({self._timeout}s)")

        except Exception as e:
            log.error(f"❌ Error sending log: {e}")

    # ────────────────────────────────────────────────────────────────
    #  Reset counter (removed because logic moved to SensorThread)
    # ────────────────────────────────────────────────────────────────
    def reset_counter(self):
        pass
