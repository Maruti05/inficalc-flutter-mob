import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
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
  
  // Category → function buttons (adjusted to make room for big AC/C)
  static const Map<String, List<List<String>>> _categoryButtons = {
    'TRIG': [
      ['sin', 'cos', 'tan', 'AC'],
      ['asin', 'acos', 'atan', 'C'],
    ],
    'ALGEBRA': [
      ['x²', 'xⁿ', '√', 'AC'],
      ['log', 'ln', 'abs', 'C'],
    ],
    'CONST': [
      ['π', 'e', 'φ', 'AC'],
      ['√2', 'ln2', 'log2e', 'C'],
    ],
    'STATS': [
      ['sin', 'cos', 'log', 'AC'],
      ['x²', '√', 'abs', 'C'],
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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(end: widget.isScientific ? 5 : 3),
      builder: (context, flexValue, child) {
        return Expanded(
          flex: (flexValue * 10).toInt(),
          child: child!,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: widget.isScientific 
                ? Column(
                    key: const ValueKey('selector'),
                    children: [
                      _buildCategorySelector(),
                      const SizedBox(height: 8),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('none')),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: widget.isScientific 
                    ? _buildScientificKeypad(key: const ValueKey('scientific')) 
                    : _buildStandardKeypad(key: const ValueKey('standard')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    return SizedBox(
      height: 50,
      child: Row(
        children: _categories.map((cat) {
          final isSelected = cat == _currentCategory;
          final icon = _categoryIcons[cat]!;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? primary.withOpacity(0.12)
                      : colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected 
                        ? primary.withOpacity(0.5)
                        : onSurfaceVariant.withOpacity(0.12),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      final theme = context.read<ThemeProvider>();
                      if (theme.hapticFeedback) HapticFeedback.selectionClick();
                      setState(() => _currentCategory = cat);
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon, 
                            size: isSelected ? 20 : 18,
                            color: isSelected 
                                ? primary 
                                : onSurfaceVariant,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cat,
                            style: GoogleFonts.inter(
                              fontSize: isSelected ? 9 : 8.5,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                              letterSpacing: 0.8,
                              color: isSelected 
                                  ? primary 
                                  : onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScientificKeypad({Key? key}) {
    final rows = _categoryButtons[_currentCategory]!;
    return Column(
      key: key,
      children: [
        // Category-specific function rows (animated swap)
        SizedBox(
          height: 90,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutQuart,
            switchOutCurve: Curves.easeInQuart,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Column(
              key: ValueKey(_currentCategory),
              children: [
                Expanded(
                  child: _buildRow(rows[0], isScientific: true),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: _buildRow(rows[1], isScientific: true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 3),
        // Number pad + operators (always visible)
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _buildRow(['7', '8', '9', '/', '%'], isScientific: true),
              ),
              const SizedBox(height: 3),
              Expanded(
                child: _buildRow(['4', '5', '6', 'x', '-'], isScientific: true),
              ),
              const SizedBox(height: 3),
              Expanded(
                child: _buildRow(['1', '2', '3', '+/-', '+'], isScientific: true),
              ),
              const SizedBox(height: 3),
              Expanded(
                child: _buildRow(['0', '00', '.', '='], isScientific: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStandardKeypad({Key? key}) {
    return Column(
      key: key,
      children: [
        Expanded(
          child: _buildRow(['AC', 'C', '%', '/'], isSpecial: true),
        ),
        const SizedBox(height: 3),
        Expanded(
          child: _buildRow(['7', '8', '9', 'x']),
        ),
        const SizedBox(height: 3),
        Expanded(
          child: _buildRow(['4', '5', '6', '-']),
        ),
        const SizedBox(height: 3),
        Expanded(
          child: _buildRow(['1', '2', '3', '+']),
        ),
        const SizedBox(height: 3),
        Expanded(
          child: _buildRow(['0', '00', '.', '=']),
        ),
      ],
    );
  }

  Widget _buildRow(List<String> labels, {bool isSpecial = false, bool isScientific = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: labels.map((label) {
        if (label.isEmpty) return const Expanded(child: SizedBox());
        
        // Dynamic flex for bigger buttons
        double flex = 1.0;
        
        if (isScientific) {
          // In scientific mode (5 column baseline)
          if (label == 'AC' || label == 'C' || label == '=') {
            flex = 2.0;
          }
        } else {
          // In standard mode (4 column baseline)
          if (label == 'AC' || label == 'C') {
            flex = 1.25;
          } else if (label == '%' || label == '/') {
            flex = 0.75;
          } else if (label == '=') {
            flex = 2.0;
          } else if (labels.contains('=') && labels.length == 4) {
            // Adjust other buttons in the row containing '=' to keep total flex = 4
            flex = 0.66;
          }
        }
        
        return Expanded(
          flex: (flex * 100).toInt(),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CalculatorButton(
              label: label, 
              isScientific: isScientific,
            ),
          ),
        );
      }).toList(),
    );
  }
}
