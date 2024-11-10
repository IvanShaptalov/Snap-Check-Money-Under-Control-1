import Foundation
import FirebaseRemoteConfigInternal


class AppConfig {
    
    static var basicCategories: [String] {
        get {
            // Получаем сохранённые категории из UserDefaults
            if let data = UserDefaults.standard.data(forKey: AppStorageKeys.categoriesKey) {
                let decoder = JSONDecoder()
                if let categories = try? decoder.decode([String].self, from: data) {
                    return categories
                }
            }
            // Возвращаем значения по умолчанию, если нет сохранённых данных
            return [
                "Groceries",
                "Drinks",
                "Transport",
                "Entertainment",
                "Health",
                "Utilities",
                "Rent",
                "Clothes",
                "Other"
            ]
        }
        set {
            // Сохраняем новые категории в UserDefaults
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: AppStorageKeys.categoriesKey)
            }
        }
    }
    
    static let adjustCheckTitle = "📊 Adjustment for scanned check"
    
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    static var mainCurrency: Currency {
        get {
            // Получаем сохранённую валюту из UserDefaults
            if let savedCurrency = UserDefaults.standard.string(forKey: AppStorageKeys.currencyKey),
               let currency = Currency(rawValue: savedCurrency) {
                return currency
            }
            // Если нет сохраненной валюты, возвращаем значение по умолчанию
            return .usd
        }
        set {
            // Сохраняем новую валюту в UserDefaults
            UserDefaults.standard.set(newValue.rawValue, forKey: AppStorageKeys.currencyKey)
        }
    }
    
    static func updateMainCurrency(to currency: Currency) {
        mainCurrency = currency
    }
    
    
    static var showYearFormat: Bool {
        get {
            // Получаем сохранённое состояние из UserDefaults
            return UserDefaults.standard.bool(forKey: AppStorageKeys.showYearFormatKey)
        }
        set {
            // Сохраняем новое состояние в UserDefaults
            UserDefaults.standard.set(newValue, forKey: AppStorageKeys.showYearFormatKey)
        }
    }
    
    
    
    static func toggleIsShowYearFormat() {
        showYearFormat.toggle()
    }
    
    static var contactUsMail: String = "wellbeing.vantage@icloud.com"
    static var contactUsMailMessageBody =
         """
            <p>SnapCheck feedback: What Improve?</p>
            <p>We appreciate your thoughts and suggestions!</p>
            <p>Please share any features you would like to see or improvements that can enhance your experience.</p>
            <p>Thank you for your feedback!</p>
            """
    
    static var contactUsURL = URL(string: "https://www.instagram.com/wellbeingvantage/")!
    
    // MARK: - APPS
    static var aiBirthdayURL = URL(string: "https://apps.apple.com/us/app/ai-birthday-reminder-calendar/id6477883190")!
    static var triviaURL = URL(string: "https://apps.apple.com/ua/app/guess-the-song-in-music-trivia/id6503480745")!
    // TODO change appURL to real and add it in firebase as appURL
    static var appURL = URL(string: "https://apps.apple.com/us/app/jktemplate/id6475350565")!
    static var dailyUpURL = URL(string: "https://apps.apple.com/us/app/daily-up/id6475350565")!
    
    
    // MARK: - EULA & PrivacyPolicy
    static var termsOfUseURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    static var privacyPolicyURL = URL(string: "https://t.me/guessTheSongPrivacyPolicy")!
    
    
    // MARK: - RevenueCat
    static var revenuecat_project_apple_api_key = "appl_dDdGjupmvVZBgJEvVIMALJsNwqJ"
    
    static var rcOfferingIds = ["default", "sale"]
    
    // MARK: - SomeAPI
    static var someApiKey = "someApi"
    static var someApiID = "someApiID"
    
    static var stringList = [String]()
}



class FirebaseConfig {
    static let shared = FirebaseConfig()

    var remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    private init(){
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        settings.minimumFetchInterval = 0
        settings.fetchTimeout = 10
        remoteConfig.configSettings = settings
        
    }
    
}


extension AppConfig {
    static func fetchAndSetup(){
        
        FirebaseConfig.shared.remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                
                
                NSLog("Config fetched!")
                FirebaseConfig.shared.remoteConfig.activate { changed, error in
                    
                    func remote(forKey inner: String?) -> RemoteConfigValue {
                        return FirebaseConfig.shared.remoteConfig.configValue(forKey: inner)
                    }
                    
                    NSLog("⚙️ Remote Config changed: \(changed)")
                    
                    // MARK: - GPT Fetching
                    Assing.string(&AppConfig.contactUsMail, remote(forKey: "contactUsMail").stringValue)
                    
                    Assing.string(&AppConfig.contactUsMailMessageBody, remote(forKey: "contactUsMailMessageBody").stringValue)
                    
                    Assing.url(&AppConfig.aiBirthdayURL, remote(forKey: "aiBirthdayURL").stringValue)
                    
                    Assing.url(&AppConfig.triviaURL, remote(forKey: "triviaURL").stringValue)
                    
                    Assing.url(&AppConfig.dailyUpURL, remote(forKey: "dailyUpURL").stringValue)
                    
                    Assing.url(&AppConfig.appURL, remote(forKey: "appURL").stringValue)
                    
                    Assing.url(&AppConfig.contactUsURL, remote(forKey: "contactUsURL").stringValue)
                    
                    Assing.string(&AppConfig.someApiID, remote(forKey: "someApiID").stringValue)
                    
                    Assing.string(&AppConfig.someApiKey, remote(forKey: "someApiKey").stringValue)
                    
                    // MARK: - 😻 RevenueCat offering
                    Assing.list(&AppConfig.rcOfferingIds, remote(forKey: "revenueCatOfferingId").stringValue)
                    NSLog("😻 offering ids: \(AppConfig.rcOfferingIds)")
                    
                    Assing.list(&AppConfig.stringList, FirebaseConfig.shared.remoteConfig.configValue(forKey: "bestArtistsList").stringValue)
                    
                    MonetizationConfig.fetchFirebase()
                    RevenueCatService.setup(offeringIds: AppConfig.rcOfferingIds)
                }
                
            } else {
                NSLog("Config not fetched")
                NSLog("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}
