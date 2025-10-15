# JMC App

A Flutter application for accessing Jamnagar Municipal Corporation (JMC) services and information.

## Overview

This application serves as a mobile portal for the citizens of Jamnagar to access various municipal services, receive updates, and find important information. It is designed to be user-friendly, accessible, and multilingual, supporting English, Gujarati, and Hindi.

## Features

*   **Services:** A comprehensive list of JMC services, including:
    *   Property and water tax payments
    *   Professional tax services
    *   Applications for various certificates (birth, death, marriage, etc.)
    *   Development permissions and other applications
*   **Updates:** A list of recent news and updates from the JMC.
*   **Maps:** A placeholder for future integration of maps to locate JMC facilities.
*   **Downloads:** A repository of downloadable forms and documents, with support for offline access.
*   **Offline Downloads:** Users can save documents locally for viewing without an internet connection.
*   **Multilingual Support:** The app is available in English, Gujarati, and Hindi.
*   **Theme Customization:** Users can switch between light, dark, and system default themes, and toggle dynamic colors on supported devices.

## Project Structure

The project follows a feature-first architecture, with the main components organized as follows:

*   `lib/`: The root directory for the application's Dart code.
    *   `main.dart`: The entry point of the application.
    *   `app.dart`: The root widget of the application, where providers, themes, and localization are set up.
    *   `features/`: Each feature of the application is organized into its own subdirectory, containing its screens, widgets, and other related files.
    *   `models/`: Data models used throughout the application.
    *   `providers/`: State management providers for managing application-wide state.
    *   `services/`: Services for interacting with external resources, such as databases and APIs.
    *   `utils/`: Utility functions and helper classes.
    *   `widgets/`: Reusable widgets that are shared across multiple features.

## Getting Started

### Prerequisites

*   Flutter SDK: Ensure you have Flutter installed. For installation instructions, see the [Flutter documentation](https://flutter.dev/docs/get-started/install).
*   An IDE such as Visual Studio Code or Android Studio, with the Flutter and Dart plugins installed.

### Installation and Running

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd jmc_app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the localization generator:**
    ```bash
    flutter gen-l10n
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

## Technology Stack

*   **Framework:** Flutter
*   **Language:** Dart
*   **State Management:** Provider
*   **Localization:** `flutter_localizations` and `intl`
*   **Database:** `sqflite` for local storage

## Contributing

Contributions are welcome. Please follow the standard fork and pull request workflow.
