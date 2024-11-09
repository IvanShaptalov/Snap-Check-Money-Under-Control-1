import Foundation


class MonetizationConfig {
    static var isPremiumAccount: Bool = true
    
    static var freePlays: Int = 5
    
    
    static func getRecordsForAccount() -> Int{
        if isPremiumAccount{
            return -1
        }
        return freePlays
    }
    
    static func fetchFirebase() {
        freePlays = FirebaseConfig.shared.remoteConfig.configValue(forKey: "freePlays").numberValue as? Int ?? freePlays
        
        // because Firebase can return 0 if field doesn't exists
        freePlays = freePlays == 0 ? 5 : freePlays
        
        NSLog("🪙 free plays: \(freePlays)")
    }
}

