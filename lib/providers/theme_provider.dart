import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InterfaceMode { light, dark, auto }
enum PalettePreset { iconic, slate, nebula }
enum NumberNotation { standard, scientific }
enum HapticIntensity { low, medium, high }

class ThemeProvider with ChangeNotifier {
  // ================== STATE ==================
  PalettePreset _palette = PalettePreset.iconic;
  InterfaceMode _mode = InterfaceMode.dark;
  double _displayScale = 1.0;

  int _decimalPrecision = 2;
  bool _isDegreeMode = true;
  NumberNotation _numberNotation = NumberNotation.standard;

  bool _hapticFeedback = true;
  HapticIntensity _hapticIntensity = HapticIntensity.medium;
  bool _clickSounds = false;

  bool _autoSaveHistory = true;

  // ================== INTERNAL ==================
  SharedPreferences? _prefs;
  bool _isInitialized = false;
  Timer? _debounce;

  // ================== GETTERS ==================
  PalettePreset get palette => _palette;
  InterfaceMode get interfaceMode => _mode;
  double get displayScale => _displayScale;

  int get decimalPrecision => _decimalPrecision;
  bool get isDegreeMode => _isDegreeMode;
  NumberNotation get numberNotation => _numberNotation;

  bool get hapticFeedback => _hapticFeedback;
  HapticIntensity get hapticIntensity => _hapticIntensity;
  bool get clickSounds => _clickSounds;

  bool get autoSaveHistory => _autoSaveHistory;
  bool get isInitialized => _isInitialized;

  // ================== CONSTRUCTOR ==================
  ThemeProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  // ================== THEME LOGIC ==================
  bool isDarkMode(BuildContext context) {
    if (_mode == InterfaceMode.auto) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _mode == InterfaceMode.dark;
  }

  // ================== LOAD ==================
  Future<void> _loadSettings() async {
    final prefs = _prefs!;
    
    _palette = PalettePreset.values.elementAt(
      (prefs.getInt('palette') ?? 0)
          .clamp(0, PalettePreset.values.length - 1),
    );

    _mode = InterfaceMode.values.elementAt(
      (prefs.getInt('interfaceMode') ?? 1)
          .clamp(0, InterfaceMode.values.length - 1),
    );

    _displayScale = prefs.getDouble('displayScale') ?? 1.0;
    _decimalPrecision = prefs.getInt('decimalPrecision') ?? 2;
    _isDegreeMode = prefs.getBool('isDegreeMode') ?? true;

    _numberNotation = NumberNotation.values.elementAt(
      (prefs.getInt('numberNotation') ?? 0)
          .clamp(0, NumberNotation.values.length - 1),
    );

    _hapticFeedback = prefs.getBool('hapticFeedback') ?? true;

    _hapticIntensity = HapticIntensity.values.elementAt(
      (prefs.getInt('hapticIntensity') ?? 1)
          .clamp(0, HapticIntensity.values.length - 1),
    );

    _clickSounds = prefs.getBool('clickSounds') ?? false;
    _autoSaveHistory = prefs.getBool('autoSaveHistory') ?? true;

    _isInitialized = true;
    notifyListeners();
  }

  // ================== SAVE HELPERS ==================
  Future<void> _save<T>(String key, T value) async {
    if (_prefs == null) return;

    if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) await _prefs!.setDouble(key, value);
    else if (value is bool) await _prefs!.setBool(key, value);
    else if (value is String) await _prefs!.setString(key, value);
  }

  void _debouncedSave(String key, dynamic value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _save(key, value);
    });
  }

  // ================== SETTERS ==================
  void setPalette(PalettePreset palette) {
    if (_palette == palette) return;

    _palette = palette;
    _save('palette', palette.index);
    notifyListeners();
  }

  void setInterfaceMode(InterfaceMode mode) {
    if (_mode == mode) return;

    _mode = mode;
    _save('interfaceMode', mode.index);
    notifyListeners();
  }

  void setDisplayScale(double scale) {
    if (_displayScale == scale) return;

    _displayScale = scale;
    notifyListeners();
    _debouncedSave('displayScale', scale);
  }

  void setDecimalPrecision(int precision) {
    final newValue = precision.clamp(0, 10);
    if (_decimalPrecision == newValue) return;

    _decimalPrecision = newValue;
    _save('decimalPrecision', newValue);
    notifyListeners();
  }

  void toggleTrigBase() {
    final newValue = !_isDegreeMode;
    if (_isDegreeMode == newValue) return;

    _isDegreeMode = newValue;
    _save('isDegreeMode', newValue);
    notifyListeners();
  }

  void setNumberNotation(NumberNotation notation) {
    if (_numberNotation == notation) return;

    _numberNotation = notation;
    _save('numberNotation', notation.index);
    notifyListeners();
  }

  void toggleHapticFeedback() {
    final newValue = !_hapticFeedback;
    if (_hapticFeedback == newValue) return;

    _hapticFeedback = newValue;
    _save('hapticFeedback', newValue);
    notifyListeners();
  }

  void setHapticIntensity(HapticIntensity intensity) {
    if (_hapticIntensity == intensity) return;

    _hapticIntensity = intensity;
    _save('hapticIntensity', intensity.index);
    notifyListeners();
  }

  void toggleClickSounds() {
    final newValue = !_clickSounds;
    if (_clickSounds == newValue) return;

    _clickSounds = newValue;
    _save('clickSounds', newValue);
    notifyListeners();
  }

  void toggleAutoSaveHistory() {
    final newValue = !_autoSaveHistory;
    if (_autoSaveHistory == newValue) return;

    _autoSaveHistory = newValue;
    _save('autoSaveHistory', newValue);
    notifyListeners();
  }

  // ================== BATCH UPDATE ==================
  void updateSettings(void Function() updates) {
    updates();
    notifyListeners();
  }
}