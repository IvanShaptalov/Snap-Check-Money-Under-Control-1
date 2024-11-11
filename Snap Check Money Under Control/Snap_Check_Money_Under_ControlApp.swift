import SwiftUI
import SwiftData
import FirebaseCore
import RevenueCat
import GoogleMobileAds

@main
struct Snap_Check_Money_Under_ControlApp: App {
    @StateObject private var chatViewModel = ChatViewModel(apiKey: "sk-proj-mJa7V567HzfyNfoHO8UcT3BlbkFJwATX5N2Nyn5TAjB3xX6q")
    
    init() {
        NSLog("App Started ⚙️")
        FirebaseApp.configure()
        // AppConfig Fetcher must precede other setup's
        AppConfig.fetchAndSetup()
        
        Purchases.logLevel = .info
        Purchases.configure(withAPIKey: AppConfig.revenuecat_project_apple_api_key)
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            MainNavigation()
                .environmentObject(chatViewModel)
                .modelContainer(for: [ExpenseEntity.self]) // передаем массив с моделью
        }
    }
}
