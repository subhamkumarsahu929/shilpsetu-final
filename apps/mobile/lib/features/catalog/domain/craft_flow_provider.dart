import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shilpsetu/core/api/api_provider.dart';
import 'package:shilpsetu/core/api/shilpsetu_api_service.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';

/// State of the active 3-step craft listing flow:
/// Step 1: Photo capture & Background removal
/// Step 2: Description (Choice A: Only Photo, or Choice B: Photo + Voice)
/// Step 3: Fair Wage Pricing Model
@immutable
class CraftFlowState {
  const CraftFlowState({
    this.originalImagePath,
    this.localProcessedImagePath,
    this.cloudEnhancedImageUrl,
    this.isEnhancing = false,
    this.enhanceError,
    this.isGeneratingDescription = false,
    this.descriptionError,
    this.titleEn,
    this.titleHi,
    this.descriptionEn,
    this.descriptionHi,
    this.features = const [],
    this.tags = const [],
    this.craftType,
    this.voicePath,
    this.usedVoice = false,
    this.isCalculatingPricing = false,
    this.pricingError,
    this.pricingResult,
    this.selectedPriceTier = 1, // 0: Floor, 1: Suggested, 2: Stretch
    this.rawMaterialCost = 450.0,
    this.minProfit = 300.0,
  });

  // Step 1: Image & Background Removal
  final String? originalImagePath;
  final String? localProcessedImagePath;
  final String? cloudEnhancedImageUrl;
  final bool isEnhancing;
  final String? enhanceError;

  // Step 2: Description & Attributes
  final bool isGeneratingDescription;
  final String? descriptionError;
  final String? titleEn;
  final String? titleHi;
  final String? descriptionEn;
  final String? descriptionHi;
  final List<String> features;
  final List<String> tags;
  final String? craftType;
  final String? voicePath;
  final bool usedVoice;

  // Step 3: Pricing
  final bool isCalculatingPricing;
  final String? pricingError;
  final PricingSuggestionResult? pricingResult;
  final int selectedPriceTier;
  final double rawMaterialCost;
  final double minProfit;

  String? get activeImageUrl => cloudEnhancedImageUrl ?? localProcessedImagePath;

  bool get hasProcessedImage =>
      (localProcessedImagePath != null && localProcessedImagePath!.isNotEmpty) ||
      (cloudEnhancedImageUrl != null && cloudEnhancedImageUrl!.isNotEmpty);

  bool get hasDescription =>
      (titleEn != null && titleEn!.isNotEmpty) ||
      (titleHi != null && titleHi!.isNotEmpty) ||
      (descriptionEn != null && descriptionEn!.isNotEmpty) ||
      (descriptionHi != null && descriptionHi!.isNotEmpty) ||
      features.isNotEmpty;

  CraftFlowState copyWith({
    String? originalImagePath,
    String? localProcessedImagePath,
    String? cloudEnhancedImageUrl,
    bool? isEnhancing,
    String? enhanceError,
    bool clearEnhanceError = false,
    bool? isGeneratingDescription,
    String? descriptionError,
    bool clearDescriptionError = false,
    String? titleEn,
    String? titleHi,
    String? descriptionEn,
    String? descriptionHi,
    List<String>? features,
    List<String>? tags,
    String? craftType,
    String? voicePath,
    bool? usedVoice,
    bool? isCalculatingPricing,
    String? pricingError,
    bool clearPricingError = false,
    PricingSuggestionResult? pricingResult,
    int? selectedPriceTier,
    double? rawMaterialCost,
    double? minProfit,
  }) {
    return CraftFlowState(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      localProcessedImagePath:
          localProcessedImagePath ?? this.localProcessedImagePath,
      cloudEnhancedImageUrl:
          cloudEnhancedImageUrl ?? this.cloudEnhancedImageUrl,
      isEnhancing: isEnhancing ?? this.isEnhancing,
      enhanceError:
          clearEnhanceError ? null : (enhanceError ?? this.enhanceError),
      isGeneratingDescription:
          isGeneratingDescription ?? this.isGeneratingDescription,
      descriptionError: clearDescriptionError
          ? null
          : (descriptionError ?? this.descriptionError),
      titleEn: titleEn ?? this.titleEn,
      titleHi: titleHi ?? this.titleHi,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionHi: descriptionHi ?? this.descriptionHi,
      features: features ?? this.features,
      tags: tags ?? this.tags,
      craftType: craftType ?? this.craftType,
      voicePath: voicePath ?? this.voicePath,
      usedVoice: usedVoice ?? this.usedVoice,
      isCalculatingPricing:
          isCalculatingPricing ?? this.isCalculatingPricing,
      pricingError:
          clearPricingError ? null : (pricingError ?? this.pricingError),
      pricingResult: pricingResult ?? this.pricingResult,
      selectedPriceTier: selectedPriceTier ?? this.selectedPriceTier,
      rawMaterialCost: rawMaterialCost ?? this.rawMaterialCost,
      minProfit: minProfit ?? this.minProfit,
    );
  }
}

class CraftFlowNotifier extends StateNotifier<CraftFlowState> {
  CraftFlowNotifier({required this.apiService})
      : super(const CraftFlowState());

  final ShilpSetuApiService apiService;

