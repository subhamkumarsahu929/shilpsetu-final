import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/auth/presentation/controllers/auth_controller.dart';

/// Authentication & Registration Screen.
///
/// Features:
/// - Displays and speaks exclusively in the user's selected language
/// - Zero mixed-language words or bilingual slashes
/// - Validates Name and Indian Mobile Number (10 digits)
/// - Direct transition to Home upon successful authentication
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late final FlutterTts _tts;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isRegisterMode = true;
  String? _selectedCraft;
  String? _customError;

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
    } catch (_) {}
  }

  Future<void> _speakPrompt(String text) async {
    final lang = ref.read(languageProvider).selectedLanguage;
    try {
      await _tts.stop();
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.speak(text);
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    unawaited(_tts.stop());
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _customError = null;
    });

    final controller = ref.read(authControllerProvider.notifier);
    final langState = ref.read(languageProvider);
    final strings = langState.strings;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    final craftList = strings.craftOptions;
    final activeCraft = _selectedCraft ?? craftList.first;

    if (_isRegisterMode && name.length < 2) {
      final err = strings.nameError;
      setState(() => _customError = err);
      unawaited(_speakPrompt(err));
      return;
    }

    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.length != 10 || !RegExp(r'^[6-9]\d{9}$').hasMatch(cleanPhone)) {
      final err = strings.phoneError;
      setState(() => _customError = err);
      unawaited(_speakPrompt(err));
      return;
    }

    bool success;
    if (_isRegisterMode) {
      success = await controller.register(
        name: name,
        phoneNumber: cleanPhone,
        craftType: activeCraft,
      );
    } else {
      success = await controller.login(
        phoneNumber: cleanPhone,
        existingName: name.isNotEmpty ? name : null,
      );
    }

    if (!mounted) return;

    if (success) {
      final userName = name.isNotEmpty
          ? name
          : strings.artisanFallback;
      final welcomeMsg = strings.welcomeUser(userName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Palette.affirm,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.radius),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  welcomeMsg,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final langState = ref.watch(languageProvider);
    final lang = langState.selectedLanguage;
    final strings = langState.strings;

    final craftOptions = strings.craftOptions;
    final activeCraft = _selectedCraft ?? craftOptions.first;

    final displayedError = _customError ?? authState.errorMessage;

    return Scaffold(
      backgroundColor: Palette.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: ShilpsetuBrandLogo(language: lang),
        actions: [
          // Language switcher pill
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Palette.primary.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.translate_rounded, size: 18),
            label: Text(
              lang.nameNative,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            onPressed: () => context.go('/language'),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            icon: const Icon(Icons.volume_up_rounded, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: Palette.goldAccentLight,
              foregroundColor: Palette.goldAccent,
            ),
            onPressed: () {
              unawaited(_speakPrompt(strings.authPromptSpeech(_isRegisterMode)));
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.gutter),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Zero-Literacy Prompt Banner
                ZeroLiteracyPromptCard(
                  promptText: strings.authPrompt(_isRegisterMode),
                  icon: _isRegisterMode
                      ? Icons.person_add_alt_1_rounded
                      : Icons.login_rounded,
                  onReplayAudio: () {
                    unawaited(
                      _speakPrompt(strings.authPromptSpeech(_isRegisterMode)),
                    );
                  },
                ),

                const SizedBox(height: Sizes.gapMedium),

                // Mode Selector Toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Palette.surfaceContainer,
                    borderRadius: BorderRadius.circular(Sizes.radius),
                    border: Border.all(color: Palette.surfaceContainerHigh),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isRegisterMode = true;
                              _customError = null;
                            });
                          },
                          borderRadius:
                              BorderRadius.circular(Sizes.radius - 4),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: _isRegisterMode
                                  ? Palette.primary
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(Sizes.radius - 4),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.how_to_reg_rounded,
                                  color: _isRegisterMode
                                      ? Colors.white
                                      : Palette.ink,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  strings.registerTab,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: _isRegisterMode
                                        ? Colors.white
                                        : Palette.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isRegisterMode = false;
                              _customError = null;
                            });
                          },
                          borderRadius:
                              BorderRadius.circular(Sizes.radius - 4),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: !_isRegisterMode
                                  ? Palette.primary
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(Sizes.radius - 4),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.login_rounded,
                                  color: !_isRegisterMode
                                      ? Colors.white
                                      : Palette.ink,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  strings.loginTab,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: !_isRegisterMode
                                        ? Colors.white
                                        : Palette.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Sizes.gapLarge),

                // Name Input Field
                if (_isRegisterMode) ...[
                  Text(
                    strings.fullNameLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Palette.ink,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.person_rounded,
                        color: Palette.primary,
                        size: 28,
                      ),
                      hintText: strings.fullNameHint,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Palette.muted,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.radius),
                        borderSide: const BorderSide(
                          color: Palette.surfaceContainerHigh,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.radius),
                        borderSide: const BorderSide(
                          color: Palette.surfaceContainerHigh,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.radius),
                        borderSide: const BorderSide(
                          color: Palette.primary,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.gapMedium),
                ],

                // Mobile Number Input Field
                Text(
                  strings.phoneLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Palette.ink,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: Palette.ink,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Palette.surfaceContainerHigh,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+91',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Palette.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: '9876543210',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      color: Palette.muted,
                      letterSpacing: 1,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Sizes.radius),
                      borderSide: const BorderSide(
                        color: Palette.surfaceContainerHigh,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Sizes.radius),
                      borderSide: const BorderSide(
                        color: Palette.surfaceContainerHigh,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Sizes.radius),
                      borderSide: const BorderSide(
                        color: Palette.primary,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: Sizes.gapMedium),

                // Craft Selection
                if (_isRegisterMode) ...[
                  Text(
                    strings.craftCategoryLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: craftOptions.map((craft) {
                      final isSelected = activeCraft == craft;
                      return InkWell(
                        onTap: () => setState(() => _selectedCraft = craft),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Palette.terracotta
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? Palette.terracotta
                                  : Palette.surfaceContainerHigh,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            craft,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : Palette.ink,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: Sizes.gapLarge),
                ] else
                  const SizedBox(height: Sizes.gapMedium),

                // Error Message Notice
                if (displayedError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Palette.reviseLight,
                      borderRadius: BorderRadius.circular(Sizes.radius),
                      border: Border.all(color: Palette.revise, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Palette.revise,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            displayedError,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Palette.revise,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.gapMedium),
                ],

                // Primary Action Button
                SpokenActionButton(
                  onPressed: authState.isLoading ? null : _submit,
                  icon: _isRegisterMode
                      ? Icons.check_circle_rounded
                      : Icons.arrow_forward_rounded,
                  label: authState.isLoading
                      ? '...'
                      : (_isRegisterMode
                          ? strings.joinShilpsetu
                          : strings.loginButton),
                  subtitle: strings.offlineSyncNotice,
                  backgroundColor: _isRegisterMode
                      ? Palette.affirm
                      : Palette.primary,
                  isLarge: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
