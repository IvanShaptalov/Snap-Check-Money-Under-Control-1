import SwiftUI
import SwiftData
import FirebaseCore
import RevenueCat
import GoogleMobileAds
import WishKit

@main
struct SnapCheckMoneyUnderControlApp: App {
    @StateObject private var chatViewModel = ChatViewModel()
    
    init() {
        NSLog("App Started ⚙️")
        
        // Конфигурация Firebase
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        // Настройка конфигурации приложения (должно быть вызвано перед другими установками)
        AppConfig.fetchAndSetup()
        
        // Настройка RevenueCat
        Purchases.logLevel = .info
        Purchases.configure(withAPIKey: AppConfig.revenuecat_project_apple_api_key)
        WishKit.configure(with: AppConfig.wishKitApi)
        
        WishKit.theme.primaryColor = Color(cgColor: UIColor.systemBlue.cgColor)
        WishKit.theme.tertiaryColor = .init(light: Color(cgColor: UIColor.white.cgColor),
                                            dark: Color(cgColor: UIColor.black.cgColor))
        
        // Запуск Google Mobile Ads
        
        // Инициализация ChatViewModel с неизменяемым ключом
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            MainNavigation()
                .environmentObject(chatViewModel)
                .modelContainer(for: [ExpenseEntity.self]) // Передаем массив с моделью
        }
    }
}
