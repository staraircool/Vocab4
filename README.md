# VocabPro - Flutter Vocabulary Learning App

A beautiful vocabulary learning app built with Flutter that helps users learn new words through swipeable cards and dictionary API integration.

## Features

- 🃏 **Swipeable Word Cards**: Beautiful gradient cards with smooth swipe animations
- 📚 **Dictionary Integration**: Real-time word definitions from dictionaryapi.dev
- ❤️ **Learning Progress**: Mark words as learned with heart button
- 🔊 **Phonetic Pronunciation**: Display phonetic pronunciation for each word
- 📝 **Detailed Definitions**: Word meanings, examples, and synonyms
- 💾 **Local Storage**: Save learned words locally using SharedPreferences
- 📱 **Responsive Design**: Works on both phones and tablets
- 🎨 **Beautiful UI**: Modern design with Poppins font and purple gradient theme

## Screenshots

The app features a clean, modern interface with:
- Home screen with swipeable word cards
- Learned words screen for progress tracking
- Beautiful gradient cards with word details
- Heart animation for marking words as learned

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Staraircool/Vocab4.git
cd Vocab4
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

- `flutter_card_swiper`: For swipeable card functionality
- `google_fonts`: For Poppins font family
- `http`: For API calls to dictionary service
- `shared_preferences`: For local data storage

## API Integration

The app uses the free Dictionary API from dictionaryapi.dev to fetch:
- Word definitions
- Phonetic pronunciations
- Example sentences
- Synonyms

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── word_model.dart      # Word data model
├── services/
│   ├── api_service.dart     # Dictionary API integration
│   └── local_storage_service.dart # Local storage management
├── widgets/
│   └── word_card.dart       # Swipeable word card widget
└── screens/
    ├── home_screen.dart     # Main screen with card swiper
    └── learned_words_screen.dart # Learned words management
```

## Building APK

### Using Codemagic (Recommended)

This project includes a `codemagic.yaml` file for automated builds:

1. Connect your GitHub repository to Codemagic
2. The build will automatically trigger on pushes to the main branch
3. Download the generated APK from the artifacts

### Manual Build

To build the APK manually:

```bash
flutter build apk --release
```

The APK will be generated in `build/app/outputs/flutter-apk/`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Contact

For questions or support, please open an issue on GitHub.

