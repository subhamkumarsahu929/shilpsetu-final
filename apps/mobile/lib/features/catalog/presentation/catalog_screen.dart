import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/api/api_provider.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';
import 'package:shilpsetu/features/catalog/presentation/widgets/product_card_widget.dart';
import 'package:shilpsetu/features/home/presentation/widgets/app_info_menu.dart';

/// Product Catalog Screen.
///
/// Integrates:
/// - ShilpSetu AI Backend Catalog Feed API (`GET /api/v1/products/feed`)
/// - Product data model with dual Hindi/English titles & descriptions
/// - Reusable cached network image product cards
/// - Individual audio readback with soundwave animation
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  late final FlutterTts _tts;
  String? _activePlayingId;
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadCatalogFeed();
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
          if (mounted) setState(() => _activePlayingId = null);
        })
        ..setCancelHandler(() {
          if (mounted) setState(() => _activePlayingId = null);
        })
        ..setErrorHandler((_) {
          if (mounted) setState(() => _activePlayingId = null);
        });
    } catch (_) {}
  }

  Future<void> _loadCatalogFeed() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final apiService = ref.read(shilpSetuApiServiceProvider);
      final remoteFeed = await apiService.getCatalogFeed();
      if (mounted) {
        setState(() {
          _products = remoteFeed;
          _errorMessage = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _products = [];
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _speakText(String id, String text) async {
    if (_activePlayingId == id) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) setState(() => _activePlayingId = null);
      return;
    }

    setState(() => _activePlayingId = id);
    final lang = ref.read(languageProvider).selectedLanguage;
    try {
      await _tts.stop();
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> _speakProduct(Product product) async {
    final id = 'prod_${product.id}';
    if (_activePlayingId == id) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) setState(() => _activePlayingId = null);
      return;
    }

    setState(() => _activePlayingId = id);
    final lang = ref.read(languageProvider).selectedLanguage;
    final isHindi = lang == AppLanguage.hindi;

    final title = isHindi
        ? (product.titleHi ?? product.titleEn ?? 'शिल्प')
        : (product.titleEn ?? product.titleHi ?? 'Craft');
    final desc = isHindi
        ? (product.descriptionHi ?? product.descriptionEn ?? '')
        : (product.descriptionEn ?? product.descriptionHi ?? '');
    final price = product.priceSuggested != null
        ? '${product.priceSuggested!.toStringAsFixed(0)} ${isHindi ? 'रुपये' : 'rupees'}'
        : '';

    final text = isHindi
        ? '$title। $desc $price।'
        : '$title. $desc Price is $price.';

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

    return Scaffold(
      backgroundColor: Palette.surface,
      appBar: AppBar(
        title: ShilpsetuBrandLogo(language: lang),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton.filledTonal(
            icon: Icon(
              _activePlayingId == 'appbar_overview'
                  ? Icons.stop_rounded
                  : Icons.volume_up_rounded,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Palette.goldAccentLight,
              foregroundColor: Palette.goldAccent,
            ),
            tooltip: strings.homeOverviewTooltip,
            onPressed: () {
              unawaited(
                _speakText(
                  'appbar_overview',
                  strings.catalogOverviewSpeech(_products.length),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          const AppInfoIconButton(),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Palette.purpleContainerDark,
          onRefresh: _loadCatalogFeed,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(Sizes.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Signature Purple Hero Banner
                ShilpsetuPurpleCard(
                  tag: strings.myCraftShowroomTag,
                  title: strings.myCraftShowroomTitle,
                  subtitle: strings.myCraftShowroomSubtitle,
                  buttonText: strings.addNewCraftButton,
                  icon: Icons.inventory_2_rounded,
                  tagIcon: Icons.storefront_rounded,
                  onTap: () => context.push('/capture'),
                  isSpeaking: _activePlayingId == 'header_card',
                  onSpeak: () {
                    unawaited(
                      _speakText(
                        'header_card',
                        strings.catalogOverviewSpeech(_products.length),
                      ),
                    );
                  },
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
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Palette.purpleContainerLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_products.length} Items',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Palette.purpleContainerDark,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Sizes.gapMedium),

                // Loading State, Error State, Empty State, or Product Cards List
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Palette.purpleContainerDark,
                      ),
                    ),
                  )
                else if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Palette.revise.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Sizes.cardRadius),
                      border: Border.all(color: Palette.revise, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              color: Palette.revise,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Palette.revise,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.revise,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Sizes.radius),
                            ),
                          ),
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(
                            strings.retryButton,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          onPressed: _loadCatalogFeed,
                        ),
                      ],
                    ),
                  )
                else if (_products.isEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Sizes.cardRadius),
                      border: Border.all(color: Palette.surfaceContainerHigh),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: Palette.purpleContainerLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            size: 38,
                            color: Palette.purpleContainerDark,
                          ),
                        ),
                        const SizedBox(height: Sizes.gapMedium),
                        Text(
                          strings.emptyCatalogTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Palette.ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          strings.emptyCatalogSubtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Palette.muted,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _products.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: Sizes.gapMedium),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final isPlaying = _activePlayingId == 'prod_${product.id}';

                      return ProductCardWidget(
                        product: product,
                        language: lang,
                        isPlaying: isPlaying,
                        onPlayAudio: () => _speakProduct(product),
                        onTap: () => _speakProduct(product),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Palette.amberButton,
        foregroundColor: Palette.ink,
        elevation: 4,
        icon: const Icon(Icons.add_a_photo_rounded, size: 26),
        label: Text(
          strings.addNewCraftButton,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        onPressed: () {
          context.push('/capture');
        },
      ),
    );
  }
}
