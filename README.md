# Video CALLING App(1 to 1 VideoCall)

This project is a **Flutter-based video broadcasting application** built using the **Agora SDK**. It allows one user to **broadcast live video** while others join as **audience members** to watch in real-time.

---

## 🔗 Project Setup
This app is integrated with the **Grootan Firebase Project** for backend services and configurations.  
No additional setup or configuration is required.

Just clone the repository and run it like any other Flutter project.

---

# 📱 Agora Video Calling App

This Flutter project implements **real-time video calling** using [Agora RTC SDK](https://www.agora.io).  

It supports:

- 🔊 **Audio / Video Calls**  
- 🎤 Mute / Unmute Microphone  
- 📷 Enable / Disable Camera  
- 🔄 Switch Camera (front / back)  
- 🖥️ Screen Sharing (Android)  
- ⚡ Token validation from Firestore  



## 🚀 Features

- Video calling between multiple devices in the same channel.  
- Agora Token is **fetched from Firestore** dynamically.  
- If the token is **expired**, a **toast error message** will be shown when trying to join.  
- Toast messages are shown for important events like:
  - ✅ Successfully joining a channel  
  - ✅ Remote user joining  
  - ✅ Remote user leaving  
  - ❌ Token errors or expired tokens  


## 🚀 Getting Started

### **1. Clone the Repository**
```bash
git clone <your-repo-url>
cd <project-folder>
```

### **2. Install Dependencies**
```bash
flutter pub get
```

### **3. Run the App**
Run the project on your connected device or emulator:
```bash
flutter run
```

---

## 📦 Features
- Real-time **video broadcasting** using Agora SDK.  
- Supports **broadcaster** and **audience** roles.  
- Integrated with Firebase for future enhancements.  
- Clean and scalable Flutter code structure.

---

## 🛠 Requirements
- **Flutter SDK** (latest stable version)
- **Dart** (latest stable version)
- **Android Studio** or **VS Code**
- Physical device or emulator for testing

> No extra configurations or credentials are required — everything is pre-configured with the Grootan Firebase project.

---

## 📂 Folder Structure
```
lib/
│
├── core/                # Core utilities and services
├── features/
│   └── video_call/      # Video broadcasting modules
└── main.dart            # App entry point
```

---

## ⚡️ Notes
- This project is already linked with the Grootan Firebase project.
- You **do not need to set up Firebase manually** — it will work out of the box.
- Simply clone and run the project.

---

## 🤝 Contributing
Pull requests are welcome!  
For major changes, please open an issue first to discuss what you’d like to change.
