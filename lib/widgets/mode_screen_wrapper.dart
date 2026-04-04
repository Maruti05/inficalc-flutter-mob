import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class ModeScreenWrapper extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Map<String, String>> categories;

  const ModeScreenWrapper({
    super.key, 
    required this.title, 
    required this.icon,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceLowest = isDark ? CosmicTheme.darkSurfaceLowest : CosmicTheme.lightSurfaceLowest;
    final onSurfaceVariant = isDark ? CosmicTheme.darkOnSurfaceVariant : CosmicTheme.lightOnSurfaceVariant;
    final primary = isDark ? CosmicTheme.darkPrimary : CosmicTheme.lightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: surfaceLowest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: primary),
            ),
            const SizedBox(height: 32),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceLowest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['title']!,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat['description']!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: primary.withOpacity(0.5)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
