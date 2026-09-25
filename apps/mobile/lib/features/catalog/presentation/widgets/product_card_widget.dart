import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shilpsetu/core/api/shilpsetu_api_service.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/accessible_widgets.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/catalog/domain/models/product_model.dart';

/// Reusable Product Card Widget displaying an artisan creation.
class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    required this.product,
    super.key,
    this.language,
    this.isHindi = false,
    this.isPlaying = false,
    this.onPlayAudio,
    this.onTap,
  });

  final Product product;
  final AppLanguage? language;
  final bool isHindi;
  final bool isPlaying;
  final VoidCallback? onPlayAudio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveLang = language ?? (isHindi ? AppLanguage.hindi : AppLanguage.english);
    final strings = effectiveLang.strings;
    final fullImageUrl = ShilpSetuApiService.getFullImageUrl(product.enhancedImageUrl);
    final title = effectiveLang == AppLanguage.english
        ? (product.titleEn?.isNotEmpty ?? false ? product.titleEn! : (product.titleHi ?? 'Handcrafted Craft'))
        : (product.titleHi?.isNotEmpty ?? false ? product.titleHi! : (product.titleEn ?? 'हस्तनिर्मित शिल्प'));

    final secondaryTitle = effectiveLang == AppLanguage.english ? product.titleHi : product.titleEn;
    final description = effectiveLang == AppLanguage.english
        ? (product.descriptionEn?.isNotEmpty ?? false ? product.descriptionEn! : (product.descriptionHi ?? ''))
        : (product.descriptionHi?.isNotEmpty ?? false ? product.descriptionHi! : (product.descriptionEn ?? ''));

    final priceString = product.priceSuggested != null
        ? '₹ ${product.priceSuggested!.toStringAsFixed(0)}'
        : strings.priceCalculatorButton;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.cardRadius),
        side: BorderSide(
          color: isPlaying
              ? Palette.amberButton
              : Palette.purpleContainer.withValues(alpha: 0.25),
          width: isPlaying ? 2.5 : 1.5,
        ),
      ),
      elevation: isPlaying ? 6 : 3,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Clean Product Image ──────────────────────────────────
            if (fullImageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: fullImageUrl,
                httpHeaders: const {'ngrok-skip-browser-warning': 'true'},
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Palette.purpleContainerLight,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Palette.purpleContainerDark,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Palette.purpleContainerLight,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.palette_rounded,
                        size: 56,
                        color: Palette.purpleContainerDark,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ShilpSetu Craft',
                        style: TextStyle(
                          color: Palette.purpleContainerDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                height: 180,
                color: Palette.purpleContainerLight,
                child: const Center(
                  child: Icon(
                    Icons.palette_rounded,
                    size: 56,
                    color: Palette.purpleContainerDark,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Price Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (product.category != null && product.category!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Palette.purpleContainerLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            product.category!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Palette.purpleContainerDark,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Text(
                        priceString,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Palette.purpleContainerDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // English & Hindi Titles
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Palette.ink,
                    ),
                  ),
                  if (secondaryTitle != null && secondaryTitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      secondaryTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],

                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                  ],

                  // AI Tags Chips
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: product.tags.take(5).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF2DC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Palette.goldAccent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Palette.goldAccent,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Audio Readback Action Button
                  if (onPlayAudio != null) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            Sizes.minTouchTarget,
                            Sizes.minTouchTarget,
                          ),
                          backgroundColor: isPlaying
                              ? Palette.amberButton
                              : Palette.purpleContainer,
                          foregroundColor:
                              isPlaying ? Palette.ink : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Sizes.radius),
                          ),
                        ),
                        icon: isPlaying
                            ? const SoundWaveBars(
                                color: Palette.ink,
                              )
                            : const Icon(
                                Icons.play_circle_fill_rounded,
                                size: 26,
                              ),
                        label: Text(
                          isPlaying
                              ? '...'
                              : strings.listenDescription,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onPressed: onPlayAudio,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
