# InDrive Clone 🚗

> A pixel-perfect Flutter clone of the [inDrive](https://indrive.com) ride-hailing app, powered by Firebase.

This project fully replicates inDrive's UI and core functionality — from map-based ride search with custom pricing to courier and freight ordering, saved addresses, order history, and a complete profile system.

---

## Screenshots

>

---

## Features

### 🔐 Authentication

- Email & password **registration** and **sign-in** via Firebase Auth
- Persistent session across app restarts
- Each user gets their own Firestore document storing personal data

### 🗺 Ride Search (Taxi)

- Set **pickup and destination** points directly on the interactive map
- Or choose from **saved addresses** (home, work, custom)
- Specify additional ride requirements (car type, number of seats, etc.)
- **Name your own price** — core inDrive mechanic where the passenger proposes a fare

### 🚀 Service Categories

Replicated all major inDrive service types:

| Service      | Description                         |
| ------------ | ----------------------------------- |
| 🚕 City taxi | Standard in-city rides              |
| 🛣 Intercity | Long-distance rides between cities  |
| 📦 Courier   | Small package and document delivery |
| 🚚 Freight   | Cargo and moving vehicle requests   |

### 📋 Order History

- Full list of past orders per user
- Order details: route, category, price, date

### 📍 Saved Addresses

- **Home**, **Work**, and custom named addresses
- Quick-select during ride ordering
- Add, edit, and delete addresses from profile

### 👤 Profile

- View and **edit personal information** (name, phone, photo)
- Upload and update **profile picture**
- All data persisted in Firestore per user

### 🔔 Notifications

- Toggle notification preferences
- Ride updates, promotions, and system alerts

### 🔒 Security

- Dedicated security section
- Change password, manage account access

### ❓ Help

- FAQ and support section
- Contact and feedback options

---

## Tech Stack

| Layer            | Technology                        |
| ---------------- | --------------------------------- |
| Framework        | Flutter (Dart)                    |
| Auth             | Firebase Authentication           |
| Database         | Cloud Firestore                   |
| Storage          | Firebase Storage (profile photos) |
| Maps             | Google Maps Flutter               |
| Navigation       | go_router                         |
| State management | Provider                          |

---

## Project Structure

```
lib/
├── core/
│   ├── theme/          # inDrive color palette, typography, dark theme
│   └── utils/          # helpers, formatters, constants
├── models/
│   ├── user_model.dart
│   ├── order_model.dart
│   └── address_model.dart
├── providers/
│   ├── auth_provider.dart
│   ├── order_provider.dart
│   └── profile_provider.dart
├── router/
│   └── app_router.dart
├── screens/
│   ├── auth/           # SignIn, Register
│   ├── home/           # Map + service category picker
│   ├── order/          # Ride request form, price input
│   ├── history/        # Order history list
│   └── profile/
│       ├── profile_screen.dart
│       ├── edit_profile_screen.dart
│       ├── saved_addresses_screen.dart
│       ├── notifications_screen.dart
│       ├── security_screen.dart
│       └── help_screen.dart
└── widgets/            # Reusable UI components
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.x
- Firebase project with **Authentication**, **Firestore**, and **Storage** enabled
- Google Maps API key

### Setup

1. Clone the repo and install dependencies:

   ```bash
   git clone <repo-url>
   cd indrive_clone
   flutter pub get
   ```

2. Connect Firebase:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   This auto-generates `lib/firebase_options.dart`.

3. Add your Maps API key:

   **Android** — `android/app/src/main/AndroidManifest.xml`:

   ```xml
   <meta-data
     android:name="com.google.android.geo.API_KEY"
     android:value="YOUR_API_KEY"/>
   ```

   **iOS** — `ios/Runner/AppDelegate.swift`:

   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY")
   ```

4. Run the app:
   ```bash
   flutter run
   ```

---

## Firebase Setup

### Firestore Collections

```
users/
  {uid}/
    name:      string
    phone:     string
    email:     string
    photoUrl:  string
    addresses: [{ label, address, lat, lng }]

orders/
  {orderId}/
    userId:      string
    category:    string   // taxi | courier | freight | intercity
    origin:      { address, lat, lng }
    destination: { address, lat, lng }
    price:       number
    status:      string
    createdAt:   timestamp
```

### Firestore Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## Design

Fully replicates the inDrive visual identity:

- **Primary color:** `#CDFA50` (inDrive lime green)
- **Background:** `#0A0A0A` (near-black dark theme)
- Bold typography with high-contrast elements
- Bottom sheet ride request flow
- Map-first home screen layout

---

## Disclaimer

> This project is an **educational clone** built for learning purposes only. It is not affiliated with, endorsed by, or connected to inDrive (Suol Innovations Ltd.) in any way. All trademarks and design references belong to their respective owners.
