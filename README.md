# 🦽 Project ChairPal

ChairPal is an advanced, AI-driven smart wheelchair system designed as a comprehensive graduation project. It integrates embedded systems, mobile application development, back-end web services, artificial intelligence, and robotics to provide an intuitive, autonomous, and safe mobility solution for the elderly and individuals with motor disabilities.

## 🌟 Key Features
- **Smart Mobile Application:** A cross-platform app for users and caregivers to monitor and control the wheelchair.
- **AI Chatbot Assistant:** An intelligent conversational agent to assist the user and provide health/status insights.
- **Autonomous Robotics Motion:** Integration of computer vision and AI models (ONNX) to assist with navigation and obstacle avoidance.
- **Fuzzy Logic Sensor System:** Advanced sensor data processing using fuzzy logic for smooth and safe movements.
- **Cloud Backend & Admin Panel:** A robust server architecture for real-time data synchronization and remote monitoring.

## 🏗️ System Architecture & Technologies

This project is divided into several independent modules, each utilizing best-in-class technologies:

### 1. 📱 Mobile Application (`Chairpal_Application`)
- **Framework:** Flutter (Dart)
- **Platforms:** Android, iOS, Web
- **Features:** Real-time monitoring, remote control, and user-friendly interface.

### 2. ⚙️ Backend Services (`Chairpal_Bakend`)
- **Framework:** Laravel (PHP)
- **Features:** RESTful APIs, Database management, and Admin Dashboard.

### 3. 🤖 AI Chatbot (`ChairPal_Chatbot`)
- **Language:** Python
- **Features:** Natural language processing to answer user queries and execute commands.

### 4. 🧠 Robotics Motion (`Chairpal_Robotics_Motion`)
- **Technology:** ROS2 (Robot Operating System 2) , ONNX Machine Learning Models & Computer Vision
- **Features:** Object detection, autonomous navigation, and intelligent path planning.

### 5. 🎛️ Fuzzy Sensor System (`fuzzy_sensor`)
- **Language:** Python
- **Features:** A dedicated system running fuzzy logic algorithms to process raw sensor data and ensure safe hardware responses.

### 6. 🔌 Hardware Integration (`hardware`)
- **Platform:** Arduino (C/C++)
- **Features:** Direct control of motors, reading physical sensors, and executing movement commands.

## 🚀 Getting Started
Each module has its own directory with specific setup instructions. Please navigate to the respective folders (e.g., `Chairpal_Application`, `Chairpal_Bakend`) to see how to run them locally.

## 🎓 About
*Developed as a Computer Engineering Graduation Project.*
