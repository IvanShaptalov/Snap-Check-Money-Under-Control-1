import Foundation


enum Currency: String, CaseIterable, Codable {
    case usd = "USD" // United States Dollar
    case aud = "AUD" // Australian Dollar
    case cad = "CAD" // Canadian Dollar
    case chf = "CHF" // Swiss Franc
    case eur = "EUR" // Euro
    case gbp = "GBP" // British Pound Sterling
    case jpy = "JPY" // Japanese Yen
    case nzd = "NZD" // New Zealand Dollar
    case sek = "SEK" // Swedish Krona
    case dkk = "DKK" // Danish Krone
    case nok = "NOK" // Norwegian Krone
    case hkd = "HKD" // Hong Kong Dollar
    case cny = "CNY" // Chinese Yuan
    case sgd = "SGD" // Singapore Dollar
    case mxn = "MXN" // Mexican Peso
    case brl = "BRL" // Brazilian Real
    case inr = "INR" // Indian Rupee
    case czk = "CZK" // Czech Koruna
    case pln = "PLN" // Polish Zloty
    case mad = "MAD" // Moroccan Dirham
    case myr = "MYR" // Malaysian Ringgit
    case php = "PHP" // Philippine Peso
    case thb = "THB" // Thai Baht
    case idr = "IDR" // Indonesian Rupiah
    case vnd = "VND" // Vietnamese Dong
    case uah = "UAH" // Ukrainian Hryvnia
    
    // Метод для получения эмодзи для валюты
    var emoji: String {
        switch self {
        case .usd: return "🇺🇸"
        case .aud: return "🇦🇺"
        case .cad: return "🇨🇦"
        case .chf: return "🇨🇭"
        case .eur: return "🇪🇺"
        case .gbp: return "🇬🇧"
        case .jpy: return "🇯🇵"
        case .nzd: return "🇳🇿"
        case .sek: return "🇸🇪"
        case .dkk: return "🇩🇰"
        case .nok: return "🇳🇴"
        case .hkd: return "🇭🇰"
        case .cny: return "🇨🇳"
        case .sgd: return "🇸🇬"
        case .mxn: return "🇲🇽"
        case .brl: return "🇧🇷"
        case .inr: return "🇮🇳"
        case .czk: return "🇨🇿"
        case .pln: return "🇵🇱"
        case .mad: return "🇲🇦"
        case .myr: return "🇲🇾"
        case .php: return "🇵🇭"
        case .thb: return "🇹🇭"
        case .idr: return "🇮🇩"
        case .vnd: return "🇻🇳"
        case .uah: return "🇺🇦"
        }
    }
    
    // Метод для преобразования строки в Currency без эмодзи
    static func from(string: String) -> Currency {
        return Currency.allCases.first(where: { $0.rawValue.caseInsensitiveCompare(string) == .orderedSame }) ?? .usd
    }
    
    // Метод для преобразования строки в Currency с эмодзи
    static func fromEmoji(string: String) -> Currency? {
        return Currency.allCases.first(where: { $0.emoji == string })
    }
    
    // Метод для получения строки на основе Currency без эмодзи
    var stringValue: String {
        return self.rawValue
    }
    
    var description: String {
        return self.rawValue + " " + self.emoji
    }
    
    
}
