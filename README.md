# 📋 Employee Directory App

> A Flutter mobile application that fetches employee data from a remote JSON API and displays it in a beautiful, interactive UI with light/dark theme support.

---

 📸 Features

- 🌐 **Live JSON Fetch** — Fetches employee data from a remote REST API
- 📋 **Employee List** — Displays all employees in an animated ListView
- 👤 **Employee Detail** — Tap any employee to view full details in a new screen
- 🔍 **Search** — Filter employees by name in real time
- 🔃 **Sort** — Sort by Name, Salary, or Age with one tap
- 🌙 **Theme Toggle** — Switch between Light and Dark mode instantly
- 📊 **Stats Banner** — Shows Total, Avg Salary, Max Salary, Avg Age
- 📈 **Salary Insight** — Animated progress bar comparing salary to benchmark
- 🎨 **Color-coded Avatars** — Each employee gets a unique consistent color
- ✨ **Smooth Animations** — Slide, fade, and scale animations throughout

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.x |
| **IDE** | Android Studio (Panda 2 / 2025.3.2) |
| **HTTP Client** | `http` ^1.2.1 |
| **State Management** | Flutter built-in StatefulWidget + FutureBuilder |
| **Navigation** | Flutter Navigator with PageRouteBuilder |
| **UI Components** | Material Design 3 |
| **Data Format** | JSON (REST API) |
| **Min SDK** | Android 5.0 (API 21) |
| **Target SDK** | Android 14 (API 34) |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1        # For fetching JSON from remote URL
```

---

## 🗂️ Project Structure

```
lib/
├── main.dart                          # App entry point + Theme toggler
├── models/
│   └── employee.dart                  # Employee data model
├── services/
│   └── employee_service.dart          # HTTP fetch + JSON parsing
├── screens/
│   ├── employee_list_screen.dart      # Main list screen
│   └── employee_detail_screen.dart    # Detail screen
└── widgets/
    └── employee_list_tile.dart        # Reusable animated list row
```

---

## 🌐 API

**Endpoint:**
```
GET https://aamras.com/dummy/EmployeeDetails.json
```

**Response Format:**
```json
{
  "employees": [
    { "name": "James",    "age": 27, "salary": 17000 },
    { "name": "Robert",   "age": 27, "salary": 25000 },
    { "name": "Emma",     "age": 27, "salary": 45000 },
    { "name": "Mohammed", "age": 27, "salary": 33000 },
    { "name": "Kumar",    "age": 27, "salary": 14000 },
    { "name": "Ganesh",   "age": 27, "salary": 35000 },
    { "name": "Krish",    "age": 27, "salary": 15000 }
  ]
}
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x installed
- Android Studio with Flutter and Dart plugins
- Android Emulator or physical device

### Run the app

```bash
# 1. Clone or download the project
cd employee_details_app

# 2. Install dependencies
flutter pub get

# 3. Run on connected device or emulator
flutter run
```

### Build APK

```bash
# Release APK
flutter build apk --release

# Output:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 How It Works

```
App Launch
  └── EmployeeListScreen
        └── FutureBuilder
              └── EmployeeService.fetchEmployees()
                    └── HTTP GET → JSON decode → List<Employee>
        └── ListView
              └── EmployeeListTile (tap)
                    └── Navigator.push → EmployeeDetailScreen
```

---

## 🎨 Screens

| Screen | Description |
|---|---|
| **List Screen** | Stats banner · Search bar · Sort chips · Animated employee cards |
| **Detail Screen** | Collapsible AppBar · Mini stat cards · Full details · Salary progress bar |

---

## 👨‍💻 Assignment Info

- **Assignment:** Android App Development — Assignment 2
- **Reference Video:** https://idzdigital.com/assignments/Mp4Assignment2.mp4
- **JSON Source:** https://aamras.com/dummy/EmployeeDetails.json
- **Platform:** Flutter (Android)
- **IDE:** Android Studio

---

## 📄 License

This project was built for educational and assignment purposes.
