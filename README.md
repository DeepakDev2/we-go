# WeGo 🚀

**WeGo** is a Flutter-based location-sharing and navigation app designed for real-time collaboration and movement tracking. Whether you want to share your live location in a private group or navigate to a friend or searched destination, WeGo makes it seamless.

---

## 🌟 Features

- 📍 **Live Location Sharing in Rooms**  
  Share and view real-time locations of users within custom rooms using GPS.

- 🧭 **Shortest Path Navigation**  
  Get the shortest route to:
  - Live users within your room
  - Any searched destination

- 🔍 **Location Search & Navigation**  
  Search any location globally and get instant directions.

- 🔒 **Authentication & Secure Data**  
  User authentication via Firebase, with secure storage of user and location data.

---

## 🛠️ Tech Stack

### 📱 Frontend
- **Flutter**
- `flutter_map` & `flutter_map_location_marker` – For map display and live tracking
- `geolocator`, `location` – For location access and updates
- `flutter_polyline_points` – To draw routes via Google Directions API
- `provider` – For clean state management

### ☁️ Backend
- **Firebase**
  - `firebase_auth` – User authentication
  - `cloud_firestore` – Real-time location and room data
  - `firebase_storage` – Media uploads
- **Cloudinary** – Image optimization & hosting

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Google Maps API Key (for Directions API)
- Firebase project setup
- Emulator or real device with GPS

### Installation

```bash
git clone https://github.com/DeepakDev2/we-go.git
cd wego
flutter pub get
