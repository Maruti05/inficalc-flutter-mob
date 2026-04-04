import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calculator_button.dart';

class KeypadSection extends StatefulWidget {
  final bool isScientific;
  const KeypadSection({super.key, required this.isScientific});

  @override
  State<KeypadSection> createState() => _KeypadSectionState();
}

class _KeypadSectionState extends State<KeypadSection> {
  String _currentCategory = 'TRIG';
  
  // Compact category names for chips
  static const List<String> _categories = ['TRIG', 'ALGEBRA', 'CONST', 'STATS'];
  
  // Category → function buttons (2 rows of 5 each)
  static const Map<String, List<List<String>>> _categoryButtons = {
    'TRIG': [
      ['sin', 'cos', 'tan', 'π', 'AC'],
      ['asin', 'acos', 'atan', '( )', 'C'],
    ],
    'ALGEBRA': [
      ['x²', 'xⁿ', '√', 'n!', 'AC'],
      ['log', 'ln', 'abs', '( )', 'C'],
    ],
    'CONST': [
      ['π', 'e', 'φ', 'Rand', 'AC'],
      ['√2', 'ln2', 'log2e', '( )', 'C'],
    ],
    'STATS': [
      ['sin', 'cos', 'log', 'ln', 'AC'],
      ['x²', '√', 'abs', '( )', 'C'],
    ],
  };

  // Category icons
  static const Map<String, IconData> _categoryIcons = {
    'TRIG': Icons.change_history_rounded,
    'ALGEBRA': Icons.functions_rounded,
    'CONST': Icons.all_inclusive_rounded,
    'STATS': Icons.bar_chart_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.isScientific ? 5 : 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            if (widget.isScientific) ...[
              _buildCategorySelector(),
              const SizedBox(height: 6),
              _buildScientificKeypad(),
            ] else
              _buildStandardKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 42,
      child: Row(
        children: _categories.map((cat) {
          final isSelected = cat == _currentCategory;
          final icon = _categoryIcons[cat]!;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _currentCategory = cat);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                  color: isSelected 
                      ? primary.withOpacity(isDark ? 0.25 : 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? primary.withOpacity(0.6)
                        : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon, 
                      size: 14,
                      color: isSelected ? primary : (isDark ? Colors.white38 : Colors.black38),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cat,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        letterSpacing: 0.5,
                        color: isSelected ? primary : (isDark ? Colors.white54 : Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScientificKeypad() {
    final rows = _categoryButtons[_currentCategory]!;
    return Expanded(
      child: Column(
        children: [
          // Category-specific function rows (animated swap)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Column(
              key: ValueKey(_currentCategory),
              children: [
                _buildRow(rows[0], isScientific: true),
                _buildRow(rows[1], isScientific: true),
              ],
            ),
          ),
          // Fixed number pad + operators (always visible)
          _buildRow(['7', '8', '9', '/', '%'], isScientific: true),
          _buildRow(['4', '5', '6', 'x', '-'], isScientific: true),
          _buildRow(['1', '2', '3', '+/-', '+'], isScientific: true),
          _buildRow(['0', '.', 'Rand', '=', ''], isScientific: true, lastRow: true),
        ],
      ),
    );
  }

  Widget _buildStandardKeypad() {
    return Expanded(
      child: Column(
        children: [
          _buildRow(['AC', 'C', '%', '/'], isSpecial: true),
          _buildRow(['7', '8', '9', 'x']),
          _buildRow(['4', '5', '6', '-']),
          _buildRow(['1', '2', '3', '+']),
          _buildLastRow(),
        ],
      ),
    );
  }

  Widget _buildLastRow() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 2, child: Padding(padding: EdgeInsets.all(6.0), child: CalculatorButton(label: '0'))),
          const Expanded(flex: 1, child: Padding(padding: EdgeInsets.all(6.0), child: CalculatorButton(label: '.'))),
          const Expanded(flex: 1, child: Padding(padding: EdgeInsets.all(6.0), child: CalculatorButton(label: '='))),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> labels, {bool isSpecial = false, bool isScientific = false, bool lastRow = false}) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) {
          if (label.isEmpty) return const Expanded(child: SizedBox());
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CalculatorButton(
                label: label, 
                isScientific: isScientific,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
