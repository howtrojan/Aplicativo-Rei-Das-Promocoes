import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdManager {
  BannerAd? _bannerAd;

  BannerAd? get bannerAd => _bannerAd;

  void loadAd() {
    // Definir IDs de dispositivos de teste
    RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: [
        dotenv.get('TESTE_DEVICE_ID'),
      ], // Substitua pelo ID do dispositivo de teste
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId:
          dotenv.get('BANNER_ID'), // Substitua pelo seu ID de unidade de anúncio
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
