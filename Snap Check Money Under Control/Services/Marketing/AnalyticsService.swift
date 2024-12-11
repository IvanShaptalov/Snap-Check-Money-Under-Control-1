//
//  AnalyticsManager.swift
//  Learn Up
//
//  Created by PowerMac on 14.01.2024.
//

import Foundation
import FirebaseAnalytics


final class AnalyticsManager {
    private init() {}
    static let shared = AnalyticsManager()
    
    public func logEvent(eventType: EventType, parameters:  [String: Any]? = nil) {
        Analytics.logEvent(eventType.rawValue, parameters: parameters)
    }
}

enum EventType: String {
    case
    contactUsOpened = "contact_us_opened", // +
    showFormatEdited = "show_format_edited", // +
    currencyChanged = "currency_changed", // +
    rateDirectlyOpened = "rate_directly_opened", // +
    discountProProposed = "discount_pro_proposed", // +
    settingsScreen = "settings_screen", // +
    homeScreen = "home_screen", // +
    categoriesEdited = "categories_edited", // +

    shareScreen = "share_screen", // +


    checkEdited = "check_edited", // +
    checkEditedSaved = "check_edited_saved", // +
    checkEditedCancelled = "check_edited_cancelled", // +
    
    createCheckFromLibrary = "create_check_from_library", // +
    createCheckManually = "create_check_manually", // +
    createCheckFromCamera = "create_check_from_camera", // +
    creatingCheckCancelled = "creating_check_cancelled", // +

    
    proPurchaseFailed = "pro_purchase_failed", // +
    proPurchaseRestoreFailed = "pro_restore_failed", // +,
    proDirectOpen = "pro_direct_open", // +
    proPageClosed = "pro_page_closed", // +
    proPurchase = "pro_purchase", // +
    proPurchaseRestored = "pro_purchase_restored", // +
    
    exportExpenses = "exportExpensesSuccess",
    startExport = "startExport",

    
    
    discountProClosed = "discount_pro_closed", // +
    discountProPurchase = "discount_pro_purchase", // +
    discountProOpened = "discountProOpened", // +
    discountProNotNow = "discount_pro_not_now", // +
    discountPurchased = "discount_purchased", // +
    
    ad_showed = "interstitial_ad_showed", // +
    ad_clicked = "interstitial_ad_clicked", // +
    ad_cancelled = "interstitial_ad_cancelled", // +
    
    onboard_intro_1 = "onboard_intro_1",   // +
    onboard_how_it_works_2 = "onboard_how_it_works_2",  // +
    onboard_data_safe_3 = "onboard_data_safe_3",  // +
    onboard_currency_4 = "onboard_currency_4",  // +
    onboard_premium_5 = "onboard_premium_5",  // +
    onboard_premium_cancelled_leprecon_6 = "onboard_premium_cancelled_leprecon_6",  // +
    onboard_premium_discount_7 = "onboard_premium_discount_7",  // +
    onboard_start_journey_8 = "onboard_start_journey_8",  // +
    
    
    // critical
    error_subscription_not_loaded = "error_subscription_not_loaded",
    subscription_loaded = "subscription_loaded",
    
    
    // promocodes
    pro_via_promocode = "pro_via_promocode"
}
