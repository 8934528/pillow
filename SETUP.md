# Setup Pillow Music Player

![Version](https://img.shields.io/badge/version-1.9.3-red)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

This guide will help you set up the Pillow Music Player locally on your machine.

## 1. Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio or VS Code with Flutter extensions installed
- An Android device or emulator for testing

## 2. Getting the Code

Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/pillow.git
cd pillow
```

## 3. Environment Variables

Pillow requires some API keys to fetch online music data. Create a `.env` file in the root directory and add the following keys:

```properties
YOUTUBE_SEARCH_KEY=your_api_key
YOUTUBE_DATA_API_KEY=your_api_key
SERP_API_KEY=your_api_key
```

*Note: You can get a free SerpApi key from [SerpApi.com](https://serpapi.com/) and a YouTube Data API v3 key from the [Google Cloud Console](https://console.cloud.google.com/).*

## 4. Install Dependencies

Clean the project and fetch all required packages:

```bash
flutter clean
flutter pub get
```

## 5. Run the App

You are now ready to run the app on your connected device or emulator!

```bash
flutter run
```
