import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/capture/domain/models/captured_craft.dart';
import 'package:shilpsetu/features/capture/presentation/controllers/capture_controller.dart';
import 'package:shilpsetu/features/catalog/domain/craft_flow_provider.dart';
import 'package:shilpsetu/features/home/presentation/widgets/app_info_menu.dart';
import 'package:shilpsetu/ml/models/quality_assessment.dart';

/// Primary capture screen.
///
/// Features:
/// - Direct mobile camera viewfinder integration with real-time shutter photo taking
/// - Displays and speaks exclusively in the user's selected language
/// - Real-time viewfinder with studio guidelines
/// - Pre-shutter quality gate HUD banner (blur, backlight, underexposure)
/// - 96dp primary capture shutter button (Sizes.primaryActionTarget)
/// - 64dp secondary control buttons (Sizes.minTouchTarget)
class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen>
    with SingleTickerProviderStateMixin {
  late final FlutterTts _tts;
  late final AnimationController _pulseController;
  QualityIssue? _lastSpokenIssue;

  CameraController? _cameraController;
  List<CameraDescription> _cameras = const [];
  int _selectedCameraIndex = 0;
  bool _isCameraInitializing = true;
  bool _isPlayingPrompt = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initCamera();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
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
              _isPlayingPrompt = false;
            });
          }
        })
        ..setCancelHandler(() {
          if (mounted) {
            setState(() {
              _isPlayingPrompt = false;
            });
          }
        })
        ..setErrorHandler((_) {
          if (mounted) {
            setState(() {
              _isPlayingPrompt = false;
            });
          }
        });
    } catch (_) {}
  }

  Future<void> _initCamera() async {
    setState(() {
      _isCameraInitializing = true;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final selected = _cameras[_selectedCameraIndex];
        final controller = CameraController(
          selected,
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await controller.initialize();
        if (mounted) {
          setState(() {
            _cameraController = controller;
            _isCameraInitializing = false;
          });
          ref
              .read(captureControllerProvider.notifier)
              .setCameraReady(isReady: true);
        }
      } else {
        if (mounted) {
          setState(() {
            _isCameraInitializing = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
        });
        ref
            .read(captureControllerProvider.notifier)
            .setCameraReady(isReady: false);
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length <= 1) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _cameraController?.dispose();
    _cameraController = null;
    await _initCamera();
  }

  Future<void> _toggleFlash() async {
    final captureState = ref.read(captureControllerProvider);
    final nextFlash = !captureState.isFlashOn;

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.setFlashMode(
          nextFlash ? FlashMode.torch : FlashMode.off,
        );
      } catch (_) {}
    }

    ref.read(captureControllerProvider.notifier).toggleFlash();
  }

  Future<void> _speakPrompt(String text) async {
    if (_isPlayingPrompt) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _isPlayingPrompt = false;
        });
      }
      return;
    }

    setState(() {
      _isPlayingPrompt = true;
    });

    final lang = ref.read(languageProvider).selectedLanguage;
    try {
      await _tts.stop();
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.speak(text);
    } catch (_) {}
  }

  String _getQualityMessage(QualityIssue issue) {
    final lang = ref.read(languageProvider.notifier);
    switch (issue) {
      case QualityIssue.blur:
        return lang.text(
          en: 'Photo is blurry. Please hold steady.',
          hi: 'फ़ोटो धुंधली है। कृपया हाथ स्थिर रखें।',
          bn: 'ছবিটি ঝাপসা। অনুগ্রহ করে স্থির থাকুন।',
          te: 'ఫోటో మసకగా ఉంది. దయచేసి స్థిరంగా పట్టుకోండి.',
          ta: 'புகைப்படம் மங்கலாக உள்ளது. நிலையாக பிடிக்கவும்.',
          or_: 'ଫଟୋ ଅସ୍ପଷ୍ଟ ଅଛି। ଦୟାକରି ସ୍ଥିର ରୁହନ୍ତୁ।',
          gu: 'ફોટો ઝાંખો છે. કૃપા કરીને સ્થિર રહો.',
          mr: 'फोटो अस्पष्ट आहे. कृपया स्थिर ठेवा.',
        );
      case QualityIssue.tooDark:
        return lang.text(
          en: 'Too dark. Please move towards light.',
          hi: 'बहुत अंधेरा है। कृपया रोशनी में जाएं।',
          bn: 'অনেক অন্ধকার। উজ্জ্বল আলোতে যান।',
          te: 'చాలా చీకటిగా ఉంది. వెలుతురులోకి వెళ్ళండి.',
          ta: 'மிகவும் இருட்டாக உள்ளது. வெளிச்சத்திற்கு செல்லுங்கள்.',
          or_: 'ବହୁତ ଅନ୍ଧାର। ଆଲୋ ଥିବା ଜାଗାକୁ ଯାନ୍ତୁ।',
          gu: 'ખૂબ અંધારું છે. તેજ પ્રકાશ તરફ જાઓ.',
          mr: 'खूप अंधार आहे. उजळ प्रकाशात जा.',
        );
      case QualityIssue.backlight:
        return lang.text(
          en: 'Backlight detected. Face towards light.',
          hi: 'रोशनी वस्तु के पीछे है। रोशनी की ओर मुख करें।',
          bn: 'আলো বস্তুর পেছনে। আলোর দিকে মুখ করুন।',
          te: 'వెలుతురు వస్తువు వెనకాల ఉంది. వెలుతురు వైపు మొహం పెట్టండి.',
          ta: 'வெளிச்சம் பொருளின் பின்னால் உள்ளது. திரும்புங்கள்.',
          or_: 'ଆଲୋ ବସ୍ତୁ ପଛରେ ଅଛି। ଆଲୋ ଆଡ଼କୁ ମୁହଁ ଘୁଞ୍ଚାନ୍ତୁ।',
          gu: 'પ્રકાશ વસ્તુ પાછળ છે. પ્રકાશ તરફ મોં ફેરવો.',
          mr: 'प्रकाश वस्तूच्या मागे आहे. प्रकाशाकडे तोंड करा.',
        );
      case QualityIssue.none:
        return lang.text(
          en: 'Ready to capture',
          hi: 'फ़ोटो लेने के लिए तैयार',
          bn: 'ছবি তোলার জন্য প্রস্তুত',
          te: 'ఫోటో తీయడానికి సిద్ధం',
          ta: 'புகைப்படம் எடுக்க தயார்',
          or_: 'ଫଟୋ ନେବାକୁ ପ୍ରସ୍ତୁତ',
          gu: 'ફોટો પાડવા તૈયાર',
          mr: 'फोटो काढण्यास तयार',
        );
    }
  }

  void _handleQualityAlert(QualityAssessment quality) {
    if (!quality.isAcceptable && quality.issue != QualityIssue.none) {
      if (_lastSpokenIssue != quality.issue) {
        _lastSpokenIssue = quality.issue;
        final msg = _getQualityMessage(quality.issue);
        unawaited(_speakPrompt(msg));
      }
    } else {
      _lastSpokenIssue = null;
    }
  }

  /// Triggers mobile camera picture capture and ML studio pipeline
  Future<void> _onShutterPressed() async {
    final controller = ref.read(captureControllerProvider.notifier);
    final isEnglish =
        ref.read(languageProvider).selectedLanguage == AppLanguage.english;

    Uint8List? rawBytes;

    // 1. Take real picture from mobile camera hardware
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final xFile = await _cameraController!.takePicture();
        rawBytes = await xFile.readAsBytes();
      } catch (_) {
        // Fall back to image synthesizer if camera IO is interrupted
      }
    }

    // 2. Reject capture if no real camera frame was received (no hardcoded/synthetic fallback)
    if (rawBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Palette.revise,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.radius),
            ),
            content: Text(
              isEnglish
                  ? 'Camera capture failed: no frame data received. Please ensure camera is active.'
                  : 'कैमरा से फोटो नहीं मिल सकी। कृपया पुनः प्रयास करें।',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );
      }
      return;
    }

    final craft = await controller.captureAndProcess(rawBytes);

    if (!mounted) return;

    if (craft != null) {
      // Step 1: Register background-removed photo with the CraftFlow state
      await ref.read(craftFlowProvider.notifier).setProcessedImage(
        localPath: craft.localProcessedPath,
        rawImagePath: craft.rawImagePath,
      );

      if (!mounted) return;

      // Show background-removed preview modal directly in the app
      await _showBackgroundRemovedPreview(craft);
    }
  }

  /// Step 1: Displays the background-removed image in the app so the artisan can verify the model worked
  Future<void> _showBackgroundRemovedPreview(CapturedCraft craft) async {
    final lang = ref.read(languageProvider).selectedLanguage;
    final isEnglish = lang == AppLanguage.english;

    final spokenPrompt = isEnglish
        ? 'Photo captured and background removed. Let us create your craft description.'
        : 'फोटो ले ली गई है और एआई मॉडल ने बैकग्राउंड हटा दिया है। आइए अब विवरण तैयार करते हैं।';

    unawaited(_speakPrompt(spokenPrompt));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(Sizes.gutter, 16, Sizes.gutter, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Palette.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.auto_fix_high_rounded,
                    color: Palette.affirm,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isEnglish ? 'Background Removed' : 'बैकग्राउंड हटाया गया',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Palette.ink,
                      ),
                    ),
                  ),
                  TripleChannelStatusBadge(
                    label: isEnglish ? 'Studio Ready' : 'स्टूडियो तैयार',
                    icon: Icons.check_circle_rounded,
                    color: Palette.affirm,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Segmented craft preview
              Container(
                height: 240,
                decoration: BoxDecoration(
                  color: Palette.surface,
                  borderRadius: BorderRadius.circular(Sizes.cardRadius),
                  border: Border.all(
                    color: Palette.affirm.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.ink.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.file(
                      File(craft.localProcessedPath),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isEnglish
                              ? 'Model isolated in ${craft.processingDurationMs}ms'
                              : '${craft.processingDurationMs}ms में बैकग्राउंड अलग किया',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Continue to Step 2
              SpokenActionButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.push('/cataloger');
                },
                icon: Icons.auto_awesome_rounded,
                label: isEnglish ? 'Next: Describe Craft' : 'आगे: विवरण तैयार करें',
                subtitle: isEnglish
                    ? 'Choose photo-only or photo with voice'
                    : 'केवल फोटो या आवाज़ जोड़कर विवरण चुनें',
                backgroundColor: Palette.amberButton,
                foregroundColor: Palette.ink,
                isLarge: true,
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, Sizes.minTouchTarget),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.radius),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  isEnglish ? 'Retake Photo' : 'दोबारा फोटो लें',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    unawaited(_tts.stop());
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(captureControllerProvider);
    final langState = ref.watch(languageProvider);
    final lang = langState.selectedLanguage;
    final strings = langState.strings;
    final quality = captureState.quality;

    ref.listen<CaptureState>(captureControllerProvider, (prev, next) {
      if (prev?.quality.issue != next.quality.issue) {
        _handleQualityAlert(next.quality);
      }
    });

    final hasWarning = !quality.isAcceptable;
    final qualityMsg = _getQualityMessage(quality.issue);
    final isCameraActive =
        _cameraController != null && _cameraController!.value.isInitialized;

    return Scaffold(
      backgroundColor: Palette.surface,
      appBar: AppBar(
        title: ShilpsetuBrandLogo(language: lang),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton.filledTonal(
            icon: Icon(
              _isPlayingPrompt
                  ? Icons.stop_rounded
                  : Icons.volume_up_rounded,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Palette.goldAccentLight,
              foregroundColor: Palette.goldAccent,
            ),
            tooltip: strings.captureInstructionsTooltip,
            onPressed: () {
              unawaited(_speakPrompt(strings.captureInstructionsSpeech));
            },
          ),
          const SizedBox(width: 6),
          const AppInfoIconButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Zero-Literacy Prompt Banner
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.gutter,
                vertical: Sizes.gapSmall,
              ),
              child: ZeroLiteracyPromptCard(
                promptText: strings.capturePrompt,
                icon: Icons.camera_alt_rounded,
                onReplayAudio: () {
                  unawaited(_speakPrompt(strings.capturePromptReplay));
                },
              ),
            ),

            // Live Camera Viewfinder Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Sizes.gutter),
                decoration: BoxDecoration(
                  color: const Color(0xFF12141A),
                  borderRadius: BorderRadius.circular(Sizes.cardRadius + 4),
                  border: Border.all(
                    color: hasWarning
                        ? Palette.warning
                        : Palette.purpleContainer.withValues(alpha: 0.6),
                    width: hasWarning ? 3.5 : 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: hasWarning
                          ? Palette.warning.withValues(alpha: 0.3)
                          : Palette.purpleContainerDark.withValues(alpha: 0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.cardRadius + 2),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // 1. Live Camera Preview Stream
                      if (isCameraActive)
                        SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _cameraController!
                                      .value.previewSize?.height ??
                                  400,
                              height: _cameraController!
                                      .value.previewSize?.width ??
                                  400,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        )
                      else if (_isCameraInitializing)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Palette.purpleContainer,
                          ),
                        )
                      else
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(Sizes.gapSmall),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_rounded,
                                  size: 64,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  strings.pointCamera,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // 2. Viewfinder Target Guideline Frame
                      Center(
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final scale =
                                1.0 + (_pulseController.value * 0.04);
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 240,
                                height: 240,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: hasWarning
                                        ? Palette.warning
                                        : Colors.white.withValues(alpha: 0.75),
                                    width: 2.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                     Center(
                                       child: Icon(
                                         Icons.add_rounded,
                                         size: 32,
                                         color: Colors.white
                                             .withValues(alpha: 0.6),
                                       ),
                                     ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Center craft label badge
                      Positioned(
                        bottom: 16,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius:
                                  BorderRadius.circular(Sizes.radius),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              strings.pointCamera,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Pre-shutter Quality Gate Overlay Banner
                      if (hasWarning)
                        Positioned(
                          top: 14,
                          left: 14,
                          right: 14,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Palette.warningLight,
                              borderRadius:
                                  BorderRadius.circular(Sizes.radius),
                              border: Border.all(
                                color: Palette.warning,
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Palette.warning,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    qualityMsg,
                                    style: const TextStyle(
                                      color: Palette.ink,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                IconButton.filledTonal(
                                  icon: const Icon(
                                    Icons.volume_up_rounded,
                                    color: Palette.warning,
                                    size: 22,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    unawaited(_speakPrompt(qualityMsg));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Active ML processing overlay
                      if (captureState.isProcessing)
                        ColoredBox(
                          color: Colors.black87,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: Palette.amberButton,
                                  strokeWidth: 4.5,
                                ),
                                const SizedBox(height: Sizes.gapMedium),
                                Text(
                                  strings.offlineMlActive,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,  
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Shutter & Camera Controls
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.gutter,
                vertical: Sizes.gapMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera Switch (Front / Back)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: captureState.isProcessing ? null : _switchCamera,
                      borderRadius: BorderRadius.circular(32),
                      child: Ink(
                        width: Sizes.minTouchTarget,
                        height: Sizes.minTouchTarget,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Palette.muted.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Palette.ink.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.cameraswitch_rounded,
                          size: 28,
                          color: Palette.ink,
                        ),
                      ),
                    ),
                  ),

                  // Giant 96dp Shutter Button (Takes Photo)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap:
                          captureState.isProcessing ? null : _onShutterPressed,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: Sizes.primaryActionTarget,
                        height: Sizes.primaryActionTarget,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: hasWarning
                                ? [Palette.warning, const Color(0xFFB45309)]
                                : [
                                    Palette.amberButton,
                                    const Color(0xFFE89A1B),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (hasWarning
                                      ? Palette.warning
                                      : Palette.amberButton)
                                  .withValues(alpha: 0.45),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3.5),
                          ),
                          child: captureState.isProcessing
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Palette.ink,
                                    strokeWidth: 3.5,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 46,
                                  color: Palette.ink,
                                ),
                        ),
                      ),
                    ),
                  ),

                  // Flash Torch Toggle Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: captureState.isProcessing ? null : _toggleFlash,
                      borderRadius: BorderRadius.circular(32),
                      child: Ink(
                        width: Sizes.minTouchTarget,
                        height: Sizes.minTouchTarget,
                        decoration: BoxDecoration(
                          color: captureState.isFlashOn
                              ? Palette.amberButton
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: captureState.isFlashOn
                                ? Palette.amberButton
                                : Palette.muted.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Palette.ink.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          captureState.isFlashOn
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color: captureState.isFlashOn
                              ? Palette.ink
                              : Palette.muted,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
