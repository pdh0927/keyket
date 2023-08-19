import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final bannerAdvertisementProvider =
    StateNotifierProvider<BannerAdvertisementNotifier, AdManagerBannerAd?>(
        (ref) {
  return BannerAdvertisementNotifier();
});

class BannerAdvertisementNotifier extends StateNotifier<AdManagerBannerAd?> {
  BannerAdvertisementNotifier() : super(null);

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  void loadAd(int width, int maxHeight) {
    final bannerAd = AdManagerBannerAd(
      adUnitId: adUnitId,
      request: const AdManagerAdRequest(),
      sizes: [AdSize.getInlineAdaptiveBannerAdSize(width, maxHeight)],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (ad) {
          print('$ad loaded.');

          state = ad as AdManagerBannerAd;
          print(state);
        },
        onAdFailedToLoad: (ad, err) {
          print('AdManagerBannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }
}
