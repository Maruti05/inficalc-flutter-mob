import 'package:flutter/material.dart';
import '../data/formulas.dart';

class ScienceProvider with ChangeNotifier {
  // Current data state
  List<String> _inputs = List.filled(6, "0");
  String _result = "0";

  String get result => _result;

  // Selected formula
  late Formula _currentFormula;
  Formula get currentFormula => _currentFormula;

  ScienceProvider() {
    _currentFormula = allFormulas.first;
  }

  List<Formula> getFormulasByCategory(String category) {
    return allFormulas.where((f) => f.category == category).toList();
  }

  /// Reset state when switching to a different category tab
  void resetForCategory(String category) {
    final categoryFormulas = getFormulasByCategory(category);
    if (categoryFormulas.isNotEmpty) {
      _currentFormula = categoryFormulas.first;
      _inputs = List.filled(6, "0");
      _result = "0";
      notifyListeners();
    }
  }

  void updateFormula(Formula formula) {
    _currentFormula = formula;
    _inputs = List.filled(6, "0");
    _result = "0";
    notifyListeners();
  }

  void updateInput(int field, String val, int precision) {
    // field is 1-indexed
    if (field >= 1 && field <= 6) {
      _inputs[field - 1] = val.isEmpty ? "0" : val;
    }
    _calculate(precision);
  }

  void _calculate(int precision) {
    // Only pass the number of inputs the formula expects
    final inputCount = _currentFormula.inputs.length;
    List<double> vars = _inputs.take(inputCount).map((e) => double.tryParse(e) ?? 0.0).toList();
    
    try {
      // Use safe evaluation with full error handling
      FormulaResult res = _currentFormula.evaluateSafe(vars);

      // Handle errors first
      if (res.hasError) {
        _result = res.error!;
        notifyListeners();
        return;
      }

      // Handle string results (like midpoint coordinates)
      if (res.isStringResult && res.stringValue != null) {
        _result = res.stringValue!;
      } 
      // Handle numeric results
      else if (res.value != null) {
        double value = res.value!;
        
        if (value.isNaN) {
          _result = "Undefined";
        } else if (value.isInfinite) {
          _result = value > 0 ? "Infinity" : "-Infinity";
        } else if (value.abs() > 1e15) {
          _result = value > 0 ? "∞" : "-∞";
        } else if (value.abs() > 1000000 || (value.abs() < 0.0001 && value != 0)) {
          _result = value.toStringAsExponential(precision > 4 ? 4 : precision);
        } else {
          _result = value.toStringAsFixed(precision);
          if (_result.contains('.')) {
            _result = _result.replaceAll(RegExp(r'0*$'), '');
            if (_result.endsWith('.')) {
              _result = _result.substring(0, _result.length - 1);
            }
          }
        }
      } else {
        _result = "Error";
      }
    } catch (e, stack) {
      print("Evaluation error: $e\n$stack");
      _result = "Err: $e";
    }

    notifyListeners();
  }
}
