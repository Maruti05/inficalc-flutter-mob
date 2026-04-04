import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InterfaceMode { light, dark, auto }
enum PalettePreset { iconic, slate, nebula }

class ThemeProvider with ChangeNotifier {
  PalettePreset _palette = PalettePreset.iconic;
  InterfaceMode _mode = InterfaceMode.dark;
  double _displayScale = 1.0;
  
  // Calculation Settings
  int _decimalPrecision = 12;
  bool _isDegreeMode = true;
  String _numberNotation = "Standard";

  // Engine Settings
  bool _hapticFeedback = true;
  String _hapticIntensity = "Medium";
  bool _clickSounds = false;
  
  // Storage Settings
  bool _autoSaveHistory = true;

  ThemeProvider() {
    _loadSettings();
  }

  PalettePreset get palette => _palette;
  InterfaceMode get interfaceMode => _mode;
  double get displayScale => _displayScale;
  int get decimalPrecision => _decimalPrecision;
  bool get isDegreeMode => _isDegreeMode;
  String get numberNotation => _numberNotation;
  bool get hapticFeedback => _hapticFeedback;
  String get hapticIntensity => _hapticIntensity;
  bool get clickSounds => _clickSounds;
  bool get autoSaveHistory => _autoSaveHistory;

  bool get isDarkMode {
    if (_mode == InterfaceMode.auto) {
      return true;
    }
    return _mode == InterfaceMode.dark;
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _palette = PalettePreset.values[prefs.getInt('palette') ?? 0];
    _mode = InterfaceMode.values[prefs.getInt('interfaceMode') ?? 1];
    _displayScale = prefs.getDouble('displayScale') ?? 1.0;
    _decimalPrecision = prefs.getInt('decimalPrecision') ?? 12;
    _isDegreeMode = prefs.getBool('isDegreeMode') ?? true;
    _numberNotation = prefs.getString('numberNotation') ?? "Standard";
    _hapticFeedback = prefs.getBool('hapticFeedback') ?? true;
    _hapticIntensity = prefs.getString('hapticIntensity') ?? "Medium";
    _clickSounds = prefs.getBool('clickSounds') ?? false;
    _autoSaveHistory = prefs.getBool('autoSaveHistory') ?? true;
    
    notifyListeners();
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void setPalette(PalettePreset palette) {
    _palette = palette;
    _saveInt('palette', palette.index);
    notifyListeners();
  }

  void setInterfaceMode(InterfaceMode mode) {
    _mode = mode;
    _saveInt('interfaceMode', mode.index);
    notifyListeners();
  }

  void setDisplayScale(double scale) {
    _displayScale = scale;
    _saveDouble('displayScale', scale);
    notifyListeners();
  }

  void setDecimalPrecision(int precision) {
    _decimalPrecision = precision.clamp(0, 20);
    _saveInt('decimalPrecision', _decimalPrecision);
    notifyListeners();
  }

  void toggleTrigBase() {
    _isDegreeMode = !_isDegreeMode;
    _saveBool('isDegreeMode', _isDegreeMode);
    notifyListeners();
  }

  void setNumberNotation(String notation) {
    _numberNotation = notation;
    _saveString('numberNotation', notation);
    notifyListeners();
  }

  void toggleHapticFeedback() {
    _hapticFeedback = !_hapticFeedback;
    _saveBool('hapticFeedback', _hapticFeedback);
    notifyListeners();
  }

  void setHapticIntensity(String intensity) {
    _hapticIntensity = intensity;
    _saveString('hapticIntensity', intensity);
    notifyListeners();
  }

  void toggleClickSounds() {
    _clickSounds = !_clickSounds;
    _saveBool('clickSounds', _clickSounds);
    notifyListeners();
  }

  void toggleAutoSaveHistory() {
    _autoSaveHistory = !_autoSaveHistory;
    _saveBool('autoSaveHistory', _autoSaveHistory);
    notifyListeners();
  }
}
