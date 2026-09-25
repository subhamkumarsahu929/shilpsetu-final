import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';

/// Default base URL used when no custom Dio/base is injected.
/// On emulator: `http://10.0.2.2:8000`; override via `--dart-define=SHILPSETU_API_BASE_URL=...`
const String _kDefaultBaseUrl = String.fromEnvironment(
  'SHILPSETU_API_BASE_URL',
  defaultValue: 'https://snowiness-pushup-brewing.ngrok-free.dev',
);

/// ShilpSetu AI Backend Service.
///
/// Implements all endpoints specified in the integration guide:
/// - One-Tap Unified Multi-Modal AI (`POST /api/v1/products/create-ai`)
/// - AI Image Studio Enhancement (`POST /api/v1/image/enhance`)
/// - AI Voice Cataloger (`POST /api/v1/catalog/voice`)
/// - Final Product Publishing (`POST /api/v1/products`)
/// - Catalog Feed Query (`GET /api/v1/products/feed`)
class ShilpSetuApiService {
  ShilpSetuApiService({Dio? dio, String? baseUrl})
      : _baseUrl = baseUrl ?? _kDefaultBaseUrl,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? _kDefaultBaseUrl,
                headers: {
                  'ngrok-skip-browser-warning': 'true',
                  'Accept': 'application/json',
                },
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 15),
                sendTimeout: const Duration(seconds: 15),
              ),
            );

  final String _baseUrl;
  final Dio _dio;

  String get baseUrl => _baseUrl;

  /// Helper to convert relative image URLs returned by the backend to full absolute URLs.
  /// Example: `/uploads/products/d54a2b91.webp` -> `http://10.0.2.2:8000/uploads/products/d54a2b91.webp`
  static String getFullImageUrl(String? relativePath, {String? base}) {
    if (relativePath == null || relativePath.isEmpty) return '';
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) {
      return relativePath;
    }
    final host = base ?? _kDefaultBaseUrl;
    final cleanHost = host.endsWith('/') ? host.substring(0, host.length - 1) : host;
    final cleanPath = relativePath.startsWith('/') ? relativePath : '/$relativePath';
    return '$cleanHost$cleanPath';
  }

  // ── 1. ALL-IN-ONE ONE-TAP FLOW ─────────────────────────────────────────────
  /// Upload craft photo and/or audio description in multi-modal request.
  Future<UnifiedAIResponse> createProductWithAI({
    File? imageFile,
    File? audioFile,
    required String artisanId,
    String? languageHint,
    bool autoSave = true,
    ProgressCallback? onProgress,
  }) async {
    assert(imageFile != null || audioFile != null, 'At least image or audio must be provided');

    final map = <String, dynamic>{
      'artisan_id': artisanId,
      if (languageHint != null && languageHint.isNotEmpty) 'language_hint': languageHint,
      'auto_save': autoSave.toString(),
    };

    if (imageFile != null) {
      final fileNameImg = imageFile.path.split(Platform.pathSeparator).last;
      map['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileNameImg.isNotEmpty ? fileNameImg : 'craft.jpg',
      );
    }

    if (audioFile != null) {
      final fileNameAud = audioFile.path.split(Platform.pathSeparator).last;
      map['audio'] = await MultipartFile.fromFile(
        audioFile.path,
        filename: fileNameAud.isNotEmpty ? fileNameAud : 'voice.m4a',
      );
    }

    final formData = FormData.fromMap(map);

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/products/create-ai',
      data: formData,
      onSendProgress: onProgress,
    );

    return UnifiedAIResponse.fromJson(response.data!);
  }

  // ── 2. STEP 1: ENHANCE IMAGE ───────────────────────────────────────────────
  /// Removes messy background, enhances colors, and upscales resolution.
  /// Throws [ImageQualityException] on HTTP 422 if the image is too blurry.
  Future<EnhancedImageResult> enhanceImage(
    File imageFile, {
    String outputFormat = 'webp',
  }) async {
    try {
      final fileName = imageFile.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName.isNotEmpty ? fileName : 'upload.jpg',
        ),
        'output_format': outputFormat,
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/image/enhance',
        data: formData,
      );

      return EnhancedImageResult.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422 && e.response?.data is Map) {
        final detail = (e.response!.data as Map)['detail'];
        if (detail is Map) {
          throw ImageQualityException(
            error: detail['error']?.toString() ?? 'image_quality_too_low',
            qualityScore: (detail['quality_score'] as num?)?.toDouble(),
            message: detail['message']?.toString() ?? 'Please upload a clearer image.',
          );
        }
      }
      rethrow;
    }
  }

  // ── 3. STEP 2: VOICE TO LISTING ───────────────────────────────────────────
  /// Transcribes regional craft speech and formats listing details with Gemini AI.
  Future<VoiceCatalogResponse> processVoiceNote(
    File audioFile, {
    String? languageHint,
  }) async {
    final fileName = audioFile.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(
        audioFile.path,
        filename: fileName.isNotEmpty ? fileName : 'voice.m4a',
      ),
      if (languageHint != null && languageHint.isNotEmpty) 'language_hint': languageHint,
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/catalog/voice',
      data: formData,
    );

    return VoiceCatalogResponse.fromJson(response.data!);
  }

  // ── 4. STEP 3: SAVE PRODUCT ────────────────────────────────────────────────
  /// Saves the finalized, reviewed product listing.
  Future<Product> saveProduct({
    required String artisanId,
    required String titleEn,
    required String titleHi,
    required String descriptionEn,
    required String descriptionHi,
    required String enhancedImageUrl,
    String? category,
    double? priceSuggested,
    List<String> features = const [],
    List<String> tags = const [],
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/products',
      data: {
        'artisan_id': artisanId,
        'title_en': titleEn,
        'title_hi': titleHi,
        'description_en': descriptionEn,
        'description_hi': descriptionHi,
        if (category != null) 'category': category,
        'enhanced_image_url': enhancedImageUrl,
        if (priceSuggested != null) 'price_suggested': priceSuggested,
        'features': features,
        'tags': tags,
      },
    );

    return Product.fromJson(response.data!);
  }

  // ── 5. FETCH CATALOG FEED ──────────────────────────────────────────────────
  /// Fetches marketplace catalog feed with pagination.
  Future<List<Product>> getCatalogFeed({int limit = 20, int offset = 0}) async {
    final response = await _dio.get<List<dynamic>>(
      '/api/v1/products/feed',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );

    return response.data!.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
  }

  // ── 6. GET PRICING SUGGESTION ──────────────────────────────────────────────
  /// Calls the Fair Wage Pricing Engine model (`POST /api/v1/pricing/suggest`).
  /// Calculates optimal fair market pricing based on raw material cost and desired profit.
  Future<PricingSuggestionResult> getPricingSuggestion({
    String craftType = 'terracotta',
    required double rawMaterialCost,
    double? minProfit,
    double artisanHours = 6,
    String state = 'Odisha',
    String? title,
    String? category,
    String? imageUrl,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/pricing/suggest',
      data: {
        'craft_type': craftType,
        'raw_material_cost': rawMaterialCost,
        if (minProfit != null) 'min_profit': minProfit,
        'artisan_hours': artisanHours,
        'state': state,
        if (title != null && title.isNotEmpty) 'title': title,
        if (category != null && category.isNotEmpty) 'category': category,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
      },
    );

    return PricingSuggestionResult.fromJson(response.data!);
  }

  // ── 7. DESCRIBE FROM PHOTO ONLY ───────────────────────────────────────────
  /// Uses multi-modal AI vision model to suggest attributes and description from craft photo.
  Future<UnifiedAIResponse> describeFromPhotoOnly({
    required File imageFile,
    required String artisanId,
    String? languageHint,
  }) async {
    return createProductWithAI(
      imageFile: imageFile,
      artisanId: artisanId,
      languageHint: languageHint,
      autoSave: false,
    );
  }
}
