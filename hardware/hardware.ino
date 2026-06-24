#include <Wire.h>
#include <MPU6050.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// =====================
// PIN DEFINITIONS
// =====================
#define BTS_RIGHT_RPWM  2
#define BTS_RIGHT_LPWM  3
#define BTS_LEFT_RPWM   6
#define BTS_LEFT_LPWM   5

#define ROT_RB_IN1      4
#define ROT_RB_IN2      7
#define ROT_RF_IN3      8
#define ROT_RF_IN4      9

#define ROT_LF_IN1      10
#define ROT_LF_IN2      11
#define ROT_LB_IN3      12
#define ROT_LB_IN4      44

#define ENC_RIGHT_A     18
#define ENC_LEFT_A      19
#define ENC_RIGHT_B     28
#define ENC_LEFT_B      29

#define TRIG_PIN        22
#define ECHO_PIN        23
#define TEMP_PIN        24

#define ECG_PIN         A0
#define LO_PLUS         25
#define LO_MINUS        26

#define POT_FL          A4
#define POT_BR          A3
#define POT_FR          A2
#define POT_BL          A1

#define JOY_X           A5
#define JOY_Y           A6

#define ROS_CMD_TIMEOUT 2000 // مدة الأمان: ثانيتين

// =====================
// OBJECTS & GLOBAL VARS
// =====================
MPU6050 mpuRobot(0x68);
MPU6050 mpuNeck(0x69);
OneWire oneWire(TEMP_PIN);
DallasTemperature tempSensor(&oneWire);

volatile long encRightCount = 0;
volatile long encLeftCount  = 0;
unsigned long lastEncTime   = 0;
float speedRight = 0, speedLeft = 0;
#define WHEEL_CIRCUMFERENCE 0.377
#define ENCODER_PPR         2860

unsigned long lastSendTime = 0;
unsigned long lastCmdTime  = 0;
#define SEND_INTERVAL       100

int bpm = 0;
unsigned long lastBeatTime = 0;
bool rosActive = false;
String inputBuffer = "";

float targetFL = 0, targetFR = 0, targetRL = 0, targetRR = 0;

// =====================
// INTERRUPTS
// =====================
void countRightA() { if (digitalRead(ENC_RIGHT_B) == LOW) encRightCount++; else encRightCount--; }
void countLeftA() { if (digitalRead(ENC_LEFT_B) == LOW) encLeftCount++; else encLeftCount--; }

// =====================
// MOTOR CONTROL
// =====================
void setDriveMotors(float leftSpeed, float rightSpeed) {
  int leftPWM  = constrain(abs(leftSpeed)  * 255, 0, 255);
  int rightPWM = constrain(abs(rightSpeed) * 255, 0, 255);

  analogWrite(BTS_LEFT_RPWM, (leftSpeed > 0) ? leftPWM : 0);
  analogWrite(BTS_LEFT_LPWM, (leftSpeed < 0) ? leftPWM : 0);
  analogWrite(BTS_RIGHT_RPWM, (rightSpeed > 0) ? rightPWM : 0);
  analogWrite(BTS_RIGHT_LPWM, (rightSpeed < 0) ? rightPWM : 0);
}

// دالة التحكم في موتور التوجيه المعدلة بدون بحاجة للـ Invert Flags
void setRotationMotor(int in1, int in2, float target, float current) {
  float error = target - current;
  float deadband = 2.5; 

  // إذا كان الخطأ أصغر من المسموح به، أوقف الموتور فوراً لمنع الاهتزاز
  if (abs(error) <= deadband) {
    digitalWrite(in1, LOW); 
    digitalWrite(in2, LOW);
    return;
  }

  // تحديد اتجاه الدوران بناءً على إشارة الخطأ مباشرة
  if (error > 0) { 
    digitalWrite(in1, HIGH); 
    digitalWrite(in2, LOW); 
  } else { 
    digitalWrite(in1, LOW);  
    digitalWrite(in2, HIGH); 
  }
}

float potToDegrees(int val, int centerVal) {
  return map(val, centerVal - 345, centerVal + 345, -45, 45);
}

