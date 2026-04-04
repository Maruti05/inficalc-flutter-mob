import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceLowest = isDark ? CosmicTheme.darkSurfaceLowest : CosmicTheme.lightSurfaceLowest;
    final onSurfaceVariant = isDark ? CosmicTheme.darkOnSurfaceVariant : CosmicTheme.lightOnSurfaceVariant;
    final primary = isDark ? CosmicTheme.darkPrimary : CosmicTheme.lightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ABOUT CALCPRO ULTRA'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.calculate, size: 80, color: primary),
            const SizedBox(height: 24),
            Text(
              'CalcPro Ultra',
              style: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'v1.0.0 Production',
              style: GoogleFonts.inter(color: onSurfaceVariant),
            ),
            const SizedBox(height: 48),
            _buildAboutCard(
              'THE CELESTIAL INSTRUMENT',
              'A philosophy that treats every calculation as an exploration of cosmic order. Reimagining the interface as a high-end scientific instrument.',
              surfaceLowest, primary, onSurfaceVariant
            ),
            const SizedBox(height: 24),
            _buildAboutCard(
              'TONAL DEPTH',
              'Break standard material molds through intentional tonal depth and asymmetric focus. Layered surfaces prioritize the display as the "source of truth".',
              surfaceLowest, primary, onSurfaceVariant
            ),
            const SizedBox(height: 48),
            Text(
              'Developed by Antigravity AI',
              style: GoogleFonts.inter(fontSize: 12, letterSpacing: 1, color: onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(String title, String content, Color surfaceLowest, Color primary, Color onSurfaceVariant) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
