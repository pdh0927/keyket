import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      ? dotenv.env['ANDROID_BANNER_UNIT_KEY']
      : dotenv.env['IOS_BANNER_UNIT_KEY'];

  void loadAd(int width, int maxHeight) {
    final bannerAd = AdManagerBannerAd(
      adUnitId: adUnitId!,
      request: const AdManagerAdRequest(),
      sizes: [AdSize.getInlineAdaptiveBannerAdSize(width, maxHeight)],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (ad) {
          print('$ad loaded.');

          state = ad as AdManagerBannerAd;
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
