# 📡 System Integration Roadmap

This file explains in detail how to run the entire system, starting from the physical sensors, through the intermediate server (Python Flask), and ending with the integration with the **main backend (Laravel)** and the mobile application (**Flutter**), along with ways to test the system to ensure it works correctly.

---

## 🔄 Data Flow

The data follows the intelligent sequence below to reduce server load and provide real-time response:

```text
[Physical Sensors] 
       │ (Analog/Digital Signals)
       ▼
[Arduino Mega] 
       │ (Collects data and sends it as a compact text string via USB Serial cable)
       ▼
[Intermediate Server - Python Flask (app.py)] 
       │ 1. On startup: Requests the patient's medical profile (chronic diseases) from Laravel.
       │ 2. Continuously: Reads sensors, analyzes neck movement (Fainting/Seizure).
       │ 3. Applies "Fuzzy Logic" to calculate the danger level.
       │ 4. Sends the results to Laravel every 20 readings (or immediately in case of emergency).
       ▼
[Mobile Application - Flutter App] 
       │ (Requests the /status endpoint from the local Python server for a fast, live view, or connects to Laravel for historical data)
```

---

## 🗺️ Action Plan (Setup and Testing)

### Part One: Connecting Sensors and Arduino to the Python Server

#### 1. Hardware Connections
*   **Temperature Sensor (DS18B20):**
    *   Connect `VCC` to `5V` on Arduino, and `GND` to `GND`.
    *   Connect the data line (Data) to pin `2` on the Arduino (with a 4.7kΩ pull-up resistor).
*   **Motion and Angle Sensor (MPU-6050):**
    *   Connect the `SDA` pin to pin `20` and the `SCL` pin to pin `21` (I2C on Arduino Mega).
*   **Pulse Sensor (Heart Rate):**
    *   Connect the signal line (Signal) to analog port `A0`.

#### 2. Uploading Code to Arduino
1.  Ensure that the Arduino code sends data in a compact format (to save transmission bandwidth and processing speed) as follows:
    `E:0.10,0.12|J:5,10|U:45.2|P:5,-3,2,-1|I:2.3,1.2,0.5|H:78|T:37.2|N:-4.20,12.50`
    *(Letters represent keys as follows: H for pulse, T for temperature, N for neck movement, etc.)*
2.  Upload the code and make sure to open the `Serial Monitor` and set the baud rate to `115200` to verify data output.

#### 3. Running the Python Server (Intermediate)
1. Open the terminal in the project folder and activate the virtual environment (`.venv\Scripts\activate` on Windows).
2. Make sure to install dependencies: `pip install -r requirements.txt`
3. Set the Laravel environment variables (this step is optional, as the code contains default values for testing):
   *On Windows (PowerShell):*
   ```powershell
   $env:LARAVEL_URL="http://127.0.0.1:8000"
   $env:PATIENT_ID="1"
   $env:SERIAL_PORT="COM3" # Will try to auto-detect if not set
   ```
4. Run the server:
   ```powershell
   python app.py
   ```
   *The server will display a welcome message containing your machine's local IP (e.g., `http://192.168.1.41:5000`) for you to use later in the Flutter app.*

---

### Part Two: Connecting the Flutter App and Testing the System

Your Flutter app will primarily communicate with the Python server for **real-time** response to data without overloading the main Laravel server with repetitive requests every second.

#### 1. Network Settings
Ensure that the laptop (running the Python server) and the phone (running the Flutter app) are connected to the **same local Wi-Fi network**.

#### 2. Available Endpoints for the Flutter App

| Endpoint | Function | How to use it in Flutter? |
| :--- | :--- | :--- |
| `GET /health` | Check server connection | Use it in the Splash screen or on login to ensure the system is ready to operate. |
| `GET /status` | **Live Data (Most Important)** | Use `Timer.periodic` to request it every 1 or 2 seconds and update the UI (heart rate, temperature, and danger level). |
| `GET /raw` | Raw sensor readings only | For displaying detailed sensor charts or recording robot movements. |
| `POST /patient`| Change active patient | Upon app login, send `{"patient_id": 2}` for the server to immediately fetch the new patient's data from Laravel. |

#### 3. How to verify the system is working correctly? (Testing)

**Test One: Test the API locally (Without Flutter App)**
1. While `python app.py` is running, open a browser or a program like Postman.
2. Go to the URL: `http://127.0.0.1:5000/status`
3. You should see a JSON response containing sensor data, in addition to the fuzzy logic result `fuzzy` and the medical `profile`.

**Test Two: Verify Simulation Mode**
If the Arduino is not connected, the Python server is designed to automatically enter **Simulation Mode** and generate fake data so you can test the application.
1. Disconnect the Arduino from your machine.
2. Run the server `python app.py`.
3. Request the `/status` URL several times; you will notice the sensor values change. Ensure the fuzzy logic system updates the danger level (Danger/Warning/Emergency) based on these random values.

**Test Three: Laravel Integration and Communication**
1. Ensure the Laravel server is running (usually with the `php artisan serve` command on port 8000).
2. Monitor the Python terminal upon startup; you should see a message: `✅ Profile loaded from Laravel: {'heart_disease': False, ...}`.
3. Wait a few seconds, you should see a message indicating periodic records are being sent: `Sending data [📊 periodic] to Laravel`, proving that Python successfully sends results to the backend.

#### 4. Tips for Flutter Developers 🚀
*   In the service files (Services or API Controllers) in Flutter, define the Python URL as a variable that can be easily changed:
    ```dart
    final String pythonApiUrl = 'http://192.168.1.41:5000'; // Replace with the IP shown in the Python terminal
    ```
*   When reading data from `/status` and finding that `level == 'Emergency'`, immediately show a red `AlertDialog` on the phone screen and play a local alert sound using a package like `audioplayers` to ensure the user is warned.
