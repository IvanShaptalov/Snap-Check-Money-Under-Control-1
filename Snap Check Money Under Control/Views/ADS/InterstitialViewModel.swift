import GoogleMobileAds

class InterstitialViewModel: NSObject, GADFullScreenContentDelegate {
    private var interstitialAd: GADInterstitialAd?
    
    func loadAd() async {
        guard AppConfig.isShowAds == 1 else {
            print("ads loading disabled from firebase remote config")
            return
        }
        if MonetizationConfig.isPremiumAccount {
            print("premium 😎, f ads to pay respect")
        } else {
            print("Interstitial ads start loading 💰")
            do {
                interstitialAd = try await GADInterstitialAd.load(
                    withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
                interstitialAd?.fullScreenContentDelegate = self
                print("Loaded 💰")
            } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        AnalyticsManager.shared.logEvent(eventType: .ad_clicked)

        print("\(#function) called")
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("\(#function) called")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        AnalyticsManager.shared.logEvent(eventType: .ad_cancelled)

        print("\(#function) called")
        // Clear the interstitial ad.
        interstitialAd = nil
    }
    
    func showAd() {
        guard AppConfig.isShowAds == 1 else {
            print("ads disabled from firebase remote config ‼️")
            return
        }
        guard MonetizationConfig.isPremiumAccount == false else {
            print("premium 😎, f ads to pay respect, not showing")
            return
        }
        
        guard let interstitialAd = interstitialAd else {
            return print("Ad wasn't ready.")
        }
        
        interstitialAd.present(fromRootViewController: nil)
        AnalyticsManager.shared.logEvent(eventType: .ad_showed)

    }
    
}
