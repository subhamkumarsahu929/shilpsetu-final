import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shilpsetu/core/api/api_provider.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';

/// State of the cached catalog feed.
class CatalogFeedState {
  const CatalogFeedState({
    required this.products,
    required this.isLoading,
    this.errorMessage,
    this.isLoaded = false,
  });

  factory CatalogFeedState.initial() => const CatalogFeedState(
        products: [],
        isLoading: false,
      );

  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;
  final bool isLoaded;

  CatalogFeedState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
    bool? isLoaded,
    bool clearError = false,
  }) {
    return CatalogFeedState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

/// Manages fetching and in-memory caching of catalog products across screens.
class CatalogFeedNotifier extends StateNotifier<CatalogFeedState> {
  CatalogFeedNotifier(this._ref) : super(CatalogFeedState.initial());

  final Ref _ref;

  /// Fetches catalog feed. If already cached and not forced, returns immediately.
  Future<void> loadFeed({bool forceRefresh = false}) async {
    if (state.isLoaded && !forceRefresh && state.products.isNotEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final apiService = _ref.read(shilpSetuApiServiceProvider);
      final feed = await apiService.getCatalogFeed();
      state = state.copyWith(
        products: feed,
        isLoading: false,
        isLoaded: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoaded: true,
        errorMessage: e.toString(),
      );
    }
  }
}

final catalogFeedProvider =
    StateNotifierProvider<CatalogFeedNotifier, CatalogFeedState>((ref) {
  return CatalogFeedNotifier(ref);
});
