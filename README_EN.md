# Habit Rabbit

A habit tracker app inspired by a rabbit-burrow world, featuring a carrot-point economy. Built with Flutter + Riverpod, combining local persistence (Hive) and Firebase sync (Auth/Firestore/Remote Config).

## Screenshot

![Home screen](docs/screenshot-home.png)

## Key Features

- **Authentication**: Google / Apple / Guest sign-in
- **Onboarding**: Quiz-based habit recommendations and starter flow
- **Habit Management**: Add/Edit/Delete, daily habit list, check-ins
- **Streak & Completion**: Streak tracking and monthly completion rate
- **Carrot Economy**: Earn points for completing habits
- **Shop & Customization**: Buy and equip items (rabbit/burrow customization)
- **Missions**: Rewards for completing missions
- **Statistics**: Basic stats + premium stats screens
- **Notifications**: Habit notification settings
- **Premium Gate**: Subscription upsell UI with blurred previews

## Tech Stack

- **Flutter / Dart**
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Backend**: Firebase Auth, Firestore, Remote Config
- **Subscriptions**: RevenueCat

## Architecture Overview

```
lib/
  data/         # Data sources and repository implementations (Hive/Firebase/RevenueCat)
  domain/       # Entities, use-cases, repository interfaces
  presentation/ # Riverpod providers and UI (screens/widgets)
```

- Layered flow **Presentation → Domain → Data**
- `SyncHabitRepository` syncs local (Hive) and remote (Firestore)
- Authentication/subscription/notifications wired via Providers

## Getting Started

### 1) Requirements

- Flutter SDK (includes Dart SDK)
- iOS/Android build environment (optional)

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Firebase setup

This project requires Firebase. Complete one of the following:

- **Using FlutterFire CLI**
  ```bash
  flutterfire configure
  ```
  which generates `lib/firebase_options.dart`

- **Add platform config files**
  - Android: `android/app/google-services.json`
  - iOS: `ios/Runner/GoogleService-Info.plist`

### 4) RevenueCat API Key

Replace `PurchasesConfiguration('YOUR_REVENUECAT_API_KEY')` in `lib/main.dart` with your actual key.

### 5) Run

```bash
flutter run -d <device>
```

For web:

```bash
flutter run -d web-server --web-port 8080
```

## Tests

```bash
flutter test
```

## Docs

- `docs/` : PRD, research, and MVP planning docs

## License

Private (publish_to: none)
