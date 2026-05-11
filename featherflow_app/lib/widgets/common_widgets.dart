import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/routes.dart';
import '../core/theme.dart';

// ─── App Drawer (User role) ───────────────────────────────────────────────────
class UserDrawer extends StatelessWidget {
  final String currentRoute;
  const UserDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF011810), AppTheme.primary],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(color: AppTheme.accent.withOpacity(0.5), width: 2),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                Text('John Farmer', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                Text('john@farm.com', style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.accent.withOpacity(0.4))),
                  child: Text('Premium Member', style: GoogleFonts.plusJakartaSans(color: AppTheme.accentLight, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerSection('Main'),
                _drawerTile(context, Icons.dashboard_rounded, 'Dashboard', AppRoutes.userDashboard),
                _drawerTile(context, Icons.bug_report_rounded, 'Disease Detection', AppRoutes.disease),
                _drawerTile(context, Icons.map_rounded, 'Vet Map', AppRoutes.vetMap),
                _drawerTile(context, Icons.medical_services_rounded, 'Connect Doctors', AppRoutes.userDoctors),
                _drawerSection('Management'),
                _drawerTile(context, Icons.people_rounded, 'Labor', AppRoutes.labor, premium: true),
                _drawerTile(context, Icons.account_balance_wallet_rounded, 'Cost', AppRoutes.cost, premium: true),
                _drawerTile(context, Icons.set_meal_rounded, 'Feed', AppRoutes.feed),
                _drawerTile(context, Icons.calculate_rounded, 'Tax', AppRoutes.tax, premium: true),
                _drawerTile(context, Icons.thermostat_rounded, 'Environmental', AppRoutes.environmental),
                _drawerSection('Community'),
                _drawerTile(context, Icons.shopping_bag_rounded, 'Marketplace', AppRoutes.marketplace),
                _drawerTile(context, Icons.article_rounded, 'Blog', AppRoutes.blogging),
                _drawerTile(context, Icons.book_rounded, 'Articles', AppRoutes.articles),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text('Sign Out', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.danger,
                  side: const BorderSide(color: AppTheme.danger),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textMuted, letterSpacing: 1.2)),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String title, String route, {bool premium = false}) {
    final selected = ModalRoute.of(context)?.settings.name == route;
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20, color: selected ? AppTheme.primary : AppTheme.textSecondary),
      title: Row(
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? AppTheme.primary : AppTheme.textPrimary)),
          if (premium) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
              child: Text('PRO', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.gold)),
            ),
          ],
        ],
      ),
      selected: selected,
      selectedTileColor: AppTheme.primary.withOpacity(0.07),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      onTap: () {
        Navigator.pop(context);
        if (!selected) Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? sub;

  const StatCard({super.key, required this.label, required this.value, required this.icon, required this.color, this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F0EC)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(sub!, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action!, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.accent)),
          ),
      ],
    );
  }
}

// ─── Premium Badge ────────────────────────────────────────────────────────────
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF4C552), Color(0xFFE8A825)]),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('PREMIUM', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5)),
    );
  }
}

// ─── Status Chip ─────────────────────────────────────────────────────────────
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.06), shape: BoxShape.circle),
            child: Icon(icon, size: 36, color: AppTheme.primary.withOpacity(0.4)),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}