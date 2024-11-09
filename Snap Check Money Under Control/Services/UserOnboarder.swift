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
        let result = UserDefaults().bool(forKey: OnboardStatus.onboarded.rawValue)
        print("⛴️ Onboarded?: \(result)")
        return result
    }
    
    static func setOnboarded() {
        UserDefaults().set(true, forKey: OnboardStatus.onboarded.rawValue)
        print("⛴️ onboarded")
    }
}
