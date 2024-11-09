import Foundation
import UIKit
import StoreKit


class ReviewService {
    static var requestOncePerSession = true
    
    static func requestReview() {
        if requestOncePerSession {
            requestOncePerSession = false
            NSLog("rate app appeared 🤞")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        }
    }
}
