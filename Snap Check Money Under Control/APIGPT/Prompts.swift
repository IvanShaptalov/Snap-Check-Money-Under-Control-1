import Foundation


class Prompts {
    static let premiumPromtWithItems = """
    **only json in answer**
    create json check
    {
        "store": "Local Store Name", // replace with the store title corresponding to local stores
        "totalPrice": double, 
        "currency": "PLN", // currency code
        "items": [
            {"title": "str", "price": double, "category": "str"},
    //(allowed categories) - \(AppConfig.basicCategories) T
        ],
        "date": "\(AppConfig.dateFormat)" // if not exists - use datetime.now() in the format YYYY-MM-DDTHH:MM:SS
    }
    """

    
    static let promptWrapper = "**only json in answer**"
    
    static func preparePrompt(_ message: String) -> String {
        let wrapper = premiumPromtWithItems
        let combinedMessage = [wrapper, message, promptWrapper].joined(separator: " ")
        NSLog("🍪 Prepared prompt: \(combinedMessage)")
        return combinedMessage
    }
}





