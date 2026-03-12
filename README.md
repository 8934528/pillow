# Pillow

A beautiful music player app built with Expo React Native.

## Features

- Browse songs, albums, artists, and playlists
- Favorites section for loved tracks
- Clean, modern UI with dark/light mode support
- Now playing screen with playback controls
- Queue management system

## Tech Stack

- **Framework**: Expo SDK 52
- **Navigation**: Expo Router (file-based routing)
- **UI**: React Native with custom theming
- **Animations**: React Native Reanimated
- **Icons**: SF Symbols (iOS) + Material Icons (Android)

## Quick Start

      bash
      # Install dependencies
      npm install

      # Start the app
      npx expo start or npm run web

## Project Structure

      Pillow/
      ├── app/                         # Screens (file-based routing)
      │   ├── (tabs)/                  # Tab navigation screens
      │   ├── now-playing.tsx          # Now playing screen
      │   └── queue.tsx                # Queue management
      ├── components/                  # Reusable components
      ├── constants/                   # Theme and constants
      ├── hooks/                       # Custom React hooks
      └── assets/                      # Images and assets

## Development

      # Run on Android
      npm run android

      # Run on iOS
      npm run ios

      # Run on web
      npm run web

      # Reset project to blank state
      npm run reset-project

---
