# JMC App

A Flutter application for accessing Jamnagar Municipal Corporation (JMC) services and information.

## Features

*   **Services:** Access various JMC services like Property Tax, Water Bill payments, etc. (Features under development)
*   **Updates:** View latest news and updates from JMC.
*   **Maps:** Locate important JMC facilities and points of interest.
*   **Downloads:** Access downloadable forms and documents. This includes a robust **offline downloads** feature, allowing users to save documents locally for viewing without an internet connection. Downloaded files can be opened using the device's native viewers.
*   **Multilingual Support:** Available in English, Gujarati, and Hindi.
*   **User Authentication:** Secure login for accessing personalized services.
*   **Filterable Services:** Filter services based on categories.

## Permissions

To provide the offline downloads functionality, the JMC App requires access to your device's storage:

*   **Android:** The app will request "Files and Media" or "Storage" permission. This is necessary to save downloaded documents to your device.
    *   For devices running Android 13 and above, the app utilizes the more granular media permissions (e.g., for images, videos, audio if applicable to downloaded content types) while still ensuring general document downloads are supported.
    *   For older Android versions, standard storage permissions are requested.
*   **iOS:** Standard permissions for accessing and saving files will be requested when you use the download feature.

The app is designed to request these permissions only when needed for the download functionality and provides clear prompts.

## Getting Started

### Prerequisites

*   Flutter SDK: Make sure you have Flutter installed. See [Flutter installation guide](https://flutter.dev/docs/get-started/install).
*   An IDE like VS Code or Android Studio with Flutter plugins.

### Installation & Running

1.  **Clone the repository:**
    ```bash
    git clone <repository_url> # Replace with the actual URL after uploading
    cd jmc_app
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## Technology Stack

*   **Framework:** Flutter
*   **Language:** Dart
*   **Localization:** `flutter_localizations`, `intl`

## Contributing

Contributions are welcome! Please follow standard fork & pull request workflows.


