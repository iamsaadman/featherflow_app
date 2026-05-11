import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedNav = 0;

  final _navItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.bug_report_rounded, 'label': 'Detect'},
    {'icon': Icons.shopping_bag_rounded, 'label': 'Market'},
    {'icon': Icons.article_rounded, 'label': 'Blog'},
    {'icon': Icons.person_rounded, 'label': 'Profile'},
  ];

  final _navRoutes = [
    null,
    AppRoutes.disease,
    AppRoutes.marketplace,
    AppRoutes.blogging,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(currentRoute: AppRoutes.userDashboard),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF024A37)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning! 🌿', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white60)),
                        const SizedBox(height: 4),
                        Text('John Farmer', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.circle, size: 8, color: AppTheme.accentLight),
                              const SizedBox(width: 6),
                              Text('Farm Status: Healthy', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.egg_alt_rounded, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Alert banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Health Alert', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.warning)),
                        Text('2 chickens showing respiratory symptoms. Tap to view.', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.disease),
                    child: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.warning),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats grid
            SectionHeader(title: 'Farm Overview'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                StatCard(label: 'Total Chickens', value: '1,240', icon: Icons.egg_alt_rounded, color: AppTheme.primary, sub: '+12 this week'),
                StatCard(label: 'Daily Eggs', value: '980', icon: Icons.food_bank_rounded, color: AppTheme.accent, sub: '79% productivity'),
                StatCard(label: 'Workers', value: '8', icon: Icons.people_rounded, color: AppTheme.info, sub: '2 on leave'),
                StatCard(label: 'Monthly Cost', value: '৳42K', icon: Icons.account_balance_wallet_rounded, color: AppTheme.warning, sub: '+৳2K vs last'),
              ],
            ),
            const SizedBox(height: 20),

            // Quick actions
            SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                _QuickAction(icon: Icons.bug_report_rounded, label: 'Detect Disease', color: AppTheme.danger, route: AppRoutes.disease),
                _QuickAction(icon: Icons.map_rounded, label: 'Vet Map', color: AppTheme.info, route: AppRoutes.vetMap),
                _QuickAction(icon: Icons.people_rounded, label: 'Labor', color: AppTheme.primary, route: AppRoutes.labor),
                _QuickAction(icon: Icons.set_meal_rounded, label: 'Feed', color: AppTheme.accent, route: AppRoutes.feed),
                _QuickAction(icon: Icons.calculate_rounded, label: 'Tax', color: AppTheme.gold, route: AppRoutes.tax),
                _QuickAction(icon: Icons.thermostat_rounded, label: 'Environment', color: Colors.purple, route: AppRoutes.environmental),
              ],
            ),
            const SizedBox(height: 20),

            // Recent activity
            const SectionHeader(title: 'Recent Activity', action: 'See All'),
            const SizedBox(height: 12),
            ..._buildActivities(),
            const SizedBox(height: 20),

            // Health summary
            const SectionHeader(title: 'Health Summary', action: 'Detailed'),
            const SizedBox(height: 12),
            _HealthCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedNav,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textMuted,
          selectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 10),
          onTap: (i) {
            setState(() => _selectedNav = i);
            if (_navRoutes[i] != null) Navigator.pushNamed(context, _navRoutes[i]!);
          },
          items: _navItems.map((n) => BottomNavigationBarItem(
            icon: Icon(n['icon'] as IconData, size: 22),
            label: n['label'] as String,
          )).toList(),
        ),
      ),
    );
  }

  List<Widget> _buildActivities() {
    final items = [
      {'icon': Icons.set_meal_rounded, 'color': AppTheme.accent, 'title': 'Feed dispensed', 'sub': 'Morning batch — 50kg consumed', 'time': '2h ago'},
      {'icon': Icons.people_rounded, 'color': AppTheme.info, 'title': 'Worker check-in', 'sub': '6/8 workers present today', 'time': '4h ago'},
      {'icon': Icons.medical_services_rounded, 'color': AppTheme.primary, 'title': 'Vet consultation', 'sub': 'Dr. Rahman reviewed flock', 'time': 'Yesterday'},
      {'icon': Icons.warning_rounded, 'color': AppTheme.warning, 'title': 'Health alert', 'sub': 'Respiratory issue detected in Shed 2', 'time': 'Yesterday'},
    ];

    return items.map((item) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8F0EC)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(item['sub'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Text(item['time'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    )).toList();
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String route;

  const _QuickAction({required this.icon, required this.label, required this.color, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8F0EC)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, maxLines: 2, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F0EC)),
      ),
      child: Column(
        children: [
          _HealthRow('Healthy', '1,180', AppTheme.accent, 0.95),
          const SizedBox(height: 12),
          _HealthRow('Mild Symptoms', '42', AppTheme.warning, 0.034),
          const SizedBox(height: 12),
          _HealthRow('Critical', '18', AppTheme.danger, 0.015),
        ],
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  final String label;
  final String count;
  final Color color;
  final double percent;
  const _HealthRow(this.label, this.count, this.color, this.percent);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('$count birds', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(value: percent, backgroundColor: color.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(color), minHeight: 4, borderRadius: BorderRadius.circular(4)),
            ],
          ),
        ),
      ],
    );
  }
}