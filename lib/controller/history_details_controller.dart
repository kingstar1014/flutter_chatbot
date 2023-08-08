import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';

class HistoryDetailsController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    loadAd();
    super.onInit();
  }

  InterstitialAd? interstitialAd;

  loadAd() {
    InterstitialAd.load(
        adUnitId: Constant().getInterstitialAdUnitId().toString(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            interstitialAd = null;
          },
        ));
  }
}
