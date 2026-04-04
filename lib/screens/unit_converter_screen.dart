import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/converter_provider.dart';
import '../providers/theme_provider.dart';

class UnitConverterScreen extends StatelessWidget {
  const UnitConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final converter = context.watch<ConverterProvider>();
    final theme = context.watch<ThemeProvider>();
    final primary = Theme.of(context).colorScheme.primary;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UNIT CONVERTER'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Category Selector (Chips)
              SizedBox(
                height: constraints.maxHeight * 0.12 > 80 ? 80 : constraints.maxHeight * 0.12,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: converter.categories.keys.map((cat) {
                    bool isSelected = cat == converter.currentCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(cat),
                        ),
                        selected: isSelected,
                        onSelected: (_) => converter.updateCategory(cat),
                        showCheckmark: false,
                        selectedColor: primary.withOpacity(0.2),
                        backgroundColor: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white.withOpacity(0.05) 
                          : Colors.black.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                            color: isSelected ? primary : onSurfaceVariant.withOpacity(0.2),
                          ),
                        ),
                        labelStyle: GoogleFonts.inter(
                          fontSize: constraints.maxWidth < 360 ? 11 : 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? primary : onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              Expanded(
                child: Column(
                  children: [
                    _buildConverterDisplay(context, converter.inputVal, converter.fromUnit, true),
                    
                    // SWAP ICON
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: IconButton(
                        onPressed: () => converter.swapUnits(theme.decimalPrecision), 
                        icon: Icon(Icons.swap_vert, size: 22, color: primary),
                        style: IconButton.styleFrom(
                          backgroundColor: primary.withOpacity(0.1),
                        ),
                        constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                    
                    _buildConverterDisplay(context, converter.outputVal, converter.toUnit, false),
                    
                    const SizedBox(height: 8),
                    
                    // Keypad fills remaining space
                    Expanded(
                      child: _buildConverterKeypad(context, converter, theme.decimalPrecision, constraints),
                    ),
                    
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildConverterDisplay(BuildContext context, String val, String unit, bool isInput) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isInput ? primary.withOpacity(0.3) : onSurfaceVariant.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label + Unit
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isInput ? 'FROM' : 'TO', 
                style: GoogleFonts.inter(
                  fontSize: 9, 
                  letterSpacing: 1.5, 
                  fontWeight: FontWeight.w800,
                  color: isInput ? primary : onSurfaceVariant.withOpacity(0.7),
                )),
              const SizedBox(height: 2),
              Text(unit, style: GoogleFonts.inter(
                fontSize: 12, 
                color: onSurfaceVariant,
                fontWeight: FontWeight.w500,
              )),
            ],
          ),
          const Spacer(),
          // Value
          Flexible(
            child: Text(val, 
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 28, 
                fontWeight: FontWeight.bold,
                color: isInput ? onSurface : const Color(0xFF4DB6AC),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildConverterKeypad(BuildContext context, ConverterProvider converter, int precision, BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04),
      child: Column(
        children: [
          _buildKeypadRow(context, ["7", "8", "9"], converter, precision),
          _buildKeypadRow(context, ["4", "5", "6"], converter, precision),
          _buildKeypadRow(context, ["1", "2", "3"], converter, precision),
          Row(
            children: [
              _buildConverterButton(context, ".", () => converter.appendInput(".", precision)),
              _buildConverterButton(context, "0", () => converter.appendInput("0", precision)),
              _buildConverterButton(context, "DEL", () => converter.delete(precision), isAccent: true, isIcon: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(BuildContext context, List<String> labels, ConverterProvider converter, int precision) {
    return Row(
      children: labels.map((label) {
        return _buildConverterButton(context, label, () => converter.appendInput(label, precision));
      }).toList(),
    );
  }

  Widget _buildConverterButton(BuildContext context, String label, VoidCallback onTap, {bool isAccent = false, bool isIcon = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 52,
                decoration: BoxDecoration(
                color: isAccent 
                  ? Colors.red.withOpacity(0.1) 
                  : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isAccent 
                    ? Colors.red.withOpacity(0.3) 
                    : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1))
                ),
              ),
              alignment: Alignment.center,
              child: isIcon && label == "DEL" 
                ? const Icon(Icons.backspace_outlined, color: Colors.redAccent, size: 20)
                : Text(label, style: GoogleFonts.spaceGrotesk(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: isAccent ? Colors.redAccent : Theme.of(context).colorScheme.onSurface,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

