import 'package:flutter_test/flutter_test.dart';
import 'package:shilpsetu/core/api/shilpsetu_api_service.dart';

void main() {
  group('ShilpSetuApiService Tests', () {
    test('getFullImageUrl prepends base URL to relative path', () {
      const relative = '/uploads/products/d54a2b91.webp';
      final fullUrl = ShilpSetuApiService.getFullImageUrl(relative, base: 'http://10.0.2.2:8000');
      expect(fullUrl, 'http://10.0.2.2:8000/uploads/products/d54a2b91.webp');
    });

    test('getFullImageUrl defaults to ngrok base URL when base is omitted', () {
      const relative = '/uploads/products/sample.webp';
      final fullUrl = ShilpSetuApiService.getFullImageUrl(relative);
      expect(fullUrl, 'https://snowiness-pushup-brewing.ngrok-free.dev/uploads/products/sample.webp');
    });

    test('getFullImageUrl preserves absolute URLs', () {
      const absolute = 'https://res.cloudinary.com/demo/image/upload/sample.jpg';
      final fullUrl = ShilpSetuApiService.getFullImageUrl(absolute);
      expect(fullUrl, absolute);
    });

    test('getFullImageUrl handles null or empty safely', () {
      expect(ShilpSetuApiService.getFullImageUrl(null), '');
      expect(ShilpSetuApiService.getFullImageUrl(''), '');
    });
  });
}
