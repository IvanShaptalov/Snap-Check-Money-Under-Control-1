//
//  UserOnboarder.swift
//  visionToText
//
//  Created by PowerMac on 05.11.2024.
//
import Foundation


class UserOnboarder {
    enum OnboardStatus: String {
        case onboarded = "onboarded"
    }
    
    static func isOnboarded() -> Bool {
        return UserDefaults().bool(forKey: OnboardStatus.onboarded.rawValue)
    }
    
    static func setOnboarded() {
        UserDefaults().set(true, forKey: OnboardStatus.onboarded.rawValue)
    }
}
