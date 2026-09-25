import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/auth/presentation/controllers/auth_controller.dart';
import 'package:shilpsetu/features/home/presentation/widgets/app_info_menu.dart';

/// The Primary Home Screen for Shilpsetu.
///
/// Designed per the exact signature visual style:
/// - Brand logo (blue connected node icon + 'shilp' ink + 'setu' terracotta)
/// - "Namaste, {Name}" greeting
/// - Signature purple hero containers with amber buttons and sparkles
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final FlutterTts _tts;
  String? _currentlySpeakingCardId;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();
    try {
      final lang = ref.read(languageProvider).selectedLanguage;
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1);
      _tts
        ..setCompletionHandler(() {
          if (mounted) {
            setState(() {
              _currentlySpeakingCardId = null;
            });
          }
        })
        ..setCancelHandler(() {
          if (mounted) {
            setState(() {
              _currentlySpeakingCardId = null;
            });
          }
        })
        ..setErrorHandler((_) {
          if (mounted) {
            setState(() {
              _currentlySpeakingCardId = null;
            });
          }
        });
    } catch (_) {}
  }

  Future<void> _speakText({required String cardId, required String text}) async {
    if (_currentlySpeakingCardId == cardId) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _currentlySpeakingCardId = null;
        });
      }
      return;
    }

    setState(() {
      _currentlySpeakingCardId = cardId;
    });

    final lang = ref.read(languageProvider).selectedLanguage;
    try {
      await _tts.stop();
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.speak(text);
    } catch (_) {}
  }

  @override
  void dispose() {
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langState = ref.watch(languageProvider);
    final lang = langState.selectedLanguage;
    final strings = langState.strings;
    final authState = ref.watch(authControllerProvider);
    final artisanName = authState.currentUser?.name ?? strings.artisanFallback;

    return Scaffold(
      backgroundColor: Palette.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: ShilpsetuBrandLogo(language: lang),
        actions: [
          // Language Switcher Badge
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Palette.surfaceContainer,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => context.go('/language'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Palette.logoBadgeBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    lang.scriptGlyph,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  lang.nameNative,
                  style: const TextStyle(
                    color: Palette.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton.filledTonal(
            icon: const Icon(Icons.volume_up_rounded, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: Palette.goldAccentLight,
              foregroundColor: Palette.goldAccent,
            ),
            tooltip: strings.homeOverviewTooltip,
            onPressed: () {
              unawaited(
                _speakText(
                  cardId: 'header',
                  text: strings.homeOverviewSpeech(artisanName),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          const AppInfoIconButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.gutter,
            vertical: Sizes.gapMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Text(
                strings.greeting(artisanName),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Palette.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                strings.whatWillYouMake,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Palette.muted,
                ),
              ),

              const SizedBox(height: Sizes.gapLarge),

              // 1. Signature Purple Hero Card (Voice-First Cataloging)
              ShilpsetuPurpleCard(
                tag: strings.voiceCatalogingTag,
                title: strings.voiceCatalogingTitle,
                subtitle: strings.voiceCatalogingSubtitle,
                buttonText: strings.voiceCatalogingButton,
                onTap: () => context.push('/cataloger'),
                isSpeaking: _currentlySpeakingCardId == 'voice_card',
                onSpeak: () => _speakText(
                  cardId: 'voice_card',
                  text: strings.voiceCatalogingSpeech,
                ),
              ),

              const SizedBox(height: Sizes.gapLarge),

              // Section Header
              Row(
                children: [
                  Text(
                    strings.smartArtisanTools,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Palette.terracotta,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.auto_awesome,
                    color: Palette.terracotta.withValues(alpha: 0.8),
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: Sizes.gapSmall),

              // 2. Purple Container: Transparent Fair-Wage Pricing
              ShilpsetuPurpleCard(
                tag: strings.priceCalculatorTag,
                title: strings.priceCalculatorTitle,
                subtitle: strings.priceCalculatorSubtitle,
                buttonText: strings.priceCalculatorButton,
                icon: Icons.balance_rounded,
                tagIcon: Icons.currency_rupee_rounded,
                onTap: () => context.push('/pricing'),
                isSpeaking: _currentlySpeakingCardId == 'price_card',
                onSpeak: () => _speakText(
                  cardId: 'price_card',
                  text: strings.priceCalculatorSpeech,
                ),
              ),

              const SizedBox(height: Sizes.gapMedium),

              // 3. Purple Container: On-Device Craft Recognition
              ShilpsetuPurpleCard(
                tag: strings.offlineRecogTag,
                title: strings.offlineRecogTitle,
                subtitle: strings.offlineRecogSubtitle,
                buttonText: strings.offlineRecogButton,
                icon: Icons.document_scanner_rounded,
                tagIcon: Icons.camera_alt_rounded,
                onTap: () => context.go('/capture'),
                isSpeaking: _currentlySpeakingCardId == 'recog_card',
                onSpeak: () => _speakText(
                  cardId: 'recog_card',
                  text: strings.offlineRecogSpeech,
                ),
              ),

              const SizedBox(height: Sizes.gapMedium),

              // 4. Purple Container: Photo Studio
              ShilpsetuPurpleCard(
                tag: strings.studioTag,
                title: strings.studioTitle,
                subtitle: strings.studioSubtitle,
                buttonText: strings.studioButton,
                icon: Icons.photo_filter_rounded,
                tagIcon: Icons.auto_fix_high_rounded,
                onTap: () => context.go('/capture'),
                isSpeaking: _currentlySpeakingCardId == 'studio_card',
                onSpeak: () => _speakText(
                  cardId: 'studio_card',
                  text: strings.studioSpeech,
                ),
              ),

              const SizedBox(height: Sizes.gapLarge),
            ],
          ),
        ),
      ),
    );
  }
}