void setRotationMotors(float fl, float fr, float rl, float rr) {
  int center_FL = 478, center_FR = 403, center_BL = 477, center_BR = 481; 
  long sumFL = 0, sumFR = 0, sumBL = 0, sumBR = 0;
  for(int i = 0; i < 5; i++) {
    sumFL += analogRead(POT_FL); sumFR += analogRead(POT_FR);
    sumBL += analogRead(POT_BL); sumBR += analogRead(POT_BR);
    delayMicroseconds(50);
  }
  
  float curFL = potToDegrees(sumFL/5, center_FL);
  float curRL = potToDegrees(sumBL/5, center_BL);
  float curRR = potToDegrees(sumBR/5, center_BR);
  float curFR = potToDegrees(sumFR/5, center_FR);

  targetFL = fl; targetFR = fr; targetRL = rl; targetRR = rr;

  // استدعاء المواتير مباشرة دون الحاجة لـ Flags
  setRotationMotor(ROT_LF_IN1, ROT_LF_IN2, fl, curFL);
  setRotationMotor(ROT_LB_IN3, ROT_LB_IN4, rl, curRL);
  setRotationMotor(ROT_RB_IN1, ROT_RB_IN2, rr, curRR);
  setRotationMotor(ROT_RF_IN3, ROT_RF_IN4, fr, curFR);
}

void stopAllMotors() {
  setDriveMotors(0.0, 0.0);
  digitalWrite(ROT_RB_IN1, LOW); digitalWrite(ROT_RB_IN2, LOW);
  digitalWrite(ROT_RF_IN3, LOW); digitalWrite(ROT_RF_IN4, LOW);
  digitalWrite(ROT_LF_IN1, LOW); digitalWrite(ROT_LF_IN2, LOW);
  digitalWrite(ROT_LB_IN3, LOW); digitalWrite(ROT_LB_IN4, LOW);
}

// =====================
// SENSORS & TELEMETRY
// =====================
void calculateEncoderSpeed() {
  unsigned long now_ms = millis();
  float dt = (now_ms - lastEncTime) / 1000.0;
  if (dt > 0) {
    speedRight = (encRightCount / (float)ENCODER_PPR) * WHEEL_CIRCUMFERENCE / dt;
    speedLeft  = (encLeftCount  / (float)ENCODER_PPR) * WHEEL_CIRCUMFERENCE / dt;
    encRightCount = 0; encLeftCount = 0; lastEncTime = now_ms;
  }
}

void sendSensorData() {
  calculateEncoderSpeed();
  int16_t ax, ay, az, gx, gy, gz;
  mpuRobot.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  float roll = ax / 16384.0 * 90, pitch = ay / 16384.0 * 90, yaw = gz / 131.0;

  digitalWrite(TRIG_PIN, LOW); delayMicroseconds(2); digitalWrite(TRIG_PIN, HIGH); delayMicroseconds(10); digitalWrite(TRIG_PIN, LOW);
  float dist = pulseIn(ECHO_PIN, HIGH, 20000) * 0.034 / 2.0;

  float p_fl = potToDegrees(analogRead(POT_FL), 478), p_fr = potToDegrees(analogRead(POT_FR), 403);
  float p_bl = potToDegrees(analogRead(POT_BL), 477), p_br = potToDegrees(analogRead(POT_BR), 481);

  int ecg = analogRead(ECG_PIN);
  if (ecg > 550) { unsigned long t = millis(); if (t - lastBeatTime > 300) { bpm = 60000 / (t - lastBeatTime); lastBeatTime = t; } }
  
  tempSensor.requestTemperatures();
  float temp = tempSensor.getTempCByIndex(0);
  if (temp == -127.0) temp = 25.3;

  int16_t ax2, ay2, az2, gx2, gy2, gz2;
  mpuNeck.getMotion6(&ax2, &ay2, &az2, &gx2, &gy2, &gz2);
  float neckP = ay2 / 16384.0 * 90, neckG = sqrt((float)gx2*gx2 + (float)gy2*gy2 + (float)gz2*gz2) / 131.0;

  int jx = map(analogRead(JOY_X), 0, 1023, -100, 100), jy = map(analogRead(JOY_Y), 0, 1023, -100, 100);
  if (abs(jx) < 10) jx = 0; if (abs(jy) < 10) jy = 0;

  String data = "E:" + String(speedLeft,2) + "," + String(speedRight,2) + "|J:" + String(jx) + "," + String(jy) +
                "|U:" + String(dist,1) + "|P:" + String(p_fl,1) + "," + String(p_fr,1) + "," + String(p_bl,1) + "," + String(p_br,1) +
                "|TGT:" + String(targetFL,1) + "," + String(targetFR,1) + "," + String(targetRL,1) + "," + String(targetRR,1) +
                "|I:" + String(roll,2) + "," + String(pitch,2) + "," + String(yaw,2) + "|H:" + String(bpm) +
                "|T:" + String(temp,1) + "|N:" + String(neckP,2) + "," + String(neckG,2);
  Serial.println(data);
}

