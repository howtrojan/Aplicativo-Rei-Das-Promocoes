import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  // Singleton pattern
  static final InterstitialAdManager _instance = InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  // Initialize AdMob
  void initialize() {
    MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  // Load a new interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-4805454721398055/5967372159',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
          // Optionally, you can log the error or load a new ad after a delay
          print('Failed to load interstitial ad: $error');
        },
      ),
    );
  }

  // Check if the ad is loaded
  bool get isLoaded => _isAdLoaded;

  // Show the interstitial ad if loaded
  void showAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (Ad ad) {
          ad.dispose();
          _loadInterstitialAd(); // Load a new ad after dismissal
        },
        onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
          ad.dispose();
          _loadInterstitialAd(); // Load a new ad after failure
        },
      );
      _interstitialAd!.show();
    }
  }

  // Dispose of the interstitial ad when it's no longer needed
  void dispose() {
    _interstitialAd?.dispose();
  }
}
