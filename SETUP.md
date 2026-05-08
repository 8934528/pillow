# Setup Pillow Music Player

![Version](https://img.shields.io/badge/version-1.9.3-red)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

This guide will help you set up the Pillow Music Player locally on your machine.

## Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio or VS Code with Flutter extensions installed
- An Android device or emulator (or Windows desktop) for testing

---

## Installation

### 1. Clone the repository

Open your terminal and run the following commands to clone the project and navigate into the directory:

```bash
git clone https://github.com/yourusername/pillow.git
cd pillow
```

### 2. Install dependencies

Fetch all required Flutter packages by running:

```bash
flutter pub get
```

### 3. Configure Environment

Pillow requires some API keys to fetch online music data.

- Create a `.env` file in the root directory of the project.
- Add your API keys to the `.env` file:

```properties
SERP_API_KEY=your_api_key_here
YOUTUBE_SEARCH_KEY=your_api_key_here
YOUTUBE_DATA_API_KEY=your_api_key_here
```

*(Note: If you are using the built-in `youtube_explode_dart` package, some of these keys may be optional, but the `.env` file should still exist).*

### 4. Run the app

You are now ready to run the app on your connected device or emulator!

```bash
flutter run
```