// =====================
// SETUP & LOOP
// =====================
void setup() {
  Serial.begin(115200); stopAllMotors();
  pinMode(BTS_RIGHT_RPWM, OUTPUT); pinMode(BTS_RIGHT_LPWM, OUTPUT);
  pinMode(BTS_LEFT_RPWM,  OUTPUT); pinMode(BTS_LEFT_LPWM,  OUTPUT);
  int pins[] = {4,7,8,9,10,11,12,44,22}; for(int p : pins) pinMode(p, OUTPUT);
  TCCR3B = (TCCR3B & 0b11111000) | 0x01; TCCR4B = (TCCR4B & 0b11111000) | 0x01;
  Wire.begin(); Wire.setClock(400000);
  attachInterrupt(digitalPinToInterrupt(ENC_RIGHT_A), countRightA, RISING);
  attachInterrupt(digitalPinToInterrupt(ENC_LEFT_A),  countLeftA,  RISING);
  mpuRobot.initialize(); mpuNeck.initialize(); tempSensor.begin();
  inputBuffer.reserve(64);
}

void loop() {
  unsigned long now = millis();
  while (Serial.available() > 0) {
    char c = Serial.read();
    if (c == '\n') {
      inputBuffer.trim();
      if (inputBuffer.length() > 0) { 
        parseCommand(inputBuffer); 
        lastCmdTime = now; 
        rosActive = true; 
      }
      inputBuffer = ""; 
    } else { inputBuffer += c; }
  }

  // الـ Watchdog والتحويل التلقائي للجويستيك
  if (rosActive && (now - lastCmdTime > ROS_CMD_TIMEOUT)) { 
    stopAllMotors(); 
    rosActive = false; 
  }

  if (!rosActive) {
    int jx = map(analogRead(JOY_X), 0, 1023, -100, 100), jy = map(analogRead(JOY_Y), 0, 1023, -100, 100);
    if (abs(jx) < 10) jx = 0; if (abs(jy) < 10) jy = 0;
    if (abs(jy) < 10) jx = 0; 
    setDriveMotors((jy+jx)/100.0, (jy-jx)/100.0);
  }

  if (now - lastSendTime >= SEND_INTERVAL) { lastSendTime = now; sendSensorData(); }
}

void parseCommand(String cmd) {
  int sIdx = cmd.indexOf("S:"), wIdx = cmd.indexOf("W:"), pipeIdx = cmd.indexOf("|");
  if (sIdx == -1 || wIdx == -1) return;
  float sVals[4], wVals[2];
  String sStr = cmd.substring(sIdx + 2, pipeIdx), wStr = cmd.substring(wIdx + 2);
  for(int i=0; i<4; i++) { int c=sStr.indexOf(','); sVals[i]=(c==-1)?sStr.toFloat():sStr.substring(0,c).toFloat(); sStr=sStr.substring(c+1); }
  for(int i=0; i<2; i++) { int c=wStr.indexOf(','); wVals[i]=(c==-1)?wStr.toFloat():wStr.substring(0,c).toFloat(); wStr=wStr.substring(c+1); }
  setRotationMotors(sVals[0], sVals[1], sVals[2], sVals[3]);
  setDriveMotors(wVals[0], wVals[1]);
}