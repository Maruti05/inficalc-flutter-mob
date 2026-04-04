import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class DisplaySection extends StatelessWidget {
  const DisplaySection({super.key});

  void _copyToClipboard(BuildContext context, String text) {
    if (text.isEmpty || text == " ") return;
    
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('COPIED: $text', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            
            const Spacer(),
            
            // Expression History (Previous step)
            GestureDetector(
              onLongPress: () => _copyToClipboard(context, calc.expression),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  calc.expression.isEmpty ? " " : calc.expression,
                  style: GoogleFonts.robotoMono(
                    fontSize: 22,
                    color: onSurfaceVariant.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Final Result (Big)
            GestureDetector(
              onLongPress: () => _copyToClipboard(context, calc.result),
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    calc.result,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 72,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: onSurface,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

