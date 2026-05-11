import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../widgets/common_widgets.dart';

class BloggingScreen extends StatelessWidget {
  const BloggingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(currentRoute: AppRoutes.blogging),
      appBar: AppBar(
        title: const Text('Blogging'),
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
            Text('Blogging', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text('Read or post market news, poultry tips, and farm advice.',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text('Blogging is coming soon.', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppTheme.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
