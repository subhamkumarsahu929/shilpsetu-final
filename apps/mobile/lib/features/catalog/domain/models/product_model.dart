import 'package:flutter/foundation.dart';

/// Represents a finalized marketplace product stored in ShilpSetu.
@immutable
class Product {
  const Product({
    required this.id,
    required this.artisanId,
    this.titleEn,
    this.titleHi,
    this.descriptionEn,
    this.descriptionHi,
    this.category,
    this.enhancedImageUrl,
    this.priceSuggested,
    this.features = const [],
    this.tags = const [],
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      artisanId: json['artisan_id']?.toString() ?? '',
      titleEn: json['title_en'] as String?,
      titleHi: json['title_hi'] as String?,
      descriptionEn: json['description_en'] as String?,
      descriptionHi: json['description_hi'] as String?,
      category: json['category'] as String?,
      enhancedImageUrl: json['enhanced_image_url'] as String?,
      priceSuggested: (json['price_suggested'] as num?)?.toDouble(),
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  final int id;
  final String artisanId;
  final String? titleEn;
  final String? titleHi;
  final String? descriptionEn;
  final String? descriptionHi;
  final String? category;
  final String? enhancedImageUrl;
  final double? priceSuggested;
  final List<String> features;
  final List<String> tags;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artisan_id': artisanId,
      if (titleEn != null) 'title_en': titleEn,
      if (titleHi != null) 'title_hi': titleHi,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (descriptionHi != null) 'description_hi': descriptionHi,
      if (category != null) 'category': category,
      if (enhancedImageUrl != null) 'enhanced_image_url': enhancedImageUrl,
      if (priceSuggested != null) 'price_suggested': priceSuggested,
      'features': features,
      'tags': tags,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  Product copyWith({
    int? id,
    String? artisanId,
    String? titleEn,
    String? titleHi,
    String? descriptionEn,
    String? descriptionHi,
    String? category,
    String? enhancedImageUrl,
    double? priceSuggested,
    List<String>? features,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      artisanId: artisanId ?? this.artisanId,
      titleEn: titleEn ?? this.titleEn,
      titleHi: titleHi ?? this.titleHi,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionHi: descriptionHi ?? this.descriptionHi,
      category: category ?? this.category,
      enhancedImageUrl: enhancedImageUrl ?? this.enhancedImageUrl,
      priceSuggested: priceSuggested ?? this.priceSuggested,
      features: features ?? this.features,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          artisanId == other.artisanId;

  @override
  int get hashCode => id.hashCode ^ artisanId.hashCode;
}

/// Response from the All-in-One Multi-Modal AI endpoint (`POST /api/v1/products/create-ai`).
@immutable
class UnifiedAIResponse {
  const UnifiedAIResponse({
    required this.artisanId,
    required this.titleEn,
    required this.titleHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.features,
    required this.tags,
    required this.enhancedImageUrl,
    required this.qualityScore,
    required this.detectedLanguage,
    required this.rawTranscript,
    required this.processingTimeMs,
    required this.isSaved,
    this.productId,
  });

  factory UnifiedAIResponse.fromJson(Map<String, dynamic> json) {
    return UnifiedAIResponse(
      productId: json['product_id'] as int?,
      artisanId: json['artisan_id']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
      titleHi: json['title_hi']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      descriptionHi: json['description_hi']?.toString() ?? '',
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      enhancedImageUrl: json['enhanced_image_url']?.toString() ?? '',
      qualityScore: (json['quality_score'] as num?)?.toDouble() ?? 0.0,
      detectedLanguage: json['detected_language']?.toString() ?? 'unknown',
      rawTranscript: json['raw_transcript']?.toString() ?? '',
      processingTimeMs: (json['processing_time_ms'] as num?)?.toInt() ?? 0,
      isSaved: json['is_saved'] as bool? ?? false,
    );
  }

  final int? productId;
  final String artisanId;
  final String titleEn;
  final String titleHi;
  final String descriptionEn;
  final String descriptionHi;
  final List<String> features;
  final List<String> tags;
  final String enhancedImageUrl;
  final double qualityScore;
  final String detectedLanguage;
  final String rawTranscript;
  final int processingTimeMs;
  final bool isSaved;

  Map<String, dynamic> toJson() {
    return {
      if (productId != null) 'product_id': productId,
      'artisan_id': artisanId,
      'title_en': titleEn,
      'title_hi': titleHi,
      'description_en': descriptionEn,
      'description_hi': descriptionHi,
      'features': features,
      'tags': tags,
      'enhanced_image_url': enhancedImageUrl,
      'quality_score': qualityScore,
      'detected_language': detectedLanguage,
      'raw_transcript': rawTranscript,
      'processing_time_ms': processingTimeMs,
      'is_saved': isSaved,
    };
  }
}

/// Result from AI Image Studio Enhancement (`POST /api/v1/image/enhance`).
@immutable
class EnhancedImageResult {
  const EnhancedImageResult({
    required this.enhancedUrl,
    required this.qualityScore,
    required this.processingTimeMs,
    this.originalSizePx = const [],
    this.enhancedSizePx = const [],
  });

  factory EnhancedImageResult.fromJson(Map<String, dynamic> json) {
    return EnhancedImageResult(
      enhancedUrl: json['enhanced_url']?.toString() ?? '',
      qualityScore: (json['quality_score'] as num?)?.toDouble() ?? 0.0,
      processingTimeMs: (json['processing_time_ms'] as num?)?.toInt() ?? 0,
      originalSizePx: (json['original_size_px'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      enhancedSizePx: (json['enhanced_size_px'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );
  }

  final String enhancedUrl;
  final double qualityScore;
  final int processingTimeMs;
  final List<int> originalSizePx;
  final List<int> enhancedSizePx;

  Map<String, dynamic> toJson() {
    return {
      'enhanced_url': enhancedUrl,
      'quality_score': qualityScore,
      'processing_time_ms': processingTimeMs,
      'original_size_px': originalSizePx,
      'enhanced_size_px': enhancedSizePx,
    };
  }
}

/// Response from AI Voice Cataloger (`POST /api/v1/catalog/voice`).
@immutable
class VoiceCatalogResponse {
  const VoiceCatalogResponse({
    required this.detectedLanguage,
    required this.rawTranscript,
    required this.titleEn,
    required this.titleHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.features,
    required this.seoTags,
    required this.processingTimeMs,
  });

  factory VoiceCatalogResponse.fromJson(Map<String, dynamic> json) {
    return VoiceCatalogResponse(
      detectedLanguage: json['detected_language']?.toString() ?? 'unknown',
      rawTranscript: json['raw_transcript']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
      titleHi: json['title_hi']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      descriptionHi: json['description_hi']?.toString() ?? '',
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      seoTags: (json['seo_tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      processingTimeMs: (json['processing_time_ms'] as num?)?.toInt() ?? 0,
    );
  }

  final String detectedLanguage;
  final String rawTranscript;
  final String titleEn;
  final String titleHi;
  final String descriptionEn;
  final String descriptionHi;
  final List<String> features;
  final List<String> seoTags;
  final int processingTimeMs;

  Map<String, dynamic> toJson() {
    return {
      'detected_language': detectedLanguage,
      'raw_transcript': rawTranscript,
      'title_en': titleEn,
      'title_hi': titleHi,
      'description_en': descriptionEn,
      'description_hi': descriptionHi,
      'features': features,
      'seo_tags': seoTags,
      'processing_time_ms': processingTimeMs,
    };
  }
}

/// Exception thrown when image quality/blurriness gate rejects an upload (HTTP 422).
class ImageQualityException implements Exception {
  const ImageQualityException({
    required this.error,
    required this.message,
    this.qualityScore,
  });

  final String error;
  final double? qualityScore;
  final String message;

  @override
  String toString() => 'ImageQualityException: $message (Score: $qualityScore, Error: $error)';
}

/// Result from Fair Wage Pricing Engine model (`POST /api/v1/pricing/suggest`).
@immutable
class PricingSuggestionResult {
  const PricingSuggestionResult({
    required this.floorPrice,
    required this.suggestedPrice,
    required this.stretchPrice,
    this.confidence,
    this.artisanNote,
    this.materialCost,
    this.minProfitDesired,
    this.costFloor,
    this.projectedProfit,
    this.profitMarginPct,
    this.surplusAboveMinProfit,
    this.laborCost,
    this.category,
    this.craftTier,
    this.pricingStrategy,
  });

  factory PricingSuggestionResult.fromJson(Map<String, dynamic> json) {
    final priceRange = json['price_range'] as Map<String, dynamic>?;
    final costAnalysis = json['cost_analysis'] as Map<String, dynamic>?;
    final marketInsights = json['market_insights'] as Map<String, dynamic>?;
    final breakdown = json['breakdown'] as Map<String, dynamic>?;

    final floor = (priceRange?['min'] as num?)?.toDouble() ??
        (json['price_floor'] as num?)?.toDouble() ??
        0.0;
    final suggested = (priceRange?['suggested'] as num?)?.toDouble() ??
        (json['price_suggested'] as num?)?.toDouble() ??
        0.0;
    final stretch = (priceRange?['max'] as num?)?.toDouble() ??
        (json['price_stretch'] as num?)?.toDouble() ??
        0.0;

    final material = (costAnalysis?['raw_material_cost'] as num?)?.toDouble() ??
        (breakdown?['material_cost'] as num?)?.toDouble();
    final minProfit = (costAnalysis?['min_profit_desired'] as num?)?.toDouble();
    final floorCost = (costAnalysis?['cost_floor'] as num?)?.toDouble();
    final projected = (costAnalysis?['projected_profit'] as num?)?.toDouble() ??
        (breakdown?['labor_cost'] as num?)?.toDouble();
    final marginPct = (costAnalysis?['profit_margin_pct'] as num?)?.toDouble();
    final surplus = (costAnalysis?['surplus_above_min_profit'] as num?)?.toDouble();

    return PricingSuggestionResult(
      floorPrice: floor,
      suggestedPrice: suggested,
      stretchPrice: stretch,
      confidence: (json['confidence'] as num?)?.toDouble(),
      artisanNote: costAnalysis?['artisan_note'] as String?,
      materialCost: material,
      minProfitDesired: minProfit,
      costFloor: floorCost,
      projectedProfit: projected,
      profitMarginPct: marginPct,
      surplusAboveMinProfit: surplus,
      laborCost: projected,
      category: marketInsights?['category'] as String?,
      craftTier: marketInsights?['craft_tier'] as String?,
      pricingStrategy: marketInsights?['pricing_strategy'] as String?,
    );
  }

  final double floorPrice;
  final double suggestedPrice;
  final double stretchPrice;
  final double? confidence;
  final String? artisanNote;
  final double? materialCost;
  final double? minProfitDesired;
  final double? costFloor;
  final double? projectedProfit;
  final double? profitMarginPct;
  final double? surplusAboveMinProfit;
  final double? laborCost;
  final String? category;
  final String? craftTier;
  final String? pricingStrategy;

  /// Generates a certified fair wage price suggestion locally.
  /// Generates a certified fair wage price suggestion locally.
  /// Follows the ShilpSetu Fair Wage model (Bet 03):
  /// - Labor cost = artisanHours * hourlyWage (default ₹75/hr based on state craft minimum wage)
  /// - Overhead = 12% of materials + labor (workshop, transport, tools)
  /// - Floor = materials + labor + overhead (never sell below cost & fair wages)
  /// - Suggested = (materials + labor + overhead + minProfitDesired) * 1.10
  /// - Stretch = suggested * 1.35 (boutique/craft premium tier)
  factory PricingSuggestionResult.fairWage({
    required double rawMaterialCost,
    required double minProfit,
    double artisanHours = 6.0,
    double hourlyWage = 75.0,
    String? craftType,
  }) {
    final validRaw = rawMaterialCost.clamp(50.0, 100000.0);
    final validProfit = minProfit.clamp(50.0, 100000.0);
    final laborCost = artisanHours * hourlyWage;
    final overhead = (validRaw + laborCost) * 0.12;
    final costFloor = validRaw + validProfit;

    // Floor price rounded up to nearest 10
    final floorPrice = ((validRaw + laborCost + overhead) / 10).ceil() * 10.0;

    // Suggested price ensures fair wage + desired profit + 10% market buffer
    final rawSuggested = validRaw + laborCost + overhead + validProfit;
    final suggestedPrice = ((rawSuggested * 1.10) / 10).ceil() * 10.0;

    // Stretch price (premium craft market)
    final stretchPrice = ((suggestedPrice * 1.35) / 10).ceil() * 10.0;

    final projectedProfit = suggestedPrice - validRaw;
    final surplus = projectedProfit - validProfit;
    final profitMarginPct = (projectedProfit / suggestedPrice) * 100.0;

    return PricingSuggestionResult(
      floorPrice: floorPrice,
      suggestedPrice: suggestedPrice,
      stretchPrice: stretchPrice,
      confidence: 0.95,
      artisanNote:
          'Fair wage breakdown: ₹${validRaw.toStringAsFixed(0)} materials + ${artisanHours.toStringAsFixed(0)}h labor (₹${laborCost.toStringAsFixed(0)}) + 12% overhead + ₹${validProfit.toStringAsFixed(0)} profit.',
      materialCost: validRaw,
      minProfitDesired: validProfit,
      costFloor: costFloor,
      projectedProfit: projectedProfit,
      profitMarginPct: profitMarginPct,
      surplusAboveMinProfit: surplus,
      laborCost: laborCost,
      category: craftType ?? 'Handicraft',
      craftTier: 'Verified Artisan Craft',
      pricingStrategy: 'Fair Wage Artisan Model (Certified Floor)',
    );
  }
}
