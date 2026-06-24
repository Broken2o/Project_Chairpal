

import numpy as np
import logging

log = logging.getLogger(__name__)


# ════════════════════════════════════════════════════════════════════
#    (Membership Functions) —  
# ════════════════════════════════════════════════════════════════════

def _trimf(x: float, a: float, b: float, c: float) -> float:
    """  :  0  [a,c]  1  b."""
    if x < a or x > c:
        return 0.0
    elif x <= b:
        return (x - a) / (b - a) if b != a else 1.0
    else:
        return (c - x) / (c - b) if c != b else 1.0


def _trapmf(x: float, a: float, b: float, c: float, d: float) -> float:
    """    (trapezoidal)."""
    if x < a or x > d:
        return 0.0
    elif x <= b:
        return (x - a) / (b - a) if b != a else 1.0
    elif x <= c:
        return 1.0
    else:
        return (d - x) / (d - c) if d != c else 1.0


# ════════════════════════════════════════════════════════════════════
#     
# ════════════════════════════════════════════════════════════════════

def _hr_memberships(hr: float) -> dict:
    """      ."""
    return {
        "low":      _trapmf(hr,   0,   0,   40,  59),
        "normal":   _trimf (hr,  50,   75, 100),
        "high":     _trimf (hr,  90,  120, 150),
        "critical": _trapmf(hr, 140,  180, 220, 220),
    }


def _temp_memberships(temp: float) -> dict:
    """      ."""
    return {
        "hypothermia": _trapmf(temp, 0.0, 34.0, 35.0, 36.0),
        "normal":      _trimf (temp, 35.5, 36.6, 37.5),
        "fever":       _trimf (temp, 37.0, 38.0, 39.0),
        "high_fever":  _trapmf(temp, 38.5, 40.0, 43.0, 43.0),
    }


def _accel_memberships(accel: float) -> dict:
    """      ."""
    return {
        "still":  _trapmf(accel, 0.0, 0.0, 1.0, 1.3),
        "moving": _trimf (accel, 1.1, 1.8, 2.5),
        "strong": _trapmf(accel, 2.2, 3.5, 5.0, 5.0),
    }


# ════════════════════════════════════════════════════════════════════
#    Output Fuzzy Sets (midpoints for defuzzification)
# ════════════════════════════════════════════════════════════════════
OUTPUT_CENTROIDS = {
    "normal":    15.0,
    "warning":   42.0,
    "danger":    67.0,
    "emergency": 90.0,
}


# ════════════════════════════════════════════════════════════════════
#     (Base Rules)
# ════════════════════════════════════════════════════════════════════

def _apply_base_rules(hr_m: dict, temp_m: dict, accel_m: dict) -> list:
    """
          (output_set, strength).
    """
    rules = []

    # Rule 1:   +   = 
    r = min(hr_m["normal"], temp_m["normal"])
    rules.append(("normal", r))

    # Rule 2:     = 
    r = max(hr_m["high"], temp_m["fever"])
    rules.append(("warning", r))

    # Rule 3:   = 
    rules.append(("warning", hr_m["low"]))

    # Rule 4:   = 
    rules.append(("emergency", hr_m["critical"]))

    # Rule 5:   = 
    rules.append(("danger", temp_m["high_fever"]))

    # Rule 6:   = 
    rules.append(("danger", temp_m["hypothermia"]))

    # Rule 7:   +  = 
    r = min(hr_m["high"], temp_m["fever"])
    rules.append(("danger", r))

    # Rule 8:   +   = 
    r = min(hr_m["low"], accel_m["strong"])
    rules.append(("emergency", r))

    return rules


# ════════════════════════════════════════════════════════════════════
#     
# ════════════════════════════════════════════════════════════════════

def _apply_condition_rules(condition: str,
                           hr_m: dict, temp_m: dict, accel_m: dict) -> list:
    """     ."""
    rules = []

    if condition == "heart_disease":
        rules.append(("danger",    hr_m["high"]))
        rules.append(("emergency", hr_m["critical"]))
        rules.append(("danger",    min(hr_m["low"], temp_m["fever"])))
        rules.append(("danger",    min(hr_m["low"], accel_m["still"])))

    elif condition == "diabetes":
        rules.append(("danger",   min(temp_m["hypothermia"], accel_m["still"])))
        rules.append(("danger",   min(hr_m["high"], temp_m["fever"])))
        rules.append(("warning",  min(hr_m["high"], accel_m["still"])))

    elif condition == "hypertension":
        rules.append(("danger",    hr_m["high"]))
        rules.append(("emergency", min(hr_m["high"], temp_m["fever"])))
        rules.append(("emergency", hr_m["critical"]))

    elif condition == "epilepsy":
        rules.append(("emergency", accel_m["strong"]))
        rules.append(("danger",    min(hr_m["high"], accel_m["moving"])))

    elif condition == "elderly":
        rules.append(("danger",    temp_m["fever"]))
        rules.append(("emergency", temp_m["high_fever"]))
        rules.append(("danger",    hr_m["high"]))
        rules.append(("danger",    hr_m["low"]))
        rules.append(("emergency", hr_m["critical"]))
        rules.append(("emergency", accel_m["strong"]))

    return rules


