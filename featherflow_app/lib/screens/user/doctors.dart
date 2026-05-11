import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(currentRoute: AppRoutes.userDoctors),
      appBar: AppBar(
        title: const Text('Connect Doctors'),
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
            Text('Connect to Doctors', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Request consultations with registered veterinarians.',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text('Doctor connection is coming soon.', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppTheme.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
