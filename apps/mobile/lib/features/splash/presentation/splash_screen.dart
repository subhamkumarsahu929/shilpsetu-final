import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/database/database_provider.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/auth/data/firebase_auth_service.dart';
import 'package:shilpsetu/features/catalog/domain/catalog_feed_provider.dart';

/// Professional & Commercial Splash Screen for ShilpSetu.
///
/// Features:
/// - Commercial grade deep royal indigo & terracotta artisanal branding
/// - Hero animated app logo badge loaded via asset method (`assets/icons/app_logo.png`)
/// - Dynamic breathing aura & spring entrance animation
/// - Smart pre-fetching pipeline:
///   1. Pre-caches core image assets
///   2. Warms up Drift SQLite local offline database
///   3. Pre-fetches catalog products feed in background
///   4. Pre-configures Text-to-Speech (TTS) audio engine for 0ms voice lag
///   5. Validates authentication session & routes to `/home` or `/language`
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _pulseAnimation;

  double _loadingProgress = 0.05;
  String _statusText = 'Starting ShilpSetu...';
  String _indicStatusText = 'शिल्पसेतु प्रारंभ हो रहा है...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSmartInitialization();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.7, 1, curve: Curves.easeInOut),
      ),
    );

    _animController.forward();
  }

  /// Coordinates smart background data pre-fetching while keeping UI at 60 FPS
  Future<void> _startSmartInitialization() async {
    final startTime = DateTime.now();
    var isAuthenticated = false;

    // ── Phase 1: Pre-cache core asset image & check security ────────────────
    _updateProgress(0.20, 'Securing local environment...', 'सुरक्षित वातावरण तैयार किया जा रहा है...');
    try {
      if (mounted) {
        await precacheImage(const AssetImage('assets/icons/app_logo.png'), context);
      }
    } catch (_) {}
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // ── Phase 2: Warm Drift SQLite Database ─────────────────────────────────
    _updateProgress(0.45, 'Warming local offline cache...', 'ऑफलाइन स्टोरेज लोड हो रहा है...');
    try {
      final db = ref.read(databaseProvider);
      // Touch localProducts table to ensure sqlite database file is ready
      await db.select(db.localProducts).get();
    } catch (_) {}
    await Future<void>.delayed(const Duration(milliseconds: 350));

    // ── Phase 3: Pre-fetch Catalog Feed from Backend ────────────────────────
    _updateProgress(0.70, 'Syncing craft catalogs & fair wages...', 'शिल्प कैटलॉग सिंक हो रहा है...');
    try {
      await ref.read(catalogFeedProvider.notifier).loadFeed();
    } catch (_) {}
    await Future<void>.delayed(const Duration(milliseconds: 350));

    // ── Phase 4: Pre-warm Text-to-Speech Engine ─────────────────────────────
    _updateProgress(0.88, 'Configuring voice & speech assistant...', 'ध्वनि सहायक तैयार किया जा रहा है...');
    try {
      final tts = FlutterTts();
      final lang = ref.read(languageProvider).selectedLanguage;
      await tts.setLanguage(lang.ttsLocale);
      await tts.setSpeechRate(0.45);
      await tts.setPitch(1);
    } catch (_) {}

    // ── Phase 5: Validate Session & Route Decision ──────────────────────────
    _updateProgress(1, 'Ready! Welcome to ShilpSetu', 'तैयार! शिल्पसेतु में आपका स्वागत है');
    try {
      final auth = ref.read(firebaseAuthServiceProvider);
      isAuthenticated = auth.auth?.currentUser != null;
    } catch (_) {
      isAuthenticated = false;
    }

    // Ensure the commercial splash is visible for at least 2.2 seconds for branding
    final elapsedTime = DateTime.now().difference(startTime);
    const minDisplayDuration = Duration(milliseconds: 2200);
    if (elapsedTime < minDisplayDuration) {
      await Future<void>.delayed(minDisplayDuration - elapsedTime);
    }

    if (!mounted) return;

    // Smooth navigation to destination
    if (isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/language');
    }
  }

  void _updateProgress(double progress, String status, String indicStatus) {
    if (!mounted) return;
    setState(() {
      _loadingProgress = progress;
      _statusText = status;
      _indicStatusText = indicStatus;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background: Deep Midnight Navy & Terracotta Radial Gradient ───
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.25),
                radius: 1.15,
                colors: [
                  Color(0xFF242C5B), // Royal Navy Highlight
                  Color(0xFF131735), // Deep Midnight Slate
                  Color(0xFF0C0E20), // Ink Base
                ],
              ),
            ),
          ),

          // ── Subtle Artisanal Circular Motif In Background ─────────────────
          Positioned(
            top: size.height * 0.18,
            left: (size.width - 320) / 2,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Palette.logoOrange.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.14,
            left: (size.width - 400) / 2,
            child: IgnorePointer(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
          ),

          // ── Main Content: Hero Logo, Brand Titles, Dynamic Loader ─────────
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Hero Logo Card with Spring + Breathing Aura
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final scale = _scaleAnimation.value * _pulseAnimation.value;
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.scale(
                        scale: scale,
                        child: child,
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.logoOrange.withValues(alpha: 0.35),
                            blurRadius: 36,
                            spreadRadius: 2,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: const Color(0xFF2C328E).withValues(alpha: 0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.9),
                          width: 2.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          'assets/icons/app_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const ColoredBox(
                            color: Palette.logoBadgeBg,
                            child: Icon(
                              Icons.palette_rounded,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Brand Name: 'shilp' (white) + 'setu' (terracotta)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                          children: [
                            TextSpan(
                              text: 'shilp',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: 'setu',
                              style: TextStyle(
                                color: Color(0xFFFF6F43), // Vibrant Terracotta
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Commercial Tagline
                      Text(
                        'Market On-Ramp for Marginalised Artisans',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Indic Heritage Tagline
                      Text(
                        'हस्तशिल्प से स्वावलंबन • डिजिटल भारत',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFFC078).withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // ── Smart Dynamic Loading Section ───────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    children: [
                      // Smooth Animated Linear Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 6,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0,
                              end: _loadingProgress,
                            ),
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, _) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.white.withValues(alpha: 0.12),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF7A45),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Live Dynamic Status Messages
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          key: ValueKey<String>(_statusText),
                          children: [
                            Text(
                              _statusText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _indicStatusText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // ── Footer ──────────────────────────────────────────────────
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'v1.0.0 • Production Build',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0x66FFFFFF),
                      letterSpacing: 0.5,
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
