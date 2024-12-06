import GoogleMobileAds

class InterstitialViewModel: NSObject, GADFullScreenContentDelegate {
    private var interstitialAd: GADInterstitialAd?
    
    
    func loadAd() async {
        interstitialAd = nil
        guard AppConfig.isShowAds == 1 else {
            NSLog("ads loading disabled from firebase remote config")
            return
        }
        if MonetizationConfig.isPremiumAccount {
            NSLog("premium 😎, f ads to pay respect")
        } else {
            NSLog("Interstitial ads start loading 💰")
            do {
                interstitialAd = try await GADInterstitialAd.load(
                    withAdUnitID: AppConfig.ad_id, request: GADRequest())
                interstitialAd?.fullScreenContentDelegate = self
                NSLog("Loaded 💰, id : \(AppConfig.ad_id)")
            } catch {
                NSLog("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        NSLog("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        AnalyticsManager.shared.logEvent(eventType: .ad_clicked)

        NSLog("\(#function) called")
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        NSLog("\(#function) called")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        NSLog("\(#function) called")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        NSLog("\(#function) called")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        AnalyticsManager.shared.logEvent(eventType: .ad_cancelled)

        NSLog("\(#function) called")
        // Clear the interstitial ad.
        interstitialAd = nil
    }
    
    func showAd() {
        guard AppConfig.isShowAds == 1 else {
            NSLog("ads disabled from firebase remote config ‼️")
            return
        }
        guard MonetizationConfig.isPremiumAccount == false else {
            NSLog("premium 😎, f ads to pay respect, not showing")
            return
        }
        
        guard let interstitialAd = interstitialAd else {
            return NSLog("Ad wasn't ready.")
        }
        
        interstitialAd.present(fromRootViewController: nil)
        AnalyticsManager.shared.logEvent(eventType: .ad_showed)
        await loadAd()

    }
    
}
