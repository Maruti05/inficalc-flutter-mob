# InfiCalc

A premium scientific calculator app built with Flutter and designed for Android, iOS, web, Windows, macOS, and Linux.

## Project Overview

InfiCalc is a feature-rich calculator app that combines standard and scientific calculation, unit conversion, physics/chemistry/mathematics formulas, voice input, theme customization, and update management.

This app uses Flutter with a provider-based architecture and local persistence for settings.

## Key Features

- Standard and scientific calculator modes
- Voice command input with speech recognition
- Calculation history
- Unit converter with categories including length, mass, speed, time, volume, temperature, area, data, pressure, and energy
- Physics, chemistry, and mathematics formula calculators with metadata and safe evaluation
- Theme palette selection and interface mode switching (light, dark, auto)
- Decimal precision control
- Trigonometric angle base switching (degrees/radians)
- Haptic feedback toggle
- App version display using `package_info_plus`
- Android in-app update support using `in_app_update`
- Persistent user settings via `shared_preferences`
- Responsive custom UI with Google Fonts styling

## Architecture

The app follows a clear separation between UI, state management, data, and service layers.

- `lib/main.dart` initializes the app, locks portrait orientation, and sets up providers.
- `lib/providers/` contains app state controllers for theme, calculator, converter, and science modules.
- `lib/core/theme.dart` defines the app's color palettes and theme generation logic.
- `lib/screens/` contains the visible screens and navigation logic.
- `lib/widgets/` contains reusable UI components such as the calculator display, keypad section, update dialog, and screen wrapper.
- `lib/data/formulas.dart` defines the domain model for formula evaluation, metadata, and error-safe calculations.
- `lib/services/update_service.dart` handles Android Play Store update checks.

## Folder Structure

```
lib/
  main.dart
  core/
    theme.dart
  data/
    formulas.dart
  providers/
    calculator_provider.dart
    converter_provider.dart
    science_provider.dart
    theme_provider.dart
  screens/
    about_screen.dart
    calculator_home.dart
    chemistry_screen.dart
    history_screen.dart
    main_entry_screen.dart
    mathematics_screen.dart
    physics_screen.dart
    privacy_policy_screen.dart
    settings_screen.dart
    splash_screen.dart
    unit_converter_screen.dart
  services/
    update_service.dart
  widgets/
    display_section.dart
    keypad_section.dart
    mode_screen_wrapper.dart
    update_dialog.dart
assets/
  images/
    app_icon.png
```

## Implementation Details

### App Initialization

- `main.dart` calls `WidgetsFlutterBinding.ensureInitialized()`.
- System UI mode is set to `edgeToEdge`.
- Orientation is locked to portrait up/down.
- `MultiProvider` registers `CalculatorProvider`, `ThemeProvider`, `ConverterProvider`, and `ScienceProvider`.
- `InfiCalcApp` chooses the correct theme based on user preference and system brightness.

### Theme and Settings

- `ThemeProvider` stores palette, interface mode, decimal precision, trig base, notation, haptics, click sounds, and history auto-save.
- Settings are persisted with `SharedPreferences`.
- `settings_screen.dart` exposes UI controls for palette, interface mode, precision, trig base, haptics, and privacy policy.
- `PackageInfo.fromPlatform()` is used to show the current version/build.

### Calculator Engine

- `CalculatorProvider` tracks the input expression, result, and history.
- It supports expression building, scientific operations, functions, constants, smart delete, and percentage handling.
- Calculations use `math_expressions` for parsing and evaluation.
- Result formatting removes trailing zeros and supports infinity/NaN handling.

### Voice Commands

- `calculator_home.dart` integrates `speech_to_text` and `permission_handler`.
- The voice button requests microphone permission, listens for speech, and converts spoken phrases into a calculator expression.
- Spoken words like "plus", "minus", "times", "divided by", and "point" are mapped to math symbols.
- Parsed voice expressions are calculated immediately.

### Unit Conversion

- `ConverterProvider` manages unit conversion state and category selection.
- Supported categories include length, mass, speed, time, volume, temperature, area, data, pressure, and energy.
- Conversion logic is implemented with factor maps and precision-safe result formatting.

### Science Formula Engine

- `ScienceProvider` exposes formula categories and handles formula selection.
- `formulas.dart` defines `Formula`, `FormulaResult`, `FormulaInfo`, `FormulaVariable`, and safe math helpers.
- The app includes physics, chemistry, and mathematics formulas with built-in validation and metadata.

### In-App Update

- `UpdateService` uses `in_app_update` for Android update checks.
- `MainEntryScreen` triggers an update check on startup and shows a custom update dialog if an update is available.

## Dependencies

- `flutter`
- `cupertino_icons`
- `google_fonts`
- `provider`
- `math_expressions`
- `shared_preferences`
- `package_info_plus`
- `speech_to_text`
- `permission_handler`
- `in_app_update`
- `flutter_markdown`

## Build & Run

```bash
flutter pub get
flutter run
```

For release builds:

```bash
flutter build apk
flutter build ios
flutter build web
```

## Notes for Production Access

- App package name and version are defined in `pubspec.yaml` as `name: inficalc` and `version: 1.1.2+5`.
- Android-only update support is implemented using `in_app_update`.
- Voice input requires microphone permission at runtime.

## How to Answer Common Questions

- "What architectures are used?" — Provider-based state management with separate UI, data, and service layers.
- "How are user settings stored?" — Persistent storage using `SharedPreferences` in `ThemeProvider`.
- "How is voice input handled?" — `speech_to_text` listens and converts spoken math phrases in `calculator_home.dart`.
- "How does the app handle formula calculations?" — `ScienceProvider` uses `Formula` objects from `lib/data/formulas.dart` with safe evaluation and validation.
- "What screens does the app have?" — Splash, calculator, math, physics, chemistry, unit converter, history, settings, privacy policy, and about.
