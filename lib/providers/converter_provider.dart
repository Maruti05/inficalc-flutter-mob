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
    "SPEED": ["M/s", "KM/h", "MPH", "Knots"],
    "TIME": ["Seconds", "Minutes", "Hours", "Days", "Weeks"],
    "VOLUME": ["Liters", "Milliliters", "Gallons", "Quarts", "Cups"],
    "TEMPERATURE": ["Celsius", "Fahrenheit", "Kelvin"],
    "AREA": ["Square Meters", "Square Feet", "Acres", "Hectares"],
    "DATA": ["Bits", "Bytes", "KB", "MB", "GB", "TB"],
    "PRESSURE": ["Pascal", "Bar", "PSI", "ATM"],
    "ENERGY": ["Joules", "Calories", "kWh"],
  };

  void updateCategory(String category) {
    _currentCategory = category;
    _fromUnit = categories[category]![0];
    _toUnit = categories[category]![1];
    _convert(12); // Default
    notifyListeners();
  }

  void updateUnits(String from, String to, int precision) {
    _fromUnit = from;
    _toUnit = to;
    _convert(precision);
    notifyListeners();
  }

  void swapUnits(int precision) {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
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

    switch (_currentCategory) {
      case "LENGTH":
        result = _convertLength(input, _fromUnit, _toUnit);
        break;
      case "MASS":
        result = _convertMass(input, _fromUnit, _toUnit);
        break;
      case "SPEED":
        result = _convertSpeed(input, _fromUnit, _toUnit);
        break;
      case "TIME":
        result = _convertTime(input, _fromUnit, _toUnit);
        break;
      case "VOLUME":
        result = _convertVolume(input, _fromUnit, _toUnit);
        break;
      case "TEMPERATURE":
        result = _convertTemp(input, _fromUnit, _toUnit);
        break;
      case "AREA":
        result = _convertArea(input, _fromUnit, _toUnit);
        break;
      case "DATA":
        result = _convertData(input, _fromUnit, _toUnit);
        break;
      case "PRESSURE":
        result = _convertPressure(input, _fromUnit, _toUnit);
        break;
      case "ENERGY":
        result = _convertEnergy(input, _fromUnit, _toUnit);
        break;
      default:
        result = input;
    }

    _outputVal = result.toStringAsFixed(precision);

    if (_outputVal.contains('.')) {
      _outputVal = _outputVal.replaceAll(RegExp(r'0*$'), '');
      if (_outputVal.endsWith('.')) {
        _outputVal = _outputVal.substring(0, _outputVal.length - 1);
      }
    }

    notifyListeners();
  }

  double _convertLength(double val, String from, String to) {
    final factors = {
      "Meters": 1.0,
      "Kilometers": 1000.0,
      "Miles": 1609.34,
      "Feet": 0.3048,
      "Inches": 0.0254,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertMass(double val, String from, String to) {
    final factors = {
      "Kilograms": 1.0,
      "Grams": 0.001,
      "Pounds": 0.453592,
      "Ounces": 0.0283495,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertSpeed(double val, String from, String to) {
    final factors = {
      "M/s": 1.0,
      "KM/h": 1 / 3.6,
      "MPH": 0.44704,
      "Knots": 0.514444,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertTime(double val, String from, String to) {
    final factors = {
      "Seconds": 1.0,
      "Minutes": 60.0,
      "Hours": 3600.0,
      "Days": 86400.0,
      "Weeks": 604800.0,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertVolume(double val, String from, String to) {
    final factors = {
      "Liters": 1.0,
      "Milliliters": 0.001,
      "Gallons": 3.78541,
      "Quarts": 0.946353,
      "Cups": 0.236588,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertArea(double val, String from, String to) {
    final factors = {
      "Square Meters": 1.0,
      "Square Feet": 0.092903,
      "Acres": 4046.86,
      "Hectares": 10000.0,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertData(double val, String from, String to) {
    final factors = {
      "Bits": 1.0,
      "Bytes": 8.0,
      "KB": 8.0 * 1024,
      "MB": 8.0 * 1024 * 1024,
      "GB": 8.0 * 1024 * 1024 * 1024,
      "TB": 8.0 * 1024 * 1024 * 1024 * 1024,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertPressure(double val, String from, String to) {
    final factors = {
      "Pascal": 1.0,
      "Bar": 100000.0,
      "PSI": 6894.76,
      "ATM": 101325.0,
    };
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertEnergy(double val, String from, String to) {
    final factors = {"Joules": 1.0, "Calories": 4.184, "kWh": 3600000.0};
    double base = val * (factors[from] ?? 1.0);
    return base / (factors[to] ?? 1.0);
  }

  double _convertTemp(double val, String from, String to) {
    double celsius = 0;
    if (from == "Celsius") {
      celsius = val;
    } else if (from == "Fahrenheit") {
      celsius = (val - 32) * 5 / 9;
    } else if (from == "Kelvin") {
      celsius = val - 273.15;
    }

    if (to == "Celsius") {
      return celsius;
    } else if (to == "Fahrenheit") {
      return (celsius * 9 / 5) + 32;
    } else if (to == "Kelvin") {
      return celsius + 273.15;
    }
    return val;
  }
}
