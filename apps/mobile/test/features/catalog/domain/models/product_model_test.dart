import 'package:flutter_test/flutter_test.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson parses valid JSON correctly', () {
      final json = {
        'id': 14,
        'artisan_id': 'artisan_101',
        'title_en': 'Handmade Blue Terracotta Flower Vase',
        'title_hi': 'हस्तनिर्मित नीला टेराकोटा फूलदान',
        'description_en': 'Crafted from pure natural clay...',
        'description_hi': 'प्राकृतिक मिट्टी से तैयार...',
        'category': 'Pottery',
        'enhanced_image_url': '/uploads/products/d54a2b91.webp',
        'price_suggested': 750.0,
        'features': ['100% natural clay', 'Hand-painted floral motifs'],
        'tags': ['terracotta', 'handmade', 'pottery'],
        'created_at': '2026-09-18T00:15:30.123456',
      };

      final product = Product.fromJson(json);

      expect(product.id, 14);
      expect(product.artisanId, 'artisan_101');
      expect(product.titleEn, 'Handmade Blue Terracotta Flower Vase');
      expect(product.titleHi, 'हस्तनिर्मित नीला टेराकोटा फूलदान');
      expect(product.category, 'Pottery');
      expect(product.enhancedImageUrl, '/uploads/products/d54a2b91.webp');
      expect(product.priceSuggested, 750.0);
      expect(product.features.length, 2);
      expect(product.tags, contains('terracotta'));
      expect(product.createdAt, isNotNull);

      final outJson = product.toJson();
      expect(outJson['id'], 14);
      expect(outJson['artisan_id'], 'artisan_101');
    });

    test('UnifiedAIResponse.fromJson parses complete AI response correctly', () {
      final json = {
        'product_id': 14,
        'artisan_id': 'artisan_101',
        'title_en': 'Handmade Blue Terracotta Flower Vase',
        'title_hi': 'हस्तनिर्मित नीला टेराकोटा फूलदान',
        'description_en': 'Crafted from pure natural clay...',
        'description_hi': 'प्राकृतिक मिट्टी से तैयार...',
        'features': ['100% natural clay', 'Hand-painted floral motifs'],
        'tags': ['terracotta', 'handmade'],
        'enhanced_image_url': '/uploads/products/d54a2b91.webp',
        'quality_score': 88.4,
        'detected_language': 'hi',
        'raw_transcript': 'yeh mitti ka phool daan hai jo maine banaya hai',
        'processing_time_ms': 2340,
        'is_saved': true,
      };

      final aiResponse = UnifiedAIResponse.fromJson(json);

      expect(aiResponse.productId, 14);
      expect(aiResponse.artisanId, 'artisan_101');
      expect(aiResponse.qualityScore, 88.4);
      expect(aiResponse.detectedLanguage, 'hi');
      expect(aiResponse.rawTranscript, 'yeh mitti ka phool daan hai jo maine banaya hai');
      expect(aiResponse.isSaved, isTrue);
      expect(aiResponse.processingTimeMs, 2340);

      final outJson = aiResponse.toJson();
      expect(outJson['product_id'], 14);
      expect(outJson['is_saved'], isTrue);
    });

    test('EnhancedImageResult.fromJson parses studio results correctly', () {
      final json = {
        'enhanced_url': '/uploads/products/8f2c3b.webp',
        'quality_score': 92.5,
        'processing_time_ms': 1120,
        'original_size_px': [800, 600],
        'enhanced_size_px': [1600, 1200],
      };

      final res = EnhancedImageResult.fromJson(json);

      expect(res.enhancedUrl, '/uploads/products/8f2c3b.webp');
      expect(res.qualityScore, 92.5);
      expect(res.originalSizePx, [800, 600]);
      expect(res.enhancedSizePx, [1600, 1200]);
    });

    test('VoiceCatalogResponse.fromJson parses voice results correctly', () {
      final json = {
        'detected_language': 'hi',
        'raw_transcript': 'humne yeh banarsi saree hath se bun ke banayi hai',
        'title_en': 'Authentic Handloom Banarasi Silk Saree',
        'title_hi': 'प्रामाणिक हथकरघा बनारसी सिल्क साड़ी',
        'description_en': 'Exquisite handwoven Banarasi silk saree...',
        'description_hi': 'जटिल ज़री के काम से सजी उत्कृष्ट...',
        'features': ['Pure silk fabric', 'Traditional Zari border'],
        'seo_tags': ['banarasi saree', 'handloom', 'silk'],
        'processing_time_ms': 1850,
      };

      final res = VoiceCatalogResponse.fromJson(json);

      expect(res.detectedLanguage, 'hi');
      expect(res.titleEn, 'Authentic Handloom Banarasi Silk Saree');
      expect(res.features.length, 2);
      expect(res.seoTags, contains('banarasi saree'));
      expect(res.processingTimeMs, 1850);
    });

    test('PricingSuggestionResult.fromJson parses cloud pricing model JSON correctly', () {
      final json = {
        'price_range': {
          'min': 880.37,
          'suggested': 1100.46,
          'max': 1485.62,
        },
        'currency': 'INR',
        'confidence': 0.88,
        'market_insights': {
          'category': 'Handicraft',
          'craft_tier': 'Standard Craft',
          'pricing_strategy': 'Market Value Premium',
        },
        'cost_analysis': {
          'raw_material_cost': 450.0,
          'suggested_price': 1100.46,
          'projected_profit': 650.46,
          'artisan_note': 'Market demand allows Rs. 1100.',
        },
      };

      final res = PricingSuggestionResult.fromJson(json);

      expect(res.floorPrice, 880.37);
      expect(res.suggestedPrice, 1100.46);
      expect(res.stretchPrice, 1485.62);
      expect(res.confidence, 0.88);
      expect(res.category, 'Handicraft');
      expect(res.craftTier, 'Standard Craft');
      expect(res.pricingStrategy, 'Market Value Premium');
      expect(res.materialCost, 450.0);
      expect(res.laborCost, 650.46);
      expect(res.artisanNote, 'Market demand allows Rs. 1100.');
    });

    test('PricingSuggestionResult.fairWage calculates instant transparent pricing', () {
      final res = PricingSuggestionResult.fairWage(
        rawMaterialCost: 450,
        minProfit: 300,
        craftType: 'terracotta',
      );

      // Floor must cover materials (450) + 6h labor @ 75 (450) + 12% overhead (108) = 1008 -> 1010
      expect(res.floorPrice, greaterThanOrEqualTo(1008.0));
      expect(res.suggestedPrice, greaterThan(res.floorPrice));
      expect(res.stretchPrice, greaterThan(res.suggestedPrice));
      expect(res.projectedProfit, greaterThanOrEqualTo(300.0));
      expect(res.category, 'terracotta');
      expect(res.artisanNote, contains('Fair wage breakdown'));
    });
  });
}
