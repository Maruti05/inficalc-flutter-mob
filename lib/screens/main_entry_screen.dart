import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/update_service.dart';
import '../widgets/update_dialog.dart';
import 'calculator_home.dart';
import 'mathematics_screen.dart';
import 'physics_screen.dart';
import 'chemistry_screen.dart';
import 'unit_converter_screen.dart';

class MainEntryScreen extends StatefulWidget {
  const MainEntryScreen({super.key});

  @override
  State<MainEntryScreen> createState() => _MainEntryScreenState();
}

class _MainEntryScreenState extends State<MainEntryScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;
  final UpdateService _updateService = UpdateService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    // Check for Android in-app updates after the first frame renders
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
    }
  }

  Future<void> _checkForUpdate() async {
    final updateInfo = await _updateService.checkForUpdate();
    if (updateInfo != null && mounted) {
      UpdateDialog.show(context, _updateService);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceLowest = isDark ? CosmicTheme.darkSurfaceLowest : CosmicTheme.lightSurfaceLowest;
    final primary = isDark ? CosmicTheme.darkPrimary : CosmicTheme.lightPrimary;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe to change pages for now to focus on bottom menu
        children: const [
          CalculatorHome(),
          MathematicsScreen(),
          PhysicsScreen(),
          ChemistryScreen(),
          UnitConverterScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceLowest,
          border: Border(
            top: BorderSide(
              color: primary.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: primary,
          unselectedItemColor: (isDark ? CosmicTheme.darkOnSurfaceVariant : CosmicTheme.lightOnSurfaceVariant).withOpacity(0.5),
          selectedLabelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined), activeIcon: Icon(Icons.calculate), label: 'Calc'),
            BottomNavigationBarItem(icon: Icon(Icons.functions), activeIcon: Icon(Icons.functions), label: 'Math'),
            BottomNavigationBarItem(icon: Icon(Icons.electric_bolt_outlined), activeIcon: Icon(Icons.electric_bolt), label: 'Physics'),
            BottomNavigationBarItem(icon: Icon(Icons.biotech_outlined), activeIcon: Icon(Icons.biotech), label: 'Chem'),
            BottomNavigationBarItem(icon: Icon(Icons.swap_horiz_outlined), activeIcon: Icon(Icons.swap_horiz), label: 'Units'),
          ],
        ),
      ),
    );
  }
}
