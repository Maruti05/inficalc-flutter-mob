import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final bool isScientific;
  const CalculatorButton({super.key, required this.label, this.isScientific = false});

  @override
  Widget build(BuildContext context) {
    final calc = context.read<CalculatorProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    // --- BRANDING COLORS ---
    const Color acRed = Color(0xFFC62828);
    const Color operatorTeal = Color(0xFF26A69A);
    const Color equalsBlue = Color(0xFF42A5F5);
    const Color funcPurple = Color(0xFF7E57C2);
    
    Color bgColor;
    Color textColor;

    // Categorize button types for styling
    final isOperator = ['+', '-', 'x', '/', '%'].contains(label);
    final isFunction = ['sin', 'cos', 'tan', 'asin', 'acos', 'atan', 
                        'log', 'ln', '√', 'abs', 'x²', 'xⁿ', 'n!'].contains(label);
    final isConstant = ['π', 'e', 'φ', '√2', 'ln2', 'log2e'].contains(label);
    final isNumber = RegExp(r'^[0-9.]$').hasMatch(label);

    if (label == 'AC') {
      bgColor = acRed;
      textColor = Colors.white;
    } else if (label == 'C') {
      bgColor = acRed.withOpacity(0.15);
      textColor = acRed;
    } else if (label == '=') {
      bgColor = equalsBlue.withOpacity(0.9);
      textColor = Colors.white;
    } else if (isOperator) {
      bgColor = operatorTeal.withOpacity(0.15);
      textColor = operatorTeal;
    } else if (isFunction) {
      bgColor = funcPurple.withOpacity(isDark ? 0.15 : 0.08);
      textColor = funcPurple;
    } else if (isConstant) {
      bgColor = equalsBlue.withOpacity(isDark ? 0.12 : 0.06);
      textColor = equalsBlue;
    } else if (isNumber) {
      bgColor = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05);
      textColor = colorScheme.onSurface;
    } else {
      bgColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03);
      textColor = colorScheme.onSurface;
    }

    final width = MediaQuery.of(context).size.width;
    double fontSize = isScientific ? 14 : 20;
    if (width < 360) fontSize -= 2;
    // Constants with long names get smaller font
    if (['log2e', 'asin', 'acos', 'atan'].contains(label)) fontSize = 12;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          final precision = context.read<ThemeProvider>().decimalPrecision;
          if (label == 'AC') {
            calc.clear();
          } else if (label == 'C') {
            calc.delete();
          } else if (label == '=') {
            calc.calculate(precision);
          } else {
            calc.append(label);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: label == '=' ? [
              BoxShadow(
                color: equalsBlue.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              )
            ] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