# ════════════════════════════════════════════════════════════════════
#  Defuzzification — Weighted Average (Sugeno-style)
# ════════════════════════════════════════════════════════════════════

def _defuzzify(rules: list) -> float:
    """
      score     
    Weighted Average (Centroid ).
    """
    numerator   = 0.0
    denominator = 0.0

    for output_set, strength in rules:
        if strength > 0:
            centroid     = OUTPUT_CENTROIDS[output_set]
            numerator   += strength * centroid
            denominator += strength

    if denominator == 0:
        return 15.0   #     = 

    return numerator / denominator


# ════════════════════════════════════════════════════════════════════
#    
# ════════════════════════════════════════════════════════════════════
CONDITION_WEIGHTS = {
    "heart_disease": 1.4,
    "diabetes":      1.2,
    "hypertension":  1.3,
    "epilepsy":      1.5,
    "elderly":       1.2,
}

#    Score    
NECK_BOOST = {
    "normal":    0,
    "dizziness": 15,
    "faint":     40,
    "seizure":   60,
}


# ════════════════════════════════════════════════════════════════════
#   
# ════════════════════════════════════════════════════════════════════

def evaluate(heart_rate_val:  float,
             temperature_val: float,
             accel_val:       float,
             neck_state:      str  = "normal",
             profile:         dict = None) -> dict:
    """
    Parameters
    ----------
    heart_rate_val  : BPM (0-220)
    temperature_val :   (34-43)
    accel_val       :   g (0-5)
    neck_state      : normal | faint | dizziness | seizure
    profile         : {"heart_disease": True, "diabetes": True, ...}

    Returns
    -------
    {"score", "level", "message", "reason", "base_score", "neck_boost"}
    """
    if profile is None:
        profile = {}

    # ── clip     ────────────────────────────────
    hr   = float(np.clip(heart_rate_val,  0,   220))
    temp = float(np.clip(temperature_val, 34,  43))
    acc  = float(np.clip(accel_val,       0,   5))

    # ──    ──────────────────────────────────────────
    hr_m    = _hr_memberships(hr)
    temp_m  = _temp_memberships(temp)
    accel_m = _accel_memberships(acc)

    # ──    ────────────────────────────────────────
    active_conditions = [k for k, v in profile.items() if v]

    if not active_conditions:
        #    —    
        base_rules = _apply_base_rules(hr_m, temp_m, accel_m)
        base_score = _defuzzify(base_rules)
        scores     = [base_score]
        weights    = [1.0]
    else:
        #  score    
        scores  = []
        weights = []
        for cond in active_conditions:
            cond_rules  = (_apply_base_rules(hr_m, temp_m, accel_m)
                           + _apply_condition_rules(cond, hr_m, temp_m, accel_m))
            cond_score  = _defuzzify(cond_rules)
            scores.append(cond_score)
            weights.append(CONDITION_WEIGHTS.get(cond, 1.0))

    # ── Weighted Average ─────────────────────────────────────────────
    total_w    = sum(weights)
    base_score = sum(s * w for s, w in zip(scores, weights)) / total_w

    #       emergency  
    max_single = max(scores)
    if max_single >= 75:
        base_score = max(base_score, max_single)

    # ── Neck State Boost ─────────────────────────────────────────────
    neck_boost  = NECK_BOOST.get(neck_state, 0)
    final_score = min(100.0, base_score + neck_boost)

    # ──   ───────────────────────────────────────────────
    if final_score < 30:
        level   = "Normal"
        message = "Patient in stable condition"
    elif final_score < 55:
        level   = "Warning"
        message = "Warning - Monitor patient"
    elif final_score < 75:
        level   = "Danger"
        message = "Danger - Intervention needed"
    else:
        level   = "Emergency"
        message = "Emergency - Act immediately!"

    # ──    ────────────────────────────────────────────
    reasons = []
    if neck_state == "faint":    reasons.append("Faint detected")
    if neck_state == "seizure":  reasons.append("Seizure detected")
    if neck_state == "dizziness":reasons.append("Dizziness")
    if hr  >= 140:               reasons.append(f"Critical HR ({hr:.0f} BPM)")
    elif hr <= 50:               reasons.append(f"Slow HR ({hr:.0f} BPM)")
    elif hr >= 100:              reasons.append(f"Fast HR ({hr:.0f} BPM)")
    if temp >= 38.5:             reasons.append(f"High Fever ({temp:.1f}°C)")
    elif temp <= 36.0:           reasons.append(f"Low Temp ({temp:.1f}°C)")
    if acc >= 2.2:               reasons.append(f"Strong Motion ({acc:.1f}g)")

    log.debug(
        f"Fuzzy: hr={hr}, temp={temp}, acc={acc:.2f}, "
        f"neck={neck_state} → score={final_score:.1f} [{level}]"
    )

    return {
        "score":      round(final_score, 1),
        "level":      level,
        "message":    message,
        "reason":     " | ".join(reasons) if reasons else "Normal readings",
        "base_score": round(base_score, 1),
        "neck_boost": neck_boost,
    }