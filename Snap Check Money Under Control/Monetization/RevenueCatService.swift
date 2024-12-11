//
//  RevenueCatService.swift
//  JKTemplate
//
//  Created by PowerMac on 04.07.2024.
//

import Foundation
import RevenueCat
import UIKit

enum SubStatus: String{
    case
    AlreadySubscribed,
    Processing,
    PurchaseNotAllowedError,
    PurchaseInvalidError,
    UnknownError,
    PurchaseCancelled,
    Success
}


class RevenueCatService {
    typealias ConvertedOfferings = [String: [SubscriptionObj]]
    static var offerings: ConvertedOfferings = [:]
    
    static var hasPremium = false
        
    static func setup(offeringIds: [String]) {
        getCustomerInfo()
        NSLog("Start fetch subs")
        getOfferingById(ids: offeringIds) { result in
            
            switch result {
            case .success(let convertedOfferings):
                offerings = convertedOfferings
            case .failure(let error):
                NSLog(error.localizedDescription)
                offerings = [:]
            }
            
        }
    }
    
    static func restorePurchase(callback: @escaping (Bool) -> ()){
    
        Purchases.shared.restorePurchases { customerInfo, error in
            // ... check customerInfo to see if entitlement is now active

            let isPremium = self.updatePremiumStatus(customerInfo: customerInfo)
            
            callback(isPremium)
        }
    }
    
    // MARK: - Update premium status
    /// returns true if customer had active subscription
    static private func updatePremiumStatus(customerInfo: CustomerInfo?) -> Bool{
        guard customerInfo != nil else {
            self.hasPremium = false
            MonetizationConfig.isPremiumAccount = false
            return false
        }
        let hasPremium = !customerInfo!.entitlements.active.isEmpty
        self.hasPremium = hasPremium
        MonetizationConfig.isPremiumAccount = hasPremium
        NSLog("👑ℹ️ premium: \(MonetizationConfig.isPremiumAccount)")
        return hasPremium
    }
    
    // MARK: - Check premium account
    static func getCustomerInfo(){
        setPremiumViaPromocode()
        // check if not premium via promocode
        if !MonetizationConfig.isPremiumAccount {
            NSLog("👑‼️ premium via promocode not set , check customer info")
            Purchases.shared.getCustomerInfo { (customerInfo, error) in
                _ = updatePremiumStatus(customerInfo: customerInfo)
            }
        }
        
        

    }
    
    static func setPremiumViaPromocode() {
        NSLog("👑✅ premium via promocode set: \(AppConfig.promocodes.contains(AppConfig.currentPromocode.lowercased()))")
        if AppConfig.promocodes.contains(AppConfig.currentPromocode.lowercased()) {
            MonetizationConfig.isPremiumAccount = true
        }
    }
    
    // MARK: - purchase
    static func makePurchase(package: Package, errorCatcher: @escaping (SubStatus) -> Void ){
        if hasPremium {
            errorCatcher(.AlreadySubscribed)
        }
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, rawError, userCancelled) in
            // MARK: Unlock "pro" content
            if userCancelled {
                errorCatcher(.PurchaseCancelled)
                return
            }
            if let error = rawError as? RevenueCat.ErrorCode {
              print(error.errorCode)
              print(error.errorUserInfo)

              switch error {
              case .purchaseNotAllowedError:
                  errorCatcher(.PurchaseNotAllowedError)
              case .purchaseInvalidError:
                  errorCatcher(.PurchaseInvalidError)
              default:
                  errorCatcher(.UnknownError)
              }
            
            }
            _ = updatePremiumStatus(customerInfo: customerInfo)
            errorCatcher(.Success)
        }
        errorCatcher(.Processing)
    }
    
    // MARK: - get offerings 🕊️
    static func getOfferingById(ids : [String],
                                callback: @escaping (Result<ConvertedOfferings, RevenueCatError>) -> Void){
        NSLog("subs fetch received")
        // Using Completion Blocks
        Purchases.shared.getOfferings { (offerings, error) in
            
            var convertedOfferings : ConvertedOfferings = [:]
            
            for id in ids {
                if let rawPackages = offerings?.offering(identifier: id)?.availablePackages {
                    AnalyticsManager.shared.logEvent(eventType: .subscription_loaded)
                    NSLog("✅📦 fetch packages from identifier: \(id) ")
                    let packages = convertPackages(rawPackages)
                    convertedOfferings[id] = packages
                } else {
                    AnalyticsManager.shared.logEvent(eventType: .error_subscription_not_loaded)
                    NSLog("error ❌📦 while fetching packages from identifier: \(id) ")
                }
            }
            if convertedOfferings.isEmpty {
                callback(.failure(.OffersNotFound))
            } else {
                callback(.success(convertedOfferings))
            }
        }
    }
    // MARK: - Convert packages 📦
    static private func convertPackages(_ packages: [RevenueCat.Package]) -> [SubscriptionObj] {
        var subs: [SubscriptionObj] = []
        for pack in packages {
            
            let storeProduct = pack.storeProduct
            let offering = storeProduct.introductoryDiscount?.subscriptionPeriod.value
            let isFreeTrial = offering != nil
            subs.append(SubscriptionObj(title: storeProduct.localizedTitle, discount: 0,  priceDuration: "\(storeProduct.pricePerMonth ?? 1)$ per month", package: pack, totalPrice: storeProduct.price, isFamilyShareable: storeProduct.isFamilyShareable, isFreeTrial: isFreeTrial))
        }
        return subs
    }
}


enum RevenueCatError: Error {
    case
    OffersNotFound
}



class SubscriptionObj {
    var title: String
    var discount: Int
    var priceDuration: String
    var package: RevenueCat.Package
    var totalPrice: Decimal
    var isFamilyShareable: Bool
    var isFreeTrial: Bool
    
    init(title: String, discount: Int, priceDuration: String, package: RevenueCat.Package, totalPrice: Decimal, isFamilyShareable: Bool, isFreeTrial: Bool) {
        self.title = title
        self.discount = discount
        self.priceDuration = priceDuration
        self.package = package
        self.totalPrice = totalPrice
        self.isFamilyShareable = isFamilyShareable
        self.isFreeTrial = isFreeTrial
    }
}
