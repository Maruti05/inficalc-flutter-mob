import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final bool isScientific;
  const CalculatorButton({super.key, required this.label, this.isScientific = false});

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final isOperator = ['+', '-', 'x', '/', '%'].contains(widget.label);
    final isFunction = ['sin', 'cos', 'tan', 'asin', 'acos', 'atan', 
                        'log', 'ln', '√', 'abs', 'x²', 'xⁿ', 'n!'].contains(widget.label);
    final isConstant = ['π', 'e', 'φ', '√2', 'ln2', 'log2e'].contains(widget.label);
    final isNumber = RegExp(r'^[0-9.]+$').hasMatch(widget.label);

    if (widget.label == 'AC') {
      bgColor = acRed;
      textColor = Colors.white;
    } else if (widget.label == 'C') {
      bgColor = acRed.withOpacity(0.15);
      textColor = acRed;
    } else if (widget.label == '=') {
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
    double fontSize = widget.isScientific ? 14 : 22;
    if (width < 360) fontSize -= 2;
    if (['log2e', 'asin', 'acos', 'atan'].contains(widget.label)) fontSize = 12;

    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),
      onTap: () {
        final theme = context.read<ThemeProvider>();
        if (theme.hapticFeedback) HapticFeedback.lightImpact();
        final precision = theme.decimalPrecision;
        if (widget.label == 'AC') {
          calc.clear();
        } else if (widget.label == 'C') {
          calc.delete();
        } else if (widget.label == '=') {
          calc.calculate(precision);
        } else {
          calc.append(widget.label);
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.label == '=' ? [
              BoxShadow(
                color: equalsBlue.withOpacity(0.35),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
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
