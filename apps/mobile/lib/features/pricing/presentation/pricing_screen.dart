import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/api/api_provider.dart';
import 'package:shilpsetu/core/localization/app_strings.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/catalog/domain/craft_flow_provider.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';

/// Step 3 of Craft Flow: Fair Wage Pricing Model gives price for that object.
///
/// Features:
/// - Takes the object details and background-removed image from Steps 1 & 2
/// - Fetches live data from the Fair Wage Pricing Engine model (`POST /api/v1/pricing/suggest`)
/// - Displays real model pricing with no hardcoded fallback
/// - Displays and speaks exclusively in the user's selected language
/// - 3 price tiers: Floor (minimum fair wage), Suggested, Stretch
/// - Publishes finalized craft to marketplace catalog
class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({super.key});

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  late final FlutterTts _tts;
  late final TextEditingController _materialCostController;
  late final TextEditingController _profitController;

  int _selectedTierIndex = 1; // 0: Floor, 1: Suggested, 2: Stretch
  bool _isSpeaking = false;
  bool _isLoading = false;
  bool _isPublishing = false;
  String? _errorMessage;
  PricingSuggestionResult? _pricingResult;

  @override
  void initState() {
    super.initState();
    final craftFlow = ref.read(craftFlowProvider);
    _materialCostController = TextEditingController(
      text: craftFlow.rawMaterialCost.toStringAsFixed(0),
    );
    _profitController = TextEditingController(
      text: craftFlow.minProfit.toStringAsFixed(0),
    );
    _initTts();
    _fetchPricingFromModel();
  }

  void _adjustMaterial(double delta) {
    final current = double.tryParse(_materialCostController.text) ?? 450;
    final next = (current + delta).clamp(50, 100000).toDouble();
    setState(() {
      _materialCostController.text = next.toStringAsFixed(0);
    });
    ref.read(craftFlowProvider.notifier).setRawMaterialCost(next);
  }

  void _adjustProfit(double delta) {
    final current = double.tryParse(_profitController.text) ?? 300;
    final next = (current + delta).clamp(50, 100000).toDouble();
    setState(() {
      _profitController.text = next.toStringAsFixed(0);
    });
    ref.read(craftFlowProvider.notifier).setMinProfit(next);
  }

  void _setMaterial(double val) {
    setState(() {
      _materialCostController.text = val.toStringAsFixed(0);
    });
    ref.read(craftFlowProvider.notifier).setRawMaterialCost(val);
  }

  void _setProfit(double val) {
    setState(() {
      _profitController.text = val.toStringAsFixed(0);
    });
    ref.read(craftFlowProvider.notifier).setMinProfit(val);
  }

  Future<void> _fetchPricingFromModel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final rawCost = double.tryParse(_materialCostController.text) ?? 450.0;
    final profit = double.tryParse(_profitController.text) ?? 300.0;

    ref.read(craftFlowProvider.notifier).setRawMaterialCost(rawCost);
    ref.read(craftFlowProvider.notifier).setMinProfit(profit);

    try {
      final craftFlow = ref.read(craftFlowProvider);
      final craft = craftFlow.craftType ?? 'terracotta';
      final apiService = ref.read(shilpSetuApiServiceProvider);

      final result = await apiService.getPricingSuggestion(
        craftType: craft,
        rawMaterialCost: rawCost,
        minProfit: profit,
        artisanHours: 6,
        state: 'Odisha',
        title: craftFlow.titleEn ?? craftFlow.titleHi,
        category: craftFlow.craftType,
        imageUrl: craftFlow.activeImageUrl,
      );

      if (mounted) {
        setState(() {
          _pricingResult = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
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
          if (mounted) setState(() => _isSpeaking = false);
        })
        ..setCancelHandler(() {
          if (mounted) setState(() => _isSpeaking = false);
        })
        ..setErrorHandler((_) {
          if (mounted) setState(() => _isSpeaking = false);
        });
    } catch (_) {}
  }

  Future<void> _speakPricingRationale() async {
    if (_isSpeaking) {
      try {
        await _tts.stop();
      } catch (_) {}
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }

    setState(() => _isSpeaking = true);

    final langState = ref.read(languageProvider);
    final lang = langState.selectedLanguage;
    final strings = langState.strings;

    String speech;
    if (_pricingResult != null) {
      final floor = _pricingResult!.floorPrice.toStringAsFixed(0);
      final suggested = _pricingResult!.suggestedPrice.toStringAsFixed(0);
      speech = '${strings.step3PricingSpeech} ${strings.tierSuggestedTitle}: ₹$suggested. ${strings.tierFloorTitle}: ₹$floor.';
      if (_pricingResult!.artisanNote != null && _pricingResult!.artisanNote!.isNotEmpty) {
        speech += ' ${_pricingResult!.artisanNote}';
      }
    } else if (_errorMessage != null) {
      speech = _errorMessage!;
    } else {
      speech = strings.step3Prompt;
    }

    try {
      await _tts.stop();
      await _tts.setLanguage(lang.ttsLocale);
      await _tts.speak(speech);
    } catch (_) {}
  }

  Future<void> _publishListing() async {
    setState(() => _isPublishing = true);

    final craftFlow = ref.read(craftFlowProvider);
    final apiService = ref.read(shilpSetuApiServiceProvider);
    final langState = ref.read(languageProvider);
    final strings = langState.strings;

    final selectedPrice = _selectedTierIndex == 0
        ? _pricingResult?.floorPrice
        : (_selectedTierIndex == 2
            ? _pricingResult?.stretchPrice
            : _pricingResult?.suggestedPrice);

    try {
      await apiService.saveProduct(
        artisanId: 'artisan_app',
        titleEn: craftFlow.titleEn ?? 'Handcrafted Art',
        titleHi: craftFlow.titleHi ?? 'हस्तशिल्प उत्पाद',
        descriptionEn: craftFlow.descriptionEn ?? '',
        descriptionHi: craftFlow.descriptionHi ?? '',
        enhancedImageUrl: craftFlow.cloudEnhancedImageUrl ??
            craftFlow.localProcessedImagePath ??
            '',
        category: craftFlow.craftType ?? 'Handicraft',
        priceSuggested: selectedPrice,
        features: craftFlow.features,
        tags: craftFlow.tags,
      );
    } catch (e) {
      debugPrint('Save product notification: $e');
    }

    ref.read(craftFlowProvider.notifier).reset();

    if (mounted) {
      setState(() => _isPublishing = false);
      final msg = strings.listingPublishedSuccess;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Palette.affirm,
          behavior: SnackBarBehavior.floating,
          content: Text(
            msg,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
      context.go('/catalog');
    }
  }

  @override
  void dispose() {
    _materialCostController.dispose();
    _profitController.dispose();
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
        ? (craftFlow.titleEn ?? craftFlow.titleHi ?? 'Craft Object')
        : (craftFlow.titleHi ?? craftFlow.titleEn ?? lang.brandShilp);

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
              context.go('/cataloger');
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
            onPressed: _speakPricingRationale,
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
              // ── Object Card from Step 1 & Step 2 ───────────────────────────
              if (craftFlow.hasProcessedImage) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Sizes.cardRadius),
                    border: Border.all(
                      color: Palette.purpleContainer.withValues(alpha: 0.25),
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
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Palette.surface,
                          borderRadius: BorderRadius.circular(Sizes.radius),
                          border: Border.all(color: Palette.surfaceContainerHigh),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: craftFlow.localProcessedImagePath != null
                            ? Image.file(
                                File(craftFlow.localProcessedImagePath!),
                                fit: BoxFit.contain,
                              )
                            : const Icon(Icons.palette_rounded),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Palette.ink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            TripleChannelStatusBadge(
                              label: strings.step3PricingBadge,
                              icon: Icons.currency_rupee_rounded,
                              color: Palette.purpleContainerDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Sizes.gapMedium),
              ],

              // Signature Purple Prompt Banner
              ZeroLiteracyPromptCard(
                promptText: strings.step3Prompt,
                icon: Icons.currency_rupee_rounded,
                onReplayAudio: _speakPricingRationale,
              ),

              const SizedBox(height: Sizes.gapMedium),

              // ── 1. Interactive Raw Material Cost & Desired Profit Input ───────
              _buildCostAndProfitInputCard(strings),

              const SizedBox(height: Sizes.gapMedium),

              // Audio Rationale Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Palette.purpleContainerLight,
                  borderRadius: BorderRadius.circular(Sizes.radius),
                  border: Border.all(
                    color: Palette.purpleContainer.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insights_rounded,
                      color: Palette.purpleContainerDark,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _pricingResult != null
                            ? (_pricingResult!.artisanNote ?? strings.step3PricingSpeech)
                            : strings.step3Prompt,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Palette.ink,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: Palette.purpleContainerDark,
                        size: 26,
                      ),
                      onPressed: _speakPricingRationale,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Sizes.gapMedium),

              // ── Loading State ──────────────────────────────────────────────
              if (_isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
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
                      const SizedBox(height: Sizes.gapMedium),
                      Text(
                        strings.step3Prompt,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Palette.ink,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              // ── Error State (No Hardcoded Fallback!) ────────────────────────
              else if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(20),
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
                            Icons.error_outline_rounded,
                            color: Palette.revise,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Palette.revise,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.revise,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.radius),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(
                          strings.emptyCatalogButton,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onPressed: _fetchPricingFromModel,
                      ),
                    ],
                  ),
                )
              // ── Dynamic Model Pricing Tiers ────────────────────────────────
              else if (_pricingResult != null) ...[
                // Model Cost & Profit Analysis Breakdown Card
                _buildProfitAnalysisCard(strings, _pricingResult!),

                const SizedBox(height: Sizes.gapMedium),

                // 1. Floor Tier (Fair Wage Minimum)
                _buildPriceTierCard(
                  index: 0,
                  title: strings.tierFloorTitle,
                  price: '₹ ${_pricingResult!.floorPrice.toStringAsFixed(0)}',
                  color: Palette.terracotta,
                  icon: Icons.shield_rounded,
                  badge: strings.tierFloorBadge,
                  subtitle: _pricingResult!.materialCost != null
                      ? '${strings.materialCostLabel}: ₹${_pricingResult!.materialCost!.toStringAsFixed(0)}'
                      : strings.tierFloorBadge,
                  description: strings.tierFloorDesc,
                ),

                const SizedBox(height: Sizes.gapMedium),

                // 2. Suggested Tier (Market Standard)
                _buildPriceTierCard(
                  index: 1,
                  title: strings.tierSuggestedTitle,
                  price: '₹ ${_pricingResult!.suggestedPrice.toStringAsFixed(0)}',
                  color: Palette.purpleContainerDark,
                  icon: Icons.star_rounded,
                  badge: strings.tierSuggestedBadge,
                  subtitle: strings.tierSuggestedBadge,
                  description: _pricingResult!.pricingStrategy ?? strings.tierSuggestedDesc,
                ),

                const SizedBox(height: Sizes.gapMedium),

                // 3. Stretch Tier (Premium / Boutique)
                _buildPriceTierCard(
                  index: 2,
                  title: strings.tierStretchTitle,
                  price: '₹ ${_pricingResult!.stretchPrice.toStringAsFixed(0)}',
                  color: Palette.affirm,
                  icon: Icons.workspace_premium_rounded,
                  badge: strings.tierStretchBadge,
                  subtitle: strings.tierStretchBadge,
                  description: strings.tierStretchDesc,
                ),

                const SizedBox(height: Sizes.gapLarge),

                // Large Action Button with Amber styling
                SpokenActionButton(
                  onPressed: _isPublishing ? null : _publishListing,
                  icon: _isPublishing
                      ? Icons.hourglass_top_rounded
                      : Icons.check_circle_rounded,
                  label: strings.publishButton(_isPublishing),
                  subtitle: strings.publishSubtitle,
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

  Widget _buildPriceTierCard({
    required int index,
    required String title,
    required String price,
    required Color color,
    required IconData icon,
    required String badge,
    required String subtitle,
    required String description,
  }) {
    final isSelected = _selectedTierIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTierIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(Sizes.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(Sizes.cardRadius),
            border: Border.all(
              color: isSelected ? color : Palette.surfaceContainerHigh,
              width: isSelected ? 3 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? color.withValues(alpha: 0.18)
                    : Palette.ink.withValues(alpha: 0.05),
                blurRadius: isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? color : Palette.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Palette.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Palette.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Input Card for Raw Material Cost & Desired Profit ─────────────────────────
  Widget _buildCostAndProfitInputCard(AppStrings strings) {
    final currentMaterial =
        double.tryParse(_materialCostController.text) ?? 450;
    final currentProfit = double.tryParse(_profitController.text) ?? 300;
    final costFloor = currentMaterial + currentProfit;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.cardRadius),
        border: Border.all(
          color: Palette.purpleContainer.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Palette.purpleContainer.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Palette.purpleContainerLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Palette.purpleContainerDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.materialCostTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Palette.ink,
                      ),
                    ),
                    Text(
                      strings.materialCostSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
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
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Section 1: Raw Material Cost Input
          _buildInputSection(
            title: strings.materialCostLabel,
            subtitle: strings.materialCostSubtitle,
            icon: Icons.inventory_2_rounded,
            color: Palette.terracotta,
            controller: _materialCostController,
            onDecrement: () => _adjustMaterial(-50),
            onIncrement: () => _adjustMaterial(50),
            presets: const [200, 400, 600, 1000],
            onSelectPreset: (val) => _setMaterial(val.toDouble()),
            currentValue: currentMaterial,
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Section 2: Desired Profit Input
          _buildInputSection(
            title: strings.targetProfitLabel,
            subtitle: strings.desiredProfitSubtitle,
            icon: Icons.savings_rounded,
            color: Palette.affirm,
            controller: _profitController,
            onDecrement: () => _adjustProfit(-50),
            onIncrement: () => _adjustProfit(50),
            presets: const [150, 300, 500, 800],
            onSelectPreset: (val) => _setProfit(val.toDouble()),
            currentValue: currentProfit,
          ),

          const SizedBox(height: 18),

          // Guaranteed Cost Floor Guarantee Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Palette.terracotta.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Palette.terracotta.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: Palette.terracotta,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${strings.tierFloorTitle}: ₹${costFloor.toStringAsFixed(0)} (${strings.materialCostLabel}: ₹${currentMaterial.toStringAsFixed(0)} + ${strings.targetProfitLabel}: ₹${currentProfit.toStringAsFixed(0)})',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Palette.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Prominent Model Calculation Button (Height >= 64dp per zero-literacy bet 01)
          SizedBox(
            height: 64,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.purpleContainerDark,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.radius),
                ),
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 28),
              label: Text(
                _isLoading
                    ? strings.choiceAPhotoOnlySpeech
                    : strings.tierSuggestedTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: _isLoading ? null : _fetchPricingFromModel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required TextEditingController controller,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required List<int> presets,
    required ValueChanged<int> onSelectPreset,
    required double currentValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Palette.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Decrement Button (>= 64dp touch target)
            SizedBox(
              width: 64,
              height: 64,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(color: color, width: 2),
                  padding: EdgeInsets.zero,
                  backgroundColor: color.withValues(alpha: 0.05),
                ),
                onPressed: onDecrement,
                child: Icon(Icons.remove_rounded, color: color, size: 30),
              ),
            ),
            const SizedBox(width: 12),
            // Large Editable Numeric Field
            Expanded(
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Palette.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Palette.surfaceContainerHigh,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Palette.ink,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Increment Button (>= 64dp touch target)
            SizedBox(
              width: 64,
              height: 64,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(color: color, width: 2),
                  padding: EdgeInsets.zero,
                  backgroundColor: color.withValues(alpha: 0.05),
                ),
                onPressed: onIncrement,
                child: Icon(Icons.add_rounded, color: color, size: 30),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Quick Preset Pills
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: presets.map((val) {
            final isSelected = (currentValue.toInt() == val);
            return ChoiceChip(
              label: Text(
                '₹$val',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Palette.ink,
                ),
              ),
              selected: isSelected,
              selectedColor: color,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? color : Palette.surfaceContainerHigh,
              ),
              onSelected: (_) => onSelectPreset(val),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Cost & Profit Analysis Breakdown Card from Model ──────────────────────────
  Widget _buildProfitAnalysisCard(
    AppStrings strings,
    PricingSuggestionResult result,
  ) {
    final material = result.materialCost ??
        double.tryParse(_materialCostController.text) ??
        450.0;
    final targetProfit = result.minProfitDesired ??
        double.tryParse(_profitController.text) ??
        300.0;
    final projectedProfit =
        result.projectedProfit ?? (result.suggestedPrice - material);
    final surplus =
        result.surplusAboveMinProfit ?? (projectedProfit - targetProfit);
    final marginPct = result.profitMarginPct;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.cardRadius),
        border: Border.all(
          color: Palette.affirm.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Palette.affirm.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Palette.affirm.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Palette.affirm,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.costProfitAnalysisTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Palette.ink,
                      ),
                    ),
                    Text(
                      strings.step3PricingSpeech,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 4-item Metric Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: strings.materialCostLabel,
                  value: '₹${material.toStringAsFixed(0)}',
                  color: Palette.terracotta,
                  icon: Icons.inventory_2_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: strings.targetProfitLabel,
                  value: '₹${targetProfit.toStringAsFixed(0)}',
                  color: Palette.goldAccent,
                  icon: Icons.flag_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: strings.tierSuggestedTitle,
                  value: '₹${projectedProfit.toStringAsFixed(0)}',
                  color: Palette.affirm,
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: strings.tierStretchTitle,
                  value: surplus >= 0
                      ? '+₹${surplus.toStringAsFixed(0)}'
                      : '₹0',
                  color: Palette.purpleContainerDark,
                  icon: Icons.add_circle_outline_rounded,
                ),
              ),
            ],
          ),
          if (marginPct != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Palette.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Palette.surfaceContainerHigh),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.percent_rounded,
                    size: 16,
                    color: Palette.affirm,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${strings.desiredProfitTitle}: ${marginPct.toStringAsFixed(1)}%',
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
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
