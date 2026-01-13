# Podcast App

A premium Flutter podcast player application featuring a sleek dark UI, custom audio playback controls, and automated playlist management.

## 🚀 Key Features

- **Sleek UI/UX**: Modern dark-themed design with glassmorphism effects and custom gradients.
- **Playlist Management**: Dynamic loading of episodes from local JSON data.
- **Advanced Playback**: 
    - Smooth Play/Pause, Seek, and Skip (10s) functionality.
    - **Next/Previous** song navigation.
    - **Auto-Play Next**: Automatically transitions to the next episode when the current one finishes.
    - **Speed Control**: Adjustable playback speed (1x, 1.25x, 1.5x, 2x).
- **Real-time Progress**: Live progress bar with buffered duration tracking.

## 📦 Packages Used

| Package | Use Case |
| :--- | :--- |
| `just_audio` | Provides the core engine for high-performance audio playback and control. |
| `audio_session` | Manages how the app interacts with the device's audio system (interruption handling). |
| `rxdart` | Used to combine multiple audio streams (position, duration, buffered) for a reactive UI. |
| `google_fonts` | Integrated for premium typography (`Inter` font family). |
| `intl` | Handles formatting and parsing of dates/numbers. |
| `path_provider` | Facilitates access to the device filesystem for potential caching/storage. |

## 🏗️ Project Architecture

- **Models**: Defines the `Episode` data structure.
- **Services**: `AudioService` manages the singleton audio player instance.
- **Screens**: 
    - `EpisodeListScreen`: Fetches and displays available podcasts.
    - `PlayerScreen`: Dedicated playback interface with advanced controls.
- **Theme**: Centralized `AppTheme` for consistent styling across the app.

## 🛠️ Getting Started

1. **Clone the repo**
2. **Install dependencies**: `flutter pub get`
3. **Run the app**: `flutter run`
