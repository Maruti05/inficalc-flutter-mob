import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorProvider with ChangeNotifier {
  String _expression = "";
  String _result = "0";
  final List<String> _history = [];

  String get expression => _expression;
  String get result => _result;
  List<String> get history => _history;

  void setExpression(String text) {
    _expression = text;
    notifyListeners();
  }

  void append(String text) {
    if (_expression.isEmpty && "/*+x".contains(text)) {
      if (_result != "Error" && _result != "0") {
        _expression = _result + text;
      } else {
        return; // Don't start with operator unless result is available
      }
    } else {
      // --- TRIG functions ---
      if (['sin', 'cos', 'tan'].contains(text)) {
        _expression += "$text(";
      } else if (['asin', 'acos', 'atan'].contains(text)) {
        _expression += "$text(";
      }
      // --- ALGEBRA functions ---
      else if (text == 'x²') {
        _expression += "^2";
      } else if (text == 'xⁿ') {
        _expression += "^";
      } else if (text == 'n!') {
        _expression += "!";
      } else if (text == '√') {
        _expression += "√(";
      } else if (text == 'log') {
        _expression += "log(";
      } else if (text == 'ln') {
        _expression += "ln(";
      } else if (text == 'abs') {
        _expression += "abs(";
      }
      // --- CONSTANTS ---
      else if (text == 'π') {
        _expression += "pi";
      } else if (text == 'e') {
        _expression += "e";
      } else if (text == 'φ') {
        // Golden ratio ≈ 1.6180339887
        _expression += "1.6180339887";
      } else if (text == '√2') {
        _expression += "1.4142135624";
      } else if (text == 'ln2') {
        _expression += "0.6931471806";
      } else if (text == 'log2e') {
        _expression += "1.4426950409";
      }
      // --- UTILITY ---
      else if (text == '( )') {
        int openBraces = '('.allMatches(_expression).length;
        int closeBraces = ')'.allMatches(_expression).length;
        _expression += (openBraces > closeBraces) ? ")" : "(";
      } else if (text == '+/-') {
        if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        } else if (_expression.isNotEmpty) {
          _expression = "-$_expression";
        }
      } else if (text == '%') {
        _expression += "%";
      } else {
        _expression += text;
      }
    }
    notifyListeners();
  }

  void clear() {
    _expression = "";
    _result = "0";
    notifyListeners();
  }

  void delete() {
    if (_expression.isNotEmpty) {
      // Smart delete: remove whole function names (sin, cos, etc.) not just one char
      final funcPatterns = [
        'asin(',
        'acos(',
        'atan(',
        'sin(',
        'cos(',
        'tan(',
        'log(',
        'abs(',
        'ln(',
        '√(',
      ];
      bool removedFunc = false;
      for (final func in funcPatterns) {
        if (_expression.endsWith(func)) {
          _expression = _expression.substring(
            0,
            _expression.length - func.length,
          );
          removedFunc = true;
          break;
        }
      }
      if (!removedFunc) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      notifyListeners();
    }
  }

  void calculate(int precision) {
    try {
      if (_expression.isEmpty) return;

      // Expression cleaning for the math_expressions parser
      String cleanedExpression = _expression
          .replaceAll('x', '*')
          .replaceAll('√', 'sqrt')
          .replaceAll('÷', '/');

      // Handle percentage: convert "50%" to "(50/100)"
      cleanedExpression = cleanedExpression.replaceAllMapped(
        RegExp(r'(\d+\.?\d*)%'),
        (match) => '(${match.group(1)}/100)',
      );

      // Auto-close missing braces for user convenience
      int openBraces = '('.allMatches(cleanedExpression).length;
      int closeBraces = ')'.allMatches(cleanedExpression).length;
      if (openBraces > closeBraces) {
        cleanedExpression += ')' * (openBraces - closeBraces);
      }

      Parser p = Parser();
      Expression exp = p.parse(cleanedExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Handle special float values
      if (eval.isInfinite) {
        _result = "∞";
        notifyListeners();
        return;
      }
      if (eval.isNaN) {
        _result = "Error";
        notifyListeners();
        return;
      }

      _result = eval.toStringAsFixed(precision);

      // Clean up result: remove trailing zeros and decimal point if unnecessary
      if (_result.contains('.')) {
        _result = _result.replaceAll(RegExp(r'0*$'), '');
        if (_result.endsWith('.')) {
          _result = _result.substring(0, _result.length - 1);
        }
      }

      _history.insert(0, "$_expression = $_result");
      _expression = "";
      notifyListeners();
    } catch (e) {
      _result = "Error";
      notifyListeners();
    }
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