  /// Step 1: Register background-removed photo from on-device segmenter
  /// and trigger cloud studio enhancement.
  Future<void> setProcessedImage({
    required String localPath,
    String? rawImagePath,
  }) async {
    state = state.copyWith(
      localProcessedImagePath: localPath,
      originalImagePath: rawImagePath ?? localPath,
      isEnhancing: true,
      clearEnhanceError: true,
    );

    try {
      final file = File(localPath);
      if (file.existsSync()) {
        final result = await apiService.enhanceImage(file);
        if (result.enhancedUrl.isNotEmpty) {
          final fullUrl = ShilpSetuApiService.getFullImageUrl(
            result.enhancedUrl,
            base: apiService.baseUrl,
          );
          state = state.copyWith(
            cloudEnhancedImageUrl: fullUrl,
            isEnhancing: false,
          );
          return;
        }
      }
      state = state.copyWith(isEnhancing: false);
    } catch (e) {
      debugPrint('Cloud image enhancement non-blocking error: $e');
      // Keep on-device segmented image as authoritative
      state = state.copyWith(
        isEnhancing: false,
        enhanceError: e.toString(),
      );
    }
  }

  /// Step 2, Choice A: Model generates description from ONLY photo
  Future<void> generateDescriptionFromPhotoOnly({
    required String languageCode,
    String artisanId = 'artisan_app',
  }) async {
    final imagePath = state.localProcessedImagePath ?? state.originalImagePath;
    if (imagePath == null || !File(imagePath).existsSync()) {
      state = state.copyWith(
        descriptionError: 'No craft photo found. Please capture a photo first.',
      );
      return;
    }

    state = state.copyWith(
      isGeneratingDescription: true,
      clearDescriptionError: true,
      usedVoice: false,
    );

    try {
      final response = await apiService.describeFromPhotoOnly(
        imageFile: File(imagePath),
        artisanId: artisanId,
        languageHint: languageCode,
      );

      // Extract craft type heuristics from features or tags
      String detectedCraft = 'terracotta';
      if (response.tags.isNotEmpty) {
        detectedCraft = response.tags.first;
      }

      state = state.copyWith(
        isGeneratingDescription: false,
        titleEn: response.titleEn,
        titleHi: response.titleHi,
        descriptionEn: response.descriptionEn,
        descriptionHi: response.descriptionHi,
        features: response.features,
        tags: response.tags,
        craftType: detectedCraft,
        usedVoice: false,
      );
    } catch (e) {
      state = state.copyWith(
        isGeneratingDescription: false,
        descriptionError: e.toString(),
      );
    }
  }

  /// Step 2, Choice B: Model generates description from Photo WITH Voice
  Future<void> generateDescriptionWithVoice({
    required File audioFile,
    required String languageCode,
    String artisanId = 'artisan_app',
  }) async {
    state = state.copyWith(
      isGeneratingDescription: true,
      clearDescriptionError: true,
      voicePath: audioFile.path,
      usedVoice: true,
    );

    try {
      final imagePath = state.localProcessedImagePath ?? state.originalImagePath;
      if (imagePath != null && File(imagePath).existsSync()) {
        // Multi-modal vision + speech model
        final response = await apiService.createProductWithAI(
          imageFile: File(imagePath),
          audioFile: audioFile,
          artisanId: artisanId,
          languageHint: languageCode,
          autoSave: false,
        );

        String detectedCraft = 'terracotta';
        if (response.tags.isNotEmpty) {
          detectedCraft = response.tags.first;
        }

        state = state.copyWith(
          isGeneratingDescription: false,
          titleEn: response.titleEn,
          titleHi: response.titleHi,
          descriptionEn: response.descriptionEn,
          descriptionHi: response.descriptionHi,
          features: response.features,
          tags: response.tags,
          craftType: detectedCraft,
          usedVoice: true,
        );
      } else {
        // Voice-only transcription and attribute extraction
        final response = await apiService.processVoiceNote(
          audioFile,
          languageHint: languageCode,
        );

        state = state.copyWith(
          isGeneratingDescription: false,
          titleEn: response.titleEn,
          titleHi: response.titleHi,
          descriptionEn: response.descriptionEn,
          descriptionHi: response.descriptionHi,
          features: response.features,
          tags: response.seoTags,
          usedVoice: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isGeneratingDescription: false,
        descriptionError: e.toString(),
      );
    }
  }

  void setRawMaterialCost(double cost) {
    state = state.copyWith(rawMaterialCost: cost);
  }

  void setMinProfit(double profit) {
    state = state.copyWith(minProfit: profit);
  }

  /// Step 3: Query Fair Wage Pricing Engine model
  /// Passes user-specified raw material cost and desired profit to calculate fair market price.
  Future<void> calculatePricing({
    String? craftType,
    double? rawMaterialCost,
    double? minProfit,
    double artisanHours = 6,
    String stateName = 'Odisha',
  }) async {
    final material = rawMaterialCost ?? state.rawMaterialCost;
    final profit = minProfit ?? state.minProfit;

    state = state.copyWith(
      isCalculatingPricing: true,
      rawMaterialCost: material,
      minProfit: profit,
      clearPricingError: true,
    );

    try {
      final craft = craftType ?? state.craftType ?? 'terracotta';
      final result = await apiService.getPricingSuggestion(
        craftType: craft,
        rawMaterialCost: material,
        minProfit: profit,
        artisanHours: artisanHours,
        state: stateName,
        title: state.titleEn ?? state.titleHi,
        category: state.craftType,
        imageUrl: state.activeImageUrl,
      );

      state = state.copyWith(
        isCalculatingPricing: false,
        pricingResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        isCalculatingPricing: false,
        pricingError: e.toString(),
      );
    }
  }

  void setSelectedPriceTier(int index) {
    state = state.copyWith(selectedPriceTier: index);
  }

  void reset() {
    state = const CraftFlowState();
  }
}

final craftFlowProvider =
    StateNotifierProvider<CraftFlowNotifier, CraftFlowState>((ref) {
  final apiService = ref.watch(shilpSetuApiServiceProvider);
  return CraftFlowNotifier(apiService: apiService);
});
