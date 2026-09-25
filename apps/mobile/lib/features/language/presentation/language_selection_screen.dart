import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';

/// First screen shown when launching Shilpsetu.
///
/// Features:
/// - Prompts artisan to select preferred native language
/// - Audio previews for each language
/// - Enforces chosen language across entire app UI and TTS audio readouts
class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  late final FlutterTts _tts;
  AppLanguage _selected = AppLanguage.hindi;
  String? _currentlySpeakingCode;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    _tts = FlutterTts();
    try {
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1);
      _tts
        ..setCompletionHandler(() {
          if (mounted) setState(() => _currentlySpeakingCode = null);
        })
        ..setCancelHandler(() {
          if (mounted) setState(() => _currentlySpeakingCode = null);
        })
        ..setErrorHandler((_) {
          if (mounted) setState(() => _currentlySpeakingCode = null);
        });
    } catch (_) {}
  }

  Future<void> _speakLanguageGreeting(AppLanguage language) async {
    if (_currentlySpeakingCode == language.code) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) {
        setState(() => _currentlySpeakingCode = null);
      }
      return;
    }

    setState(() {
      _currentlySpeakingCode = language.code;
    });

    try {
      await _tts.stop();
      await _tts.setLanguage(language.ttsLocale);
      await _tts.speak(language.greeting);
    } catch (_) {
      if (mounted) {
        setState(() => _currentlySpeakingCode = null);
      }
    }
  }

  void _onLanguageSelected(AppLanguage language) {
    setState(() {
      _selected = language;
    });
    unawaited(_speakLanguageGreeting(language));
  }

  void _confirmLanguage() {
    ref.read(languageProvider.notifier).setLanguage(_selected);

    // Navigate to Login/Registration flow
    context.go('/auth');
  }

  @override
  void dispose() {
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: ShilpsetuBrandLogo(language: _selected),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Zero-Literacy Audio Header Card
            Padding(
              padding: const EdgeInsets.all(Sizes.gutter),
              child: ZeroLiteracyPromptCard(
                promptText: _selected.strings.chooseLanguagePrompt,
                icon: Icons.record_voice_over_rounded,
                onReplayAudio: () {
                  unawaited(_speakLanguageGreeting(_selected));
                },
              ),
            ),

            // Language Cards Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.gutter),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemCount: AppLanguage.values.length,
                itemBuilder: (context, index) {
                  final lang = AppLanguage.values[index];
                  final isSelected = _selected == lang;
                  final isSpeaking = _currentlySpeakingCode == lang.code;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onLanguageSelected(lang),
                      borderRadius: BorderRadius.circular(Sizes.cardRadius),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(Sizes.cardRadius),
                          border: Border.all(
                            color: isSelected
                                ? Palette.primary
                                : Palette.surfaceContainerHigh,
                            width: isSelected ? 3 : 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? Palette.primary.withValues(alpha: 0.18)
                                  : Palette.ink.withValues(alpha: 0.04),
                              blurRadius: isSelected ? 14 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Script Glyph Circle Avatar
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Palette.primary
                                          : Palette.surfaceContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      lang.scriptGlyph,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: isSelected
                                            ? Colors.white
                                            : Palette.ink,
                                      ),
                                    ),
                                  ),

                                  // Native & English Label
                                  Column(
                                    children: [
                                      Text(
                                        lang.nameNative,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected
                                              ? Palette.primary
                                              : Palette.ink,
                                        ),
                                      ),
                                      Text(
                                        lang.nameEnglish,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Palette.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Audio speaker icon button in top right
                            Positioned(
                              top: 6,
                              right: 6,
                              child: IconButton(
                                iconSize: 22,
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  isSpeaking
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_mute_rounded,
                                  color: isSpeaking
                                      ? Palette.goldAccent
                                      : Palette.muted,
                                ),
                                onPressed: () =>
                                    _speakLanguageGreeting(lang),
                              ),
                            ),

                            // Selected checkmark in top left
                            if (isSelected)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Palette.affirm,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Confirm Language Action Button (96dp target)
            Padding(
              padding: const EdgeInsets.all(Sizes.gutter),
              child: SpokenActionButton(
                onPressed: _confirmLanguage,
                icon: Icons.check_circle_rounded,
                label: '${_selected.strings.continueButton} (${_selected.nameNative})',
                subtitle: _selected.strings.setupProfile,
                backgroundColor: Palette.affirm,
                isLarge: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
