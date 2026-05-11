import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(currentRoute: AppRoutes.marketplace),
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Marketplace', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Buy and sell poultry products, medicines, and feed.',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text('Marketplace is coming soon.', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppTheme.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
