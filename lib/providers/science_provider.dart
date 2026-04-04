import 'package:flutter/material.dart';
import '../data/formulas.dart';

class ScienceProvider with ChangeNotifier {
  // Current data state
  String _input1 = "0";
  String _input2 = "0";
  String _input3 = "0";
  String _input4 = "0";
  String _result = "0";

  String get input1 => _input1;
  String get input2 => _input2;
  String get input3 => _input3;
  String get input4 => _input4;
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

  void updateFormula(Formula formula) {
    _currentFormula = formula;
    _input1 = "0";
    _input2 = "0";
    _input3 = "0";
    _input4 = "0";
    _result = "0";
    notifyListeners();
  }

  void updateInput(int field, String val, int precision) {
    if (field == 1) _input1 = val.isEmpty ? "0" : val;
    else if (field == 2) _input2 = val.isEmpty ? "0" : val;
    else if (field == 3) _input3 = val.isEmpty ? "0" : val;
    else if (field == 4) _input4 = val.isEmpty ? "0" : val;
    _calculate(precision);
  }

  void _calculate(int precision) {
    double i1 = double.tryParse(_input1) ?? 0;
    double i2 = double.tryParse(_input2) ?? 0;
    double i3 = double.tryParse(_input3) ?? 0;
    double i4 = double.tryParse(_input4) ?? 0;
    double res = 0;

    // A simplified parser for our formula library
    switch (_currentFormula.title) {
      case "F = m*a": res = i1 * i2; break;
      case "Kinematics: v² = u² + 2as": res = i1*i1 + 2*i2*i3; break;
      case "Weight: W = m*g": res = i1 * i2; break;
      case "Ideal Gas: P = nRT/V": res = (i1 * 8.314 * i2) / i3; break;
      case "2x2 Determinant: ad - bc": res = (i1*i4) - (i2*i3); break;
      case "Dot Product: a1*b1 + a2*b2 + a3*b3": res = (i1*i2) + (i3*i4); break;
      default: res = i1 * i2; break;
    }

    if (res.abs() > 1000000 || (res.abs() < 0.0001 && res != 0)) {
       _result = res.toStringAsExponential(precision > 4 ? 4 : precision);
    } else {
       _result = res.toStringAsFixed(precision);
       if (_result.contains('.')) {
         _result = _result.replaceAll(RegExp(r'0*$'), '');
         if (_result.endsWith('.')) {
           _result = _result.substring(0, _result.length - 1);
         }
       }
    }
    
    notifyListeners();
  }
}
