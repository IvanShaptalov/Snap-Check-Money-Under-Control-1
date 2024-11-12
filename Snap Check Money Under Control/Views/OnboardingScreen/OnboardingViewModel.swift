//
//  OnboardingViewModel.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 12.11.2024.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentIndex = 0
    var paywallIndex = 4
    var respectIndex = 5
    var discountIndex = 6
    var journeyIndex = 7
    

    let screens: [some View] = [
        AnyView(OnboardingScreen(
            title: "Welcome to Snap Check!",
            description: "Learn how our app will help you save and earn money. \n\n1. Quick expense tracking \n2. Full control of your data \n3. Save and earn money!",
            imageName: "SnapCheck"
        )),
        
        AnyView(OnboardingScreen(
            title: "How it works",
            description: "Take a photo of your receipt, save the data, and export if needed. Easily and efficiently manage your expenses.",
            imageName: "photoCheck" // Используем системное изображение
        )),
        
        AnyView(OnboardingScreen(
            title: "Your data is safe",
            description: "We don’t use your data. All of it is stored on your device for maximum privacy.",
            imageName: "safe" // Используем системное изображение
        )),
        
        AnyView(OnboardingScreen(
            title: "Set your currency",
            description: "Choose the currency that's most convenient for you. Convenient expense tracking anywhere in the world.",
            imageName: "currency" // Используем системное изображение
        )),

        AnyView(PaywallView(subType: "default")),
        
        AnyView(OnboardingScreen(
            title: "Smart Choice 💰",
            description: "By waiting, you've made a smart decision! You are now eligible for a special discount. Enjoy your savings and make the most of your expense tracking.",
            imageName: "leprecon" // Используем системное изображение для похвалы
        )),

        AnyView(PaywallView(subType: "sale")),
        
        AnyView(OnboardingScreen(
            title: "Your Journey to Financial Independence",
            description: "Wishing you a smooth and swift path towards financial freedom. Track your expenses easily and take control of your financial future.",
            imageName: "map" // Используем системное изображение карты, символизирующее путь
        ))
    ]

    func next() {
        print("next index: \(currentIndex)")
        if currentIndex < screens.count - 1 {
            if currentIndex + 1 == respectIndex && !MonetizationConfig.isPremiumAccount {
                print("next index: \(currentIndex)")
                currentIndex += 1
                return
            }
            // skip discount + respect
            if currentIndex + 1 == respectIndex && MonetizationConfig.isPremiumAccount {
                currentIndex = journeyIndex
                print("to journey index: \(currentIndex)")

                return
            }
            print("plus 1: \(currentIndex)")
            currentIndex += 1
        }
    }

    func previous() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}
