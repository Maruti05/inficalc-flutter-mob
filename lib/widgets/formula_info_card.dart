import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/formulas.dart';

class FormulaInfoCard extends StatefulWidget {
  final FormulaInfo info;
  final Color primaryColor;

  const FormulaInfoCard({
    super.key,
    required this.info,
    required this.primaryColor,
  });

  @override
  State<FormulaInfoCard> createState() => _FormulaInfoCardState();
}

class _FormulaInfoCardState extends State<FormulaInfoCard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = Theme.of(context).colorScheme.surfaceContainerLow;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: widget.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: widget.primaryColor,
              unselectedLabelColor: onSurfaceVariant,
              labelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
              unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: widget.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'ABOUT'),
                Tab(text: 'VARIABLES'),
                Tab(text: 'HISTORY'),
              ],
            ),
          ),

          // Tab content
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: [
                // About Tab
                _buildAboutTab(isDark, onSurfaceVariant),
                
                // Variables Tab
                _buildVariablesTab(isDark, onSurfaceVariant),
                
                // History Tab
                _buildHistoryTab(isDark, onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(bool isDark, Color onSurfaceVariant) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: widget.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.info.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: widget.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Real World Uses',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.info.realWorldUses,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariablesTab(bool isDark, Color onSurfaceVariant) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.info.variables.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final variable = widget.info.variables[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    variable.symbol,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variable.name,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      variable.unit.isNotEmpty ? 'Unit: ${variable.unit}' : 'Dimensionless',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab(bool isDark, Color onSurfaceVariant) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_edu, size: 16, color: widget.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Origin & Discovery',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.primaryColor.withValues(alpha: 0.1),
                  widget.primaryColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    size: 20,
                    color: widget.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.info.history,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}