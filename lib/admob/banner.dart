import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  BannerAd? _bannerAd;

  BannerAd? get bannerAd => _bannerAd;

  void loadAd() {
    // Definir IDs de dispositivos de teste
    RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: [
        'CF9725A744004B62CCF52E78036C17F4'
      ], // Substitua pelo ID do dispositivo de teste
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId:
          'ca-app-pub-4805454721398055/8492940056', // Substitua pelo seu ID de unidade de anúncio
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (ad != _bannerAd) {
            ad.dispose();
            return;
          }
          // Ad carregado
        },
        onAdFailedToLoad: (ad, error) {
          print('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}
