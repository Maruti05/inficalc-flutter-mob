import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.8, curve: Curves.elasticOut))
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? CosmicTheme.darkPrimary : CosmicTheme.lightPrimary;
    final onSurfaceVariant = isDark ? CosmicTheme.darkOnSurfaceVariant : CosmicTheme.lightOnSurfaceVariant;

    return Scaffold(
      body: Stack(
        children: [
          // Background ambient glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
                decoration: BoxDecoration(
                color: primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary, primary.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(36),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.4),
                            blurRadius: 40,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: primary,
                            child: const Icon(Icons.calculate, size: 70, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'InfiCalc',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'COSMIC PRECISION',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        letterSpacing: 6,
                        fontWeight: FontWeight.bold,
                        color: onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
