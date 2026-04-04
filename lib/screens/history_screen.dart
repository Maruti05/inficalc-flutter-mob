import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../core/theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceLowest = isDark ? CosmicTheme.darkSurfaceLowest : CosmicTheme.lightSurfaceLowest;
    final onSurfaceVariant = isDark ? CosmicTheme.darkOnSurfaceVariant : CosmicTheme.lightOnSurfaceVariant;
    final primary = isDark ? CosmicTheme.darkPrimary : CosmicTheme.lightPrimary;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY LOG'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildClearConfirmation(context, calc, primary, isDark),
              );
            },
          )
        ],
      ),
      body: calc.history.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Icon(Icons.history, size: 80, color: onSurfaceVariant.withOpacity(0.2)),
                const SizedBox(height: 16),
                Text('No history yet', style: GoogleFonts.inter(color: onSurfaceVariant)),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: calc.history.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final parts = calc.history[index].split(' = ');
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceLowest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      parts[0],
                      style: GoogleFonts.robotoMono(color: onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      parts[1],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildClearConfirmation(BuildContext context, CalculatorProvider calc, Color primary, bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                    color: (isDark ? CosmicTheme.darkOnSurfaceVariant : CosmicTheme.lightOnSurfaceVariant).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                      color: (isDark ? CosmicTheme.darkOnSurfaceVariant : CosmicTheme.lightOnSurfaceVariant).withOpacity(0.05),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_sweep, color: Colors.red, size: 32),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Clear History?',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This action cannot be undone and all calculation logs will be lost.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'CANCEL',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                    colors: [primary, primary.withOpacity(0.8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                calc.clearHistory();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                'CLEAR ALL',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
