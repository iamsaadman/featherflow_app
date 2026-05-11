import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Admin Dashboard', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Manage marketplace listings, users, doctors, delivery agents, and pharmacy inventory.',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text('Admin panel is coming soon.', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppTheme.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
