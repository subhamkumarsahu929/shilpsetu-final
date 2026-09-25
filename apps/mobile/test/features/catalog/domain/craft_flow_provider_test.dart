import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shilpsetu/core/api/shilpsetu_api_service.dart';
import 'package:shilpsetu/features/catalog/domain/craft_flow_provider.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';

class MockShilpSetuApiService extends Mock implements ShilpSetuApiService {}

void main() {
  setUpAll(() {
    registerFallbackValue(File('dummy_path'));
  });

  group('CraftFlowNotifier 3-Step Sequence Tests', () {
    late MockShilpSetuApiService apiService;
    late CraftFlowNotifier notifier;

    setUp(() {
      apiService = MockShilpSetuApiService();
      notifier = CraftFlowNotifier(apiService: apiService);
    });

    test('Initial state is empty', () {
      expect(notifier.state.hasProcessedImage, isFalse);
      expect(notifier.state.hasDescription, isFalse);
      expect(notifier.state.pricingResult, isNull);
    });

    test('Step 1: setProcessedImage registers background-removed image', () async {
      when(() => apiService.enhanceImage(any())).thenAnswer(
        (_) async => const EnhancedImageResult(
          enhancedUrl: '/uploads/enhanced/test.webp',
          qualityScore: 94.0,
          processingTimeMs: 1200,
        ),
      );
      when(() => apiService.baseUrl).thenReturn('https://api.test.com');

      await notifier.setProcessedImage(
        localPath: 'test_path/segmented.jpg',
      );

      expect(notifier.state.localProcessedImagePath, 'test_path/segmented.jpg');
      expect(notifier.state.hasProcessedImage, isTrue);
    });

    test('Step 2 (Choice A): generateDescriptionFromPhotoOnly populates description', () async {
      // Create a temporary file so existsSync() returns true
      final tempFile = File('${Directory.systemTemp.path}/craft_test.jpg');
      await tempFile.writeAsBytes([1, 2, 3]);

      notifier.state = notifier.state.copyWith(
        localProcessedImagePath: tempFile.path,
      );

      when(
        () => apiService.describeFromPhotoOnly(
          imageFile: any(named: 'imageFile'),
          artisanId: any(named: 'artisanId'),
          languageHint: any(named: 'languageHint'),
        ),
      ).thenAnswer(
        (_) async => const UnifiedAIResponse(
          productId: 1,
          artisanId: 'artisan_app',
          titleEn: 'Handmade Terracotta Diya',
          titleHi: 'हाथ से बना दीया',
          descriptionEn: 'Pure natural clay diya',
          descriptionHi: 'शुद्ध मिट्टी का दीया',
          features: ['Pure clay', 'Handmade'],
          tags: ['terracotta', 'pottery'],
          enhancedImageUrl: '/uploads/enhanced.webp',
          qualityScore: 92.0,
          detectedLanguage: 'hi',
          rawTranscript: '',
          processingTimeMs: 1500,
          isSaved: false,
        ),
      );

      await notifier.generateDescriptionFromPhotoOnly(languageCode: 'hi');

      expect(notifier.state.isGeneratingDescription, isFalse);
      expect(notifier.state.hasDescription, isTrue);
      expect(notifier.state.titleEn, 'Handmade Terracotta Diya');
      expect(notifier.state.features.length, 2);
      expect(notifier.state.usedVoice, isFalse);
      expect(notifier.state.craftType, 'terracotta');

      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
    });

    test('Step 2 (Choice B): generateDescriptionWithVoice populates description with voice', () async {
      final tempAudio = File('${Directory.systemTemp.path}/voice_test.m4a');
      await tempAudio.writeAsBytes([4, 5, 6]);

      when(
        () => apiService.processVoiceNote(
          any(),
          languageHint: any(named: 'languageHint'),
        ),
      ).thenAnswer(
        (_) async => const VoiceCatalogResponse(
          detectedLanguage: 'hi',
          rawTranscript: 'mitti ka diya banaya hai',
          titleEn: 'Spoken Terracotta Diya',
          titleHi: 'बोला गया टेराकोटा दीया',
          descriptionEn: 'Clay diya described via voice',
          descriptionHi: 'आवाज़ द्वारा वर्णित मिट्टी का दीया',
          features: ['Natural Clay', '8 Hours Labor'],
          seoTags: ['terracotta'],
          processingTimeMs: 1100,
        ),
      );

      await notifier.generateDescriptionWithVoice(
        audioFile: tempAudio,
        languageCode: 'hi',
      );

      expect(notifier.state.isGeneratingDescription, isFalse);
      expect(notifier.state.hasDescription, isTrue);
      expect(notifier.state.titleEn, 'Spoken Terracotta Diya');
      expect(notifier.state.usedVoice, isTrue);

      if (tempAudio.existsSync()) {
        await tempAudio.delete();
      }
    });

    test('Step 3: calculatePricing calculates prices with pricing model', () async {
      when(
        () => apiService.getPricingSuggestion(
          craftType: any(named: 'craftType'),
          rawMaterialCost: any(named: 'rawMaterialCost'),
          minProfit: any(named: 'minProfit'),
          artisanHours: any(named: 'artisanHours'),
          state: any(named: 'state'),
          title: any(named: 'title'),
          category: any(named: 'category'),
          imageUrl: any(named: 'imageUrl'),
        ),
      ).thenAnswer(
        (_) async => const PricingSuggestionResult(
          floorPrice: 880.0,
          suggestedPrice: 1100.0,
          stretchPrice: 1485.0,
          confidence: 0.88,
          artisanNote: 'Fair wage target Rs. 1100',
        ),
      );

      await notifier.calculatePricing(craftType: 'terracotta');

      expect(notifier.state.isCalculatingPricing, isFalse);
      expect(notifier.state.pricingResult, isNotNull);
      expect(notifier.state.pricingResult!.floorPrice, 880.0);
      expect(notifier.state.pricingResult!.suggestedPrice, 1100.0);
      expect(notifier.state.pricingResult!.stretchPrice, 1485.0);
    });

    test(
      'Step 3: calculatePricing passes user material cost and profit to pricing model',
      () async {
        when(
          () => apiService.getPricingSuggestion(
            craftType: 'terracotta',
            rawMaterialCost: 650.0,
            minProfit: 450.0,
            artisanHours: any(named: 'artisanHours'),
            state: any(named: 'state'),
            title: any(named: 'title'),
            category: any(named: 'category'),
            imageUrl: any(named: 'imageUrl'),
          ),
        ).thenAnswer(
          (_) async => const PricingSuggestionResult(
            floorPrice: 1100.0,
            suggestedPrice: 1450.0,
            stretchPrice: 1900.0,
            materialCost: 650.0,
            minProfitDesired: 450.0,
            costFloor: 1100.0,
            projectedProfit: 800.0,
            surplusAboveMinProfit: 350.0,
            profitMarginPct: 55.2,
            artisanNote: 'Custom profit calculation successful',
          ),
        );

        await notifier.calculatePricing(
          craftType: 'terracotta',
          rawMaterialCost: 650.0,
          minProfit: 450.0,
        );

        expect(notifier.state.rawMaterialCost, 650.0);
        expect(notifier.state.minProfit, 450.0);
        expect(notifier.state.pricingResult, isNotNull);
        expect(notifier.state.pricingResult!.costFloor, 1100.0);
        expect(notifier.state.pricingResult!.suggestedPrice, 1450.0);
        expect(notifier.state.pricingResult!.projectedProfit, 800.0);
        expect(notifier.state.pricingResult!.surplusAboveMinProfit, 350.0);
      },
    );

    test('reset clears flow back to empty initial state', () {
      notifier.state = notifier.state.copyWith(
        localProcessedImagePath: 'some/path.jpg',
        titleEn: 'Some Craft',
      );
      expect(notifier.state.hasProcessedImage, isTrue);

      notifier.reset();

      expect(notifier.state.hasProcessedImage, isFalse);
      expect(notifier.state.hasDescription, isFalse);
    });
  });
}
