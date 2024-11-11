import SwiftUI
import SwiftData
import FirebaseCore
import RevenueCat
import GoogleMobileAds

@main
struct SnapCheckMoneyUnderControlApp: App {
    @StateObject private var chatViewModel = ChatViewModel()
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)        
    }
    
    var body: some Scene {
        WindowGroup {
            MainNavigation()
                .environmentObject(chatViewModel)
                .modelContainer(for: [ExpenseEntity.self]) // Передаем массив с моделью
                .task {
                    NSLog("App Started ⚙️")

                    // Конфигурация Firebase
                    FirebaseApp.configure()
                    
                    // Настройка конфигурации приложения (должно быть вызвано перед другими установками)
                    AppConfig.fetchAndSetup()
                    
                    // Настройка RevenueCat
                    Purchases.logLevel = .info
                    Purchases.configure(withAPIKey: AppConfig.revenuecat_project_apple_api_key)
                    
                    // Запуск Google Mobile Ads
                    
                    // Инициализация ChatViewModel с неизменяемым ключом
                }
        }
    }
}
