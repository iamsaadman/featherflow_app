import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  String _selectedRole = 'Farmer';
  bool _obscurePassword = true;

  final roles = [
    'Farmer',
    'Admin',
    'Doctor',
    'Delivery',
    'Pharmacy',
    'Researcher'
  ];

  final Map<String, String> _roleRoutes = {
    'Farmer': AppRoutes.userDashboard,
    'Admin': AppRoutes.adminDashboard,
    'Doctor': AppRoutes.doctorDashboard,
    'Delivery': AppRoutes.deliveryDashboard,
    'Pharmacy': AppRoutes.pharmacyDashboard,
    'Researcher': AppRoutes.researcherDashboard,
  };

  final Map<String, IconData> _roleIcons = {
    'Farmer': Icons.agriculture_rounded,
    'Admin': Icons.admin_panel_settings_rounded,
    'Doctor': Icons.medical_services_rounded,
    'Delivery': Icons.delivery_dining_rounded,
    'Pharmacy': Icons.local_pharmacy_rounded,
    'Researcher': Icons.science_rounded,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() {
    final route = _roleRoutes[_selectedRole] ?? AppRoutes.userDashboard;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Top green gradient area
          Container(
            height: size.height * 0.42,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF011810),
                  AppTheme.primary,
                  Color(0xFF024A37)
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accent.withOpacity(0.1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // White card area
          Positioned(
            top: size.height * 0.35,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
            ),
          ),
          // Content
          FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideIn,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Logo
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: AppTheme.accent.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.egg_alt_rounded,
                          size: 34,
                          color: AppTheme.accentLight,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Featherflow',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Smart Poultry Management',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: size.height * 0.1),
                      // Form card with GREEN shadow overlay on entire border
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          // Green glow border effect
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accent.withOpacity(0.35),
                              blurRadius: 0,
                              spreadRadius: 2,
                              offset: Offset.zero,
                            ),
                            BoxShadow(
                              color: AppTheme.accent.withOpacity(0.18),
                              blurRadius: 20,
                              spreadRadius: 4,
                              offset: Offset.zero,
                            ),
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.18),
                              blurRadius: 35,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.accent.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sign in to your farm account',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Role selector
                              Text(
                                'LOGIN AS',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: roles.map((role) {
                                  final selected = _selectedRole == role;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedRole = role),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppTheme.primary
                                            : const Color(0xFFF0F6F3),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border: Border.all(
                                          color: selected
                                              ? AppTheme.primary
                                              : const Color(0xFFD4E4DF),
                                        ),
                                        boxShadow: selected
                                            ? [
                                                BoxShadow(
                                                  color: AppTheme.accent
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                )
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _roleIcons[role],
                                            size: 14,
                                            color: selected
                                                ? Colors.white
                                                : AppTheme.textSecondary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            role,
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: selected
                                                  ? Colors.white
                                                  : AppTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              // Email
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'you@farm.com',
                                  prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      size: 20),
                                  labelStyle:
                                      GoogleFonts.plusJakartaSans(fontSize: 13),
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Password
                              TextField(
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      size: 20),
                                  suffixIcon: GestureDetector(
                                    onTap: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 20,
                                    ),
                                  ),
                                  labelStyle:
                                      GoogleFonts.plusJakartaSans(fontSize: 13),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Forgot password?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppTheme.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign In as $_selectedRole',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.signup,
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}