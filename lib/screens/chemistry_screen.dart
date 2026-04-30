import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/science_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/formula_info_card.dart';

class ChemistryScreen extends StatelessWidget {
  const ChemistryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final science = context.watch<ScienceProvider>();
    final theme = context.watch<ThemeProvider>();
    final primary = Theme.of(context).colorScheme.primary;
    final surfaceLowest = Theme.of(context).colorScheme.surfaceContainerLowest;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final chemistryFormulas = science.getFormulasByCategory("CHEMISTRY");

    return Scaffold(
      appBar: AppBar(
        title: const Text('CHEMISTRY'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SELECT FORMULA',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2, color: primary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chemistryFormulas.length,
                itemBuilder: (context, index) {
                  final f = chemistryFormulas[index];
                  bool isSelected = f == science.currentFormula;
                    return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(f.title),
                      selected: isSelected,
                      onSelected: (val) => science.updateFormula(f),
                        selectedColor: primary.withOpacity(0.2),
                      labelStyle: GoogleFonts.robotoMono(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? primary : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceLowest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: List.generate(science.currentFormula.inputs.length, (index) {
                  String label = science.currentFormula.inputs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.robotoMono(color: onSurface),
                      onChanged: (val) => science.updateInput(index + 1, val, theme.decimalPrecision),
                      decoration: InputDecoration(
                        labelText: label,
                        labelStyle: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
                child: Column(
                children: [
                  Text(
                    'CALCULATED RESULT',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.white.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    science.result,
                    style: GoogleFonts.spaceGrotesk(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Formula Info Card
            if (science.currentFormula.info != null)
              FormulaInfoCard(
                info: science.currentFormula.info!,
                primaryColor: primary,
              ),
          ],
        ),
      ),
    );
  }
}
