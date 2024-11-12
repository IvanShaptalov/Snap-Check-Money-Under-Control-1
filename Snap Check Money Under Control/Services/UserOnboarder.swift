//
//  UserOnboarder.swift
//  visionToText
//
//  Created by PowerMac on 05.11.2024.
//
import Foundation


class UserOnboarder {
    enum OnboardStatus: String {
        case
        tutorialOnboarded = "tutorial_onboarded",
        welcomeOnboard = "welcome_onboard"
    }
    
    static func isTutorialOnboarded() -> Bool {
        let result = UserDefaults().bool(forKey: OnboardStatus.tutorialOnboarded.rawValue)
        NSLog("⛴️ Tutorial Onboarded?: \(result)")
        return result
    }
    
    static func setTutorialOnboarded() {
        UserDefaults().set(true, forKey: OnboardStatus.tutorialOnboarded.rawValue)
        NSLog("⛴️ Tutorial onboarded")
    }
    
    static func isWelcomeOnboarded() -> Bool {
        let result = UserDefaults().bool(forKey: OnboardStatus.welcomeOnboard.rawValue)
        NSLog("⛴️ Welcome Onboarded?: \(result)")
        return result
    }
    
    static func setWelcomeOnboarded() {
        UserDefaults().set(true, forKey: OnboardStatus.welcomeOnboard.rawValue)
        NSLog("⛴️ Welcome onboarded")
    }
}
