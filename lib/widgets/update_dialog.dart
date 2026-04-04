import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/update_service.dart';

/// A premium glassmorphism update dialog that matches the Cosmic Precision
/// design language. Shows when a new version is available on Google Play.
class UpdateDialog extends StatefulWidget {
  final UpdateService updateService;

  const UpdateDialog({super.key, required this.updateService});

  /// Shows the update dialog as a modal.
  static Future<void> show(BuildContext context, UpdateService service) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Update Dialog',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnim = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnim,
          child: FadeTransition(
            opacity: anim1,
            child: UpdateDialog(updateService: service),
          ),
        );
      },
    );
  }

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _onUpdateNow() async {
    setState(() => _isUpdating = true);

    if (widget.updateService.immediateUpdateAllowed) {
      await widget.updateService.performImmediateUpdate();
    } else if (widget.updateService.flexibleUpdateAllowed) {
      await widget.updateService.startFlexibleUpdate();
      // After flexible download, prompt to install
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Update downloaded! Restarting...',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: 'INSTALL',
              textColor: Colors.white,
              onPressed: () => widget.updateService.completeFlexibleUpdate(),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    }

    if (mounted) setState(() => _isUpdating = false);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : Colors.black.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 4,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Animated Icon ---
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, child) {
                        return Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: SweepGradient(
                              startAngle: 0,
                              endAngle: 6.28,
                              transform: GradientRotation(
                                  _shimmerController.value * 6.28),
                              colors: [
                                primary,
                                primary.withOpacity(0.3),
                                Theme.of(context).colorScheme.secondary,
                                primary.withOpacity(0.3),
                                primary,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF111319)
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.system_update_rounded,
                              size: 32,
                              color: primary,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // --- Title ---
                    Text(
                      'New Update Available',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- Subtitle ---
                    Text(
                      'A newer version of InfiCalc is available on Google Play with improvements and new features.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- Staleness badge ---
                    if (widget.updateService.updateStaleness != null &&
                        widget.updateService.updateStaleness! > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Released ${widget.updateService.updateStaleness} day(s) ago',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                      ),

                    const SizedBox(height: 28),

                    // --- Update Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              primary,
                              primary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                            boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isUpdating ? null : _onUpdateNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isUpdating
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'UPDATE NOW',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- Later Button ---
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'LATER',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
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
