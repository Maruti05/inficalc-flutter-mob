import 'package:flutter/material.dart';

class ConverterProvider with ChangeNotifier {
  String _inputVal = "0";
  String _outputVal = "0";
  String _currentCategory = "LENGTH";
  String _fromUnit = "Meters";
  String _toUnit = "Kilometers";

  String get inputVal => _inputVal;
  String get outputVal => _outputVal;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  String get currentCategory => _currentCategory;

  final Map<String, List<String>> categories = {
    "LENGTH": ["Meters", "Kilometers", "Miles", "Feet", "Inches"],
    "MASS": ["Kilograms", "Grams", "Pounds", "Ounces"],
    "TEMPERATURE": ["Celsius", "Fahrenheit", "Kelvin"],
    "AREA": ["Square Meters", "Square Feet", "Acres", "Hectares"],
    "ENERGY": ["Joules", "Calories", "Kilowatt-hours"]
  };

  void updateCategory(String category) {
    _currentCategory = category;
    _fromUnit = categories[category]![0];
    _toUnit = categories[category]![1];
    _convert(12); // Default, will be updated by caller if needed
    notifyListeners();
  }

  void updateUnits(String from, String to, int precision) {
    _fromUnit = from;
    _toUnit = to;
    _convert(precision);
  }

  void swapUnits(int precision) {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    
    // Also swap the values to maintain the logic? 
    // Usually swap just swaps the units and recomputes the output from the same input.
    _convert(precision);
    notifyListeners();
  }

  void appendInput(String val, int precision) {
    if (_inputVal == "0") {
      _inputVal = val;
    } else {
      _inputVal += val;
    }
    _convert(precision);
  }

  void clear() {
    _inputVal = "0";
    _outputVal = "0";
    notifyListeners();
  }

  void delete(int precision) {
    if (_inputVal.length > 1) {
      _inputVal = _inputVal.substring(0, _inputVal.length - 1);
    } else {
      _inputVal = "0";
    }
    _convert(precision);
  }

  void _convert(int precision) {
    double input = double.tryParse(_inputVal) ?? 0;
    double result = 0;

    if (_currentCategory == "LENGTH") {
      result = _convertLength(input, _fromUnit, _toUnit);
    } else if (_currentCategory == "MASS") {
      result = _convertMass(input, _fromUnit, _toUnit);
    } else if (_currentCategory == "TEMPERATURE") {
      result = _convertTemp(input, _fromUnit, _toUnit);
    } else {
      result = input; // Fallback
    }

    _outputVal = result.toStringAsFixed(precision);
    
    // Remove trailing zeroes if they are redundant, but keep up to the precision if the user wants it?
    // Actually, usually users want the precision they set. 
    // But let's make it clean: remove trailing zeros after decimal.
    if (_outputVal.contains('.')) {
      _outputVal = _outputVal.replaceAll(RegExp(r'0*$'), '');
      if (_outputVal.endsWith('.')) {
        _outputVal = _outputVal.substring(0, _outputVal.length - 1);
      }
    }
    
    notifyListeners();
  }

  double _convertLength(double val, String from, String to) {
    double meters = 0;
    switch (from) {
      case "Meters": meters = val; break;
      case "Kilometers": meters = val * 1000; break;
      case "Miles": meters = val * 1609.34; break;
      case "Feet": meters = val * 0.3048; break;
      case "Inches": meters = val * 0.0254; break;
      default: meters = val;
    }
    switch (to) {
      case "Meters": return meters;
      case "Kilometers": return meters / 1000;
      case "Miles": return meters / 1609.34;
      case "Feet": return meters / 0.3048;
      case "Inches": return meters / 0.0254;
      default: return meters;
    }
  }

  double _convertMass(double val, String from, String to) {
    double kg = 0;
    switch (from) {
      case "Kilograms": kg = val; break;
      case "Grams": kg = val / 1000; break;
      case "Pounds": kg = val * 0.453592; break;
      default: kg = val;
    }
    switch (to) {
      case "Kilograms": return kg;
      case "Grams": return kg * 1000;
      case "Pounds": return kg / 0.453592;
      default: return kg;
    }
  }

  double _convertTemp(double val, String from, String to) {
    double celsius = 0;
    if (from == "Celsius") celsius = val;
    else if (from == "Fahrenheit") celsius = (val - 32) * 5 / 9;
    else if (from == "Kelvin") celsius = val - 273.15;

    if (to == "Celsius") return celsius;
    else if (to == "Fahrenheit") return (celsius * 9 / 5) + 32;
    else if (to == "Kelvin") return celsius + 273.15;
    return val;
  }
}
