import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shilpsetu/core/localization/app_strings.dart';

/// Supported language configuration for Shilpsetu.
enum AppLanguage {
  hindi(
    code: 'hi',
    nameEnglish: 'Hindi',
    nameNative: 'हिन्दी',
    scriptGlyph: 'अ',
    ttsLocale: 'hi-IN',
    greeting: 'नमस्ते! अपनी भाषा चुनें।',
  ),
  english(
    code: 'en',
    nameEnglish: 'English',
    nameNative: 'English',
    scriptGlyph: 'A',
    ttsLocale: 'en-IN',
    greeting: 'Welcome! Please select your language.',
  ),
  bengali(
    code: 'bn',
    nameEnglish: 'Bengali',
    nameNative: 'বাংলা',
    scriptGlyph: 'অ',
    ttsLocale: 'bn-IN',
    greeting: 'স্বাগতম! আপনার ভাষা বেছে নিন।',
  ),
  telugu(
    code: 'te',
    nameEnglish: 'Telugu',
    nameNative: 'తెలుగు',
    scriptGlyph: 'అ',
    ttsLocale: 'te-IN',
    greeting: 'స్వాగతం! మీ భాషను ఎంచుకోండి.',
  ),
  tamil(
    code: 'ta',
    nameEnglish: 'Tamil',
    nameNative: 'தமிழ்',
    scriptGlyph: 'அ',
    ttsLocale: 'ta-IN',
    greeting: 'வணக்கம்! உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்.',
  ),
  odia(
    code: 'or',
    nameEnglish: 'Odia',
    nameNative: 'ଓଡ଼ିଆ',
    scriptGlyph: 'ଅ',
    ttsLocale: 'or-IN',
    greeting: 'ସ୍ୱାଗତ! ଆପଣଙ୍କ ଭାଷା ବାଛନ୍ତୁ।',
  ),
  gujarati(
    code: 'gu',
    nameEnglish: 'Gujarati',
    nameNative: 'ગુજરાતી',
    scriptGlyph: 'અ',
    ttsLocale: 'gu-IN',
    greeting: 'સ્વાગત છે! તમારી ભાષા પસંદ કરો.',
  ),
  marathi(
    code: 'mr',
    nameEnglish: 'Marathi',
    nameNative: 'मराठी',
    scriptGlyph: 'म',
    ttsLocale: 'mr-IN',
    greeting: 'स्वागत आहे! तुमची भाषा निवडा.',
  );

  const AppLanguage({
    required this.code,
    required this.nameEnglish,
    required this.nameNative,
    required this.scriptGlyph,
    required this.ttsLocale,
    required this.greeting,
  });

  final String code;
  final String nameEnglish;
  final String nameNative;
  final String scriptGlyph;
  final String ttsLocale;
  final String greeting;

  Locale get locale => Locale(code, 'IN');

  String get brandShilp => switch (this) {
        AppLanguage.english => 'shilp',
        AppLanguage.hindi || AppLanguage.marathi => 'शिल्प',
        AppLanguage.bengali => 'শিল্প',
        AppLanguage.telugu => 'శిల్ప',
        AppLanguage.tamil => 'சில்ப',
        AppLanguage.odia => 'ଶିଳ୍ପ',
        AppLanguage.gujarati => 'શિલ્પ',
      };

  String get brandSetu => switch (this) {
        AppLanguage.english => 'setu',
        AppLanguage.hindi || AppLanguage.marathi => 'सेतु',
        AppLanguage.bengali => 'সেতু',
        AppLanguage.telugu => 'సేతు',
        AppLanguage.tamil => 'சேது',
        AppLanguage.odia => 'ସେତୁ',
        AppLanguage.gujarati => 'સેતુ',
      };

  AppStrings get strings => AppStrings.of(this);
}

class LanguageState {
  const LanguageState({
    required this.selectedLanguage,
    required this.hasSelectedLanguage,
  });

  factory LanguageState.initial() => const LanguageState(
        selectedLanguage: AppLanguage.hindi,
        hasSelectedLanguage: false,
      );

  final AppLanguage selectedLanguage;
  final bool hasSelectedLanguage;

  AppStrings get strings => selectedLanguage.strings;

  LanguageState copyWith({
    AppLanguage? selectedLanguage,
    bool? hasSelectedLanguage,
  }) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      hasSelectedLanguage: hasSelectedLanguage ?? this.hasSelectedLanguage,
    );
  }
}

class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier() : super(LanguageState.initial());

  void setLanguage(AppLanguage language) {
    state = LanguageState(
      selectedLanguage: language,
      hasSelectedLanguage: true,
    );
  }

  bool get isEnglish => state.selectedLanguage == AppLanguage.english;

  /// Returns the localised string for the currently selected language.
  ///
  /// Always provide [hi] (Hindi) and [en] (English). All other language
  /// parameters are optional — when omitted the call falls back to [hi] so
  /// that existing call-sites continue to work without changes.
  String text({
    required String hi,
    required String en,
    String? bn,
    String? te,
    String? ta,
    String? or_,  // 'or' is a reserved Dart keyword, so suffix with _
    String? gu,
    String? mr,
    String? other,
  }) {
    switch (state.selectedLanguage) {
      case AppLanguage.english:
        return en;
      case AppLanguage.hindi:
        return hi;
      case AppLanguage.bengali:
        return bn ?? hi;
      case AppLanguage.telugu:
        return te ?? hi;
      case AppLanguage.tamil:
        return ta ?? hi;
      case AppLanguage.odia:
        return or_ ?? hi;
      case AppLanguage.gujarati:
        return gu ?? hi;
      case AppLanguage.marathi:
        return mr ?? hi;
    }
  }
}

final languageProvider =
    StateNotifierProvider<LanguageNotifier, LanguageState>((ref) {
  return LanguageNotifier();
});
