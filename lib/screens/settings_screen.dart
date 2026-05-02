import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/theme_provider.dart';
import '../core/theme.dart';
import 'privacy_policy_screen.dart';

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
    if (!mounted) return;

    setState(() {
      _appVersion = "${info.version}+${info.buildNumber}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final palette = context.select((ThemeProvider p) => p.palette);
    final mode = context.select((ThemeProvider p) => p.interfaceMode);
    final precision = context.select((ThemeProvider p) => p.decimalPrecision);
    final isDegree = context.select((ThemeProvider p) => p.isDegreeMode);
    final haptic = context.select((ThemeProvider p) => p.hapticFeedback);

    final provider = context.read<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionHeader('Appearance', colors.primary),

          /// Palette (unchanged)
          _settingsTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Color Palette',
            subtitle: palette.name.toUpperCase(),
            trailing: SizedBox(
              width: 120,
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: PalettePreset.values.map((p) {
                  final selected = p == palette;
                  return GestureDetector(
                    onTap: () => provider.setPalette(p),
                    child: Container(
                      width: 22,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: _getPaletteColor(p),
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(
                                color: isDark ? Colors.white : Colors.black,
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          /// ✅ ADAPTIVE MODE (FIXED)
          _settingsTile(
            context,
            icon: Icons.brightness_6_outlined,
            title: 'Interface Mode',
            subtitle: mode.name.toUpperCase(),
            trailing: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: InterfaceMode.values.map((m) {
                  final selected = m == mode;
                  return _modeTab(
                    label: m.name.toUpperCase(),
                    selected: selected,
                    onTap: () => provider.setInterfaceMode(m),
                    context: context,
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 32),
          _sectionHeader('Calculator Engine', colors.primary),

          _settingsTile(
            context,
            icon: Icons.numbers,
            title: 'Decimal Precision',
            subtitle: 'Result decimal places',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _actionButton(
                  Icons.remove,
                  () => provider.setDecimalPrecision(precision - 1),
                  context,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$precision',
                    style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
                  ),
                ),
                _actionButton(
                  Icons.add,
                  () => provider.setDecimalPrecision(precision + 1),
                  context,
                ),
              ],
            ),
          ),

          _settingsTile(
            context,
            icon: Icons.architecture,
            title: 'Trigonometric Base',
            subtitle: 'Default unit for angles',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _toggleTab(
                  'DEG',
                  isDegree,
                  () => provider.toggleTrigBase(),
                  context,
                ),
                _toggleTab(
                  'RAD',
                  !isDegree,
                  () => provider.toggleTrigBase(),
                  context,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          _sectionHeader('Tactile Engine', colors.primary),

          _settingsTile(
            context,
            icon: Icons.vibration,
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on button press',
            trailing: Switch(
              value: haptic,
              onChanged: (_) => provider.toggleHapticFeedback(),
            ),
          ),

          const SizedBox(height: 32),
          _sectionHeader('Application', colors.primary),

          _settingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'View app privacy terms',
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              ),
            ),
          ),

          _settingsTile(
            context,
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: 'Current build info',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _appVersion,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 64),
          _appFooter(context, _appVersion),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: color,
        ),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _modeTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.2)
              : colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _toggleTab(
    String label,
    bool selected,
    VoidCallback onTap,
    BuildContext context,
  ) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? colors.secondary.withValues(alpha: 0.2)
              : colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    VoidCallback onTap,
    BuildContext context,
  ) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16, color: colors.primary),
      ),
    );
  }

  Widget _appFooter(BuildContext context, String version) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          const Icon(Icons.calculate, size: 60),
          const SizedBox(height: 12),
          Text(
            'InfiCalc',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('v$version', style: GoogleFonts.inter(fontSize: 10)),
          const SizedBox(height: 8),
          Text(
            '© 2026 COSMIC LABS',
            style: GoogleFonts.inter(
              fontSize: 9,
              color: colors.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPaletteColor(PalettePreset palette) {
    switch (palette) {
      case PalettePreset.nebula:
        return const Color(0xFF8E2DE2);
      case PalettePreset.slate:
        return CosmicTheme.slateDarkPrimary;
      case PalettePreset.iconic:
        return CosmicTheme.iconicDarkPrimary;
    }
  }
}
