import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../core/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _fadeOutController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _ringScale = Tween<double>(begin: 0.5, end: 1.4).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );
    _ringOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeOut),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();
    _particleController.repeat();

    await Future.delayed(const Duration(milliseconds: 3500));
    _particleController.stop();
    await _fadeOutController.forward();

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeOut,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeOut.value,
          child: child,
        );
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF011810),
                AppTheme.primary,
                Color(0xFF013D2C),
                Color(0xFF024A37),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(child: _BackgroundPattern()),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated rings + logo
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _particleController,
                        _logoController,
                      ]),
                      builder: (context, child) {
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring
                              Transform.scale(
                                scale: _ringScale.value,
                                child: Opacity(
                                  opacity: _ringOpacity.value * 0.3,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.accent,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Inner ring
                              Transform.scale(
                                scale: _ringScale.value * 0.7,
                                child: Opacity(
                                  opacity: _ringOpacity.value * 0.5,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.accentLight,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Logo circle
                              Opacity(
                                opacity: _logoOpacity.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.12),
                                      border: Border.all(
                                        color: AppTheme.accent.withOpacity(0.6),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.egg_alt_rounded,
                                      size: 52,
                                      color: AppTheme.accentLight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    // App name
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlide,
                          child: FadeTransition(
                            opacity: _textOpacity,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Featherflow',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tagline
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _taglineSlide,
                          child: FadeTransition(
                            opacity: _taglineOpacity,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.accent.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: AppTheme.accent.withOpacity(0.1),
                        ),
                        child: Text(
                          'Smart Poultry Farm Management',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.accentLight,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Loading dots
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _taglineOpacity,
                          child: child,
                        );
                      },
                      child: const _LoadingDots(),
                    ),
                  ],
                ),
              ),
              // Version
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _taglineOpacity,
                      child: child,
                    );
                  },
                  child: Text(
                    'v1.0.0 · Featherflow Inc.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.3),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PatternPainter());
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 60) {
      for (double y = 0; y < size.height; y += 60) {
        canvas.drawCircle(Offset(x, y), 20, paint);
      }
    }

    final paint2 = Paint()
      ..color = const Color(0xFF4CAF82).withOpacity(0.04)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.15), 120, paint2);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 90, paint2);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final opacity = (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(0.2, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withOpacity(opacity),
              ),
            );
          }),
        );
      },
    );
  }
}