import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/theme_provider.dart';
import '../core/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = "${info.version}+${info.buildNumber}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final primary = Theme.of(context).colorScheme.primary;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Appearance'),
          _buildSettingsTile(
            icon: Icons.palette_outlined,
            title: 'Color Palette',
            subtitle: themeProvider.palette.name.toUpperCase(),
            trailing: SizedBox(
              width: 120,
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: PalettePreset.values.length,
                itemBuilder: (context, index) {
                  final p = PalettePreset.values[index];
                  bool isSelected = themeProvider.palette == p;
                  return GestureDetector(
                    onTap: () => themeProvider.setPalette(p),
                    child: Container(
                      width: 24,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: _getPaletteColor(p),
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildSettingsTile(
            icon: Icons.brightness_6_outlined,
            title: 'Interface Mode',
            subtitle: themeProvider.interfaceMode.name.toUpperCase(),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeTab('Light', InterfaceMode.light, themeProvider, context),
                _buildModeTab('Dark', InterfaceMode.dark, themeProvider, context),
                _buildModeTab('Auto', InterfaceMode.auto, themeProvider, context),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          _buildSectionHeader('Calculator Engine'),
          _buildSettingsTile(
            icon: Icons.numbers,
            title: 'Decimal Precision',
            subtitle: 'Result decimal places',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(Icons.remove, () => themeProvider.setDecimalPrecision(themeProvider.decimalPrecision - 1), context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('${themeProvider.decimalPrecision}', style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold)),
                ),
                _buildActionButton(Icons.add, () => themeProvider.setDecimalPrecision(themeProvider.decimalPrecision + 1), context),
              ],
            ),
          ),
          _buildSettingsTile(
            icon: Icons.architecture,
            title: 'Trigonometric Base',
            subtitle: 'Default unit for angles',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleTab('DEG', themeProvider.isDegreeMode, themeProvider.toggleTrigBase, context),
                _buildToggleTab('RAD', !themeProvider.isDegreeMode, themeProvider.toggleTrigBase, context),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          _buildSectionHeader('Tactile Engine'),
          _buildSettingsTile(
            icon: Icons.vibration,
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on button press',
            trailing: Switch(
              value: themeProvider.hapticFeedback, 
              onChanged: (val) => themeProvider.toggleHapticFeedback(),
              activeThumbColor: primary,
            ),
          ),

          const SizedBox(height: 32),
          _buildSectionHeader('Application'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: 'Current build info',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(_appVersion, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: primary)),
            ),
          ),
          
          const SizedBox(height: 64),
          Center(
             child: Column(
               children: [
                 Container(
                   width: 80,
                   height: 80,
                   padding: const EdgeInsets.all(4),
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       colors: [primary, primary.withValues(alpha: 0.8)],
                       begin: Alignment.topLeft,
                       end: Alignment.bottomRight,
                     ),
                     borderRadius: BorderRadius.circular(20),
                     boxShadow: [
                       BoxShadow(
                         color: primary.withValues(alpha: 0.3),
                         blurRadius: 20,
                         offset: const Offset(0, 8),
                       ),
                     ],
                   ),
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(16),
                     child: Image.asset(
                       'assets/images/app_icon.png',
                       fit: BoxFit.cover,
                       errorBuilder: (context, error, stackTrace) => Container(
                         color: primary,
                         child: const Icon(Icons.calculate, color: Colors.white, size: 36),
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(height: 16),
                 Text('InfiCalc', 
                   style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                 const SizedBox(height: 4),
                     Text('COSMIC PRECISION • v$_appVersion', 
                       style: GoogleFonts.inter(fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold, color: onSurfaceVariant.withOpacity(0.6))),
                 const SizedBox(height: 12),
                     Text('© 2026 COSMIC LABS', 
                       style: GoogleFonts.inter(fontSize: 9, color: onSurfaceVariant.withOpacity(0.4))),
               ],
             ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final surfaceVariant = Theme.of(context).colorScheme.surfaceContainerHigh;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
              ? surfaceVariant.withOpacity(0.5)
          : surfaceVariant.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Theme.of(context).brightness == Brightness.light
          ? Border.all(color: Theme.of(context).colorScheme.outlineVariant)
          : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: onSurfaceVariant)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildModeTab(String label, InterfaceMode mode, ThemeProvider provider, BuildContext context) {
    bool isSelected = provider.interfaceMode == mode;
    return GestureDetector(
      onTap: () => provider.setInterfaceMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withValues(alpha: 0.2) : Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
          border: !isSelected ? Border.all(color: Theme.of(context).colorScheme.outlineVariant) : null,
        ),
        child: Text(label, style: GoogleFonts.inter(
          fontSize: 12, 
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blueAccent : Theme.of(context).colorScheme.onSurfaceVariant,
        )),
      ),
    );
  }

  Widget _buildToggleTab(String label, bool isSelected, VoidCallback onTap, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2) : Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
          border: !isSelected ? Border.all(color: Theme.of(context).colorScheme.outlineVariant) : null,
        ),
        child: Text(label, style: GoogleFonts.inter(
          fontSize: 12, 
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurfaceVariant,
        )),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Color _getPaletteColor(PalettePreset palette) {
    switch (palette) {
      case PalettePreset.nebula: return const Color(0xFF8E2DE2);
      case PalettePreset.slate: return CosmicTheme.slateDarkPrimary;
      case PalettePreset.iconic: return CosmicTheme.iconicDarkPrimary;
    }
  }
}
