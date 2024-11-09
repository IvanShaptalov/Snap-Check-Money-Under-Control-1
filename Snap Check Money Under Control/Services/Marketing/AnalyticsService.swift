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
    eventCreated = "event_created",
    anniversaryCreated = "anniversary_created",
    birthdayCreated = "birthday_created",
    eventDeleted = "event_deleted",
    anniversaryDeleted = "anniversary_deleted",
    birthdayDeleted = "birthday_deleted",
    congratsGenerated = "congrats_generated",
    openProPage = "open_pro_page",
    rateAppImplicitA = "rate_app_implicit",
    rateAppDirect = "rate_app_direct",
    contactUsOpened = "contact_us",
    setUpTimeNotifications = "set_up_time_notifications",
    subscriptionButtonTapped = "sub_button_tapped",
    subContinueWithPlan = "sub_continue_with_plan",
    wishStartGenerating = "wish_start_generating",
    wishGenerated = "wish_generated",
    wishNotGenerated = "wish_not_generated",
    eventsImportedCalendarReminders = "import_from_calendar_reminders",
    manualImport = "manual_import",
    blockCellSelected = "blocked_cell_selected",
    exportText = "exportText",
    exportClipboard = "exportClipboard",
    exportTable = "exportTable",
    exportCalendar = "exportCalendar",
    exportReminders = "exportReminders",
    iconChanged = "iconChanged",
    tryIconChange = "tryIconChange",
    premiumEndedIconRestored = "premiumEndedIconRestored"
}
