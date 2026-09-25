import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/catalog/domain/craft_flow_provider.dart';

/// Step 2 of Craft Flow: Model suggests description.
///
/// Gives the artisan two distinct choices:
/// 1. Only Photo: AI vision model analyzes craft photo to generate description
/// 2. Photo with Voice: Artisan speaks into mic to combine photo + voice note
class CatalogerScreen extends ConsumerStatefulWidget {
  const CatalogerScreen({super.key});

  @override
  ConsumerState<CatalogerScreen> createState() => _CatalogerScreenState();
}

class _CatalogerScreenState extends ConsumerState<CatalogerScreen>
    with SingleTickerProviderStateMixin {
  late final FlutterTts _tts;
  late final AudioRecorder _audioRecorder;
  late final AnimationController _pulseController;

  bool _isRecording = false;
  bool _isPlayingReadback = false;
  bool _isPlayingPrompt = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _initTts();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
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
              _isPlayingReadback = false;
              _isPlayingPrompt = false;
            });
          }
        })
        ..setCancelHandler(() {
          if (mounted) {
            setState(() {
              _isPlayingReadback = false;
              _isPlayingPrompt = false;
            });
          }
        })
        ..setErrorHandler((_) {
          if (mounted) {
            setState(() {
              _isPlayingReadback = false;
              _isPlayingPrompt = false;
            });
          }
        });
    } catch (_) {}
  }

  Future<void> _speakPrompt(String text) async {
    if (_isPlayingPrompt) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) setState(() => _isPlayingPrompt = false);
      return;
    }

    setState(() {
      _isPlayingPrompt = true;
      _isPlayingReadback = false;
    });

    final lang = ref.read(languageProvider).selectedLanguage;
    try {
      await _tts.stop();
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.speak(text);
    } catch (_) {}
  }

  /// Choice A: Model generates description using ONLY the photo
  Future<void> _onChoosePhotoOnly() async {
    final lang = ref.read(languageProvider).selectedLanguage;
    final strings = lang.strings;

    unawaited(_speakPrompt(strings.choiceAPhotoOnlySpeech));

    await ref
        .read(craftFlowProvider.notifier)
        .generateDescriptionFromPhotoOnly(languageCode: lang.code);

    if (mounted) {
      _playReadback();
    }
  }

  /// Choice B: Start/stop recording voice note to describe craft with Photo + Voice
  Future<void> _toggleVoiceRecording() async {
    final lang = ref.read(languageProvider).selectedLanguage;

    if (_isRecording) {
      // Stop recording
      setState(() => _isRecording = false);
      _pulseController
        ..stop()
        ..reset();

      try {
        final path = await _audioRecorder.stop();
        if (path != null && File(path).existsSync()) {
          await ref.read(craftFlowProvider.notifier).generateDescriptionWithVoice(
                audioFile: File(path),
                languageCode: lang.code,
              );
          if (mounted) {
            _playReadback();
          }
        }
      } catch (e) {
        debugPrint('Error stopping audio recorder: $e');
      }
    } else {
      // Start recording
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission required for voice recording'),
            ),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final path = p.join(
        tempDir.path,
        'voice_catalog_${DateTime.now().millisecondsSinceEpoch}.m4a',
      );

      await _audioRecorder.start(
        const RecordConfig(),
        path: path,
      );

      if (mounted) {
        setState(() => _isRecording = true);
        unawaited(_pulseController.repeat(reverse: true));
      }
    }
  }

  Future<void> _playReadback() async {
    if (_isPlayingReadback) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) setState(() => _isPlayingReadback = false);
      return;
    }

    final craftFlow = ref.read(craftFlowProvider);
    final lang = ref.read(languageProvider).selectedLanguage;
    final isEnglish = lang == AppLanguage.english;

    setState(() {
      _isPlayingReadback = true;
      _isPlayingPrompt = false;
    });

    String speech;
    if (craftFlow.descriptionError != null) {
      speech = isEnglish
          ? 'Description model error: ${craftFlow.descriptionError}'
          : 'विवरण मॉडल में त्रुटि: ${craftFlow.descriptionError}';
    } else if (craftFlow.hasDescription) {
      final title = isEnglish
          ? (craftFlow.titleEn ?? craftFlow.titleHi ?? '')
          : (craftFlow.titleHi ?? craftFlow.titleEn ?? '');
      final desc = isEnglish
          ? (craftFlow.descriptionEn ?? craftFlow.descriptionHi ?? '')
          : (craftFlow.descriptionHi ?? craftFlow.descriptionEn ?? '');
      speech = '$title. $desc';
    } else {
      speech = isEnglish
          ? 'Choose whether to generate description from photo only or with your voice.'
          : 'विवरण बनाने के लिए केवल फोटो या अपनी आवाज़ का विकल्प चुनें।';
    }

    try {
      await _tts.stop();
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.speak(speech);
    } catch (_) {}
  }

  @override
  void dispose() {
    _pulseController.dispose();
    unawaited(_audioRecorder.dispose());
    unawaited(_tts.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langState = ref.watch(languageProvider);
    final lang = langState.selectedLanguage;
    final strings = langState.strings;
    final craftFlow = ref.watch(craftFlowProvider);

    final title = lang == AppLanguage.english
        ? (craftFlow.titleEn ?? craftFlow.titleHi)
        : (craftFlow.titleHi ?? craftFlow.titleEn);
    final description = lang == AppLanguage.english
        ? (craftFlow.descriptionEn ?? craftFlow.descriptionHi)
        : (craftFlow.descriptionHi ?? craftFlow.descriptionEn);

    return Scaffold(
      backgroundColor: Palette.surface,
      appBar: AppBar(
        title: ShilpsetuBrandLogo(language: lang),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Palette.ink),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/capture');
            }
          },
        ),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(Icons.volume_up_rounded, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: Palette.goldAccentLight,
              foregroundColor: Palette.goldAccent,
            ),
            onPressed: () {
              unawaited(_speakPrompt(strings.step2Prompt));
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Step 1 Result Banner: Background Removed Craft Preview ──
              if (craftFlow.hasProcessedImage) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Sizes.cardRadius),
                    border: Border.all(
                      color: Palette.affirm.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.ink.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Palette.surface,
                          borderRadius: BorderRadius.circular(Sizes.radius),
                          border: Border.all(
                            color: Palette.surfaceContainerHigh,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: craftFlow.localProcessedImagePath != null
                            ? Image.file(
                                File(craftFlow.localProcessedImagePath!),
                                fit: BoxFit.contain,
                              )
                            : const Icon(
                                Icons.image_rounded,
                                color: Palette.muted,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TripleChannelStatusBadge(
                              label: strings.step2StoryBadge,
                              icon: Icons.check_circle_rounded,
                              color: Palette.affirm,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              strings.step2Prompt,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Palette.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Sizes.gapMedium),
              ],

              // ── Signature Purple Prompt Banner ─────────────────────────────
              ZeroLiteracyPromptCard(
                promptText: craftFlow.isGeneratingDescription
                    ? strings.choiceAPhotoOnlySpeech
                    : _isRecording
                        ? strings.recordingInProgress
                        : craftFlow.hasDescription
                            ? strings.descriptionPreviewTitle
                            : strings.step2Prompt,
                icon: craftFlow.isGeneratingDescription
                    ? Icons.hourglass_top_rounded
                    : _isRecording
                        ? Icons.graphic_eq_rounded
                        : Icons.auto_awesome_rounded,
                accentColor: _isRecording ? Palette.revise : Palette.purpleContainer,
                onReplayAudio: () {
                  unawaited(_speakPrompt(strings.step2Prompt));
                },
              ),

              const SizedBox(height: Sizes.gapLarge),

              // ── THE TWO CHOICES (Photo Only vs Photo + Voice) ───────────────
              Text(
                strings.step2Prompt,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Palette.ink,
                ),
              ),

              const SizedBox(height: 12),

              // ── CHOICE 1: Only Photo ───────────────────────────────────────
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: craftFlow.isGeneratingDescription || _isRecording
                      ? null
                      : _onChoosePhotoOnly,
                  borderRadius: BorderRadius.circular(Sizes.cardRadius),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !craftFlow.usedVoice && craftFlow.hasDescription
                          ? Palette.purpleContainerLight
                          : Colors.white,
                      borderRadius: BorderRadius.circular(Sizes.cardRadius),
                      border: Border.all(
                        color: !craftFlow.usedVoice && craftFlow.hasDescription
                            ? Palette.purpleContainer
                            : Palette.surfaceContainerHigh,
                        width: !craftFlow.usedVoice && craftFlow.hasDescription ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.ink.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Palette.purpleContainerLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Palette.purpleContainerDark,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.choiceAPhotoOnlyTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Palette.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                strings.choiceAPhotoOnlySubtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (craftFlow.isGeneratingDescription && !craftFlow.usedVoice)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        else
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Palette.purpleContainerDark,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── CHOICE 2: Photo with Voice ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: craftFlow.usedVoice && craftFlow.hasDescription
                      ? Palette.purpleContainerLight
                      : Colors.white,
                  borderRadius: BorderRadius.circular(Sizes.cardRadius),
                  border: Border.all(
                    color: craftFlow.usedVoice && craftFlow.hasDescription
                        ? Palette.purpleContainer
                        : Palette.surfaceContainerHigh,
                    width: craftFlow.usedVoice && craftFlow.hasDescription ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.ink.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Palette.goldAccentLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.mic_rounded,
                            color: Palette.goldAccent,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.choiceBVoiceTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Palette.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                strings.choiceBVoiceSubtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Giant Mic Button
                    Center(
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final scale = _isRecording
                                  ? 1.0 + (_pulseController.value * 0.12)
                                  : 1.0;
                              return Transform.scale(
                                scale: scale,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: craftFlow.isGeneratingDescription
                                        ? null
                                        : _toggleVoiceRecording,
                                    borderRadius: BorderRadius.circular(55),
                                    child: Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: _isRecording
                                              ? [Palette.revise, const Color(0xFFD32F2F)]
                                              : [
                                                  Palette.purpleContainer,
                                                  Palette.purpleContainerDark,
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (_isRecording
                                                    ? Palette.revise
                                                    : Palette.purpleContainerDark)
                                                .withValues(alpha: 0.35),
                                            blurRadius: _isRecording ? 20 : 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        _isRecording
                                            ? Icons.stop_rounded
                                            : Icons.mic_rounded,
                                        size: 44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.choiceBVoiceButton(_isRecording),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _isRecording
                                  ? Palette.revise
                                  : Palette.purpleContainerDark,
                            ),
                          ),
                          if (_isRecording) ...[
                            const SizedBox(height: 8),
                            const SoundWaveBars(
                              color: Palette.revise,
                              barCount: 7,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Sizes.gapLarge),

              // ── Loading Indicator ──────────────────────────────────────────
              if (craftFlow.isGeneratingDescription) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Sizes.cardRadius),
                    border: Border.all(color: Palette.surfaceContainerHigh),
                  ),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        color: Palette.purpleContainerDark,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        strings.choiceAPhotoOnlySpeech,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Palette.ink,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Sizes.gapLarge),
              ],

              // ── Error Banner (No Hardcoded Fallback!) ──────────────────────
              if (craftFlow.descriptionError != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Palette.revise.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Sizes.cardRadius),
                    border: Border.all(color: Palette.revise, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Palette.revise,
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              craftFlow.descriptionError!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Palette.revise,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Sizes.gapLarge),
              ],

              // ── Generated Description Display ──────────────────────────────
              if (craftFlow.hasDescription) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Sizes.cardRadius),
                    border: Border.all(
                      color: Palette.purpleContainer.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.purpleContainer.withValues(alpha: 0.1),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: Palette.purpleContainerDark,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              strings.descriptionPreviewTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Palette.ink,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isPlayingReadback
                                  ? Icons.volume_up_rounded
                                  : Icons.play_circle_fill_rounded,
                              color: Palette.purpleContainerDark,
                              size: 28,
                            ),
                            onPressed: _playReadback,
                          ),
                        ],
                      ),
                      if (title != null && title.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Palette.ink,
                          ),
                        ),
                      ],
                      if (craftFlow.features.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: craftFlow.features.map((attr) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Palette.purpleContainerLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Palette.purpleContainer
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                attr,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Palette.purpleContainerDark,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      if (description != null && description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Palette.ink,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: Sizes.gapLarge),

                // Step 3 Proceed Button
                SpokenActionButton(
                  onPressed: () {
                    context.push('/pricing');
                  },
                  icon: Icons.currency_rupee_rounded,
                  label: strings.continueToPricingButton,
                  subtitle: strings.continueToPricingSubtitle,
                  backgroundColor: Palette.amberButton,
                  foregroundColor: Palette.ink,
                  isLarge: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
