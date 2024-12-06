enum Currency: String, CaseIterable, Codable {
    case usd = "USD" // United States Dollar
    case eur = "EUR" // Euro
    
    case uah = "UAH" // Ukrainian Hryvnia
    case rub = "RUB" // Russian Ruble

    case ang = "ANG" // Netherlands Antillean Guilder
    case aed = "AED" // United Arab Emirates Dirham
    case afn = "AFN" // Afghan Afghani
    case all = "ALL" // Albanian Lek
    case amd = "AMD" // Armenian Dram
    case aoa = "AOA" // Angolan Kwanza
    case ars = "ARS" // Argentine Peso
    case azn = "AZN" // Azerbaijani Manat
    case bam = "BAM" // Bosnia and Herzegovina Convertible Mark
    case bbd = "BBD" // Barbadian Dollar
    case bdt = "BDT" // Bangladeshi Taka
    case bgn = "BGN" // Bulgarian Lev
    case bhd = "BHD" // Bahraini Dinar
    case bif = "BIF" // Burundian Franc
    case bmd = "BMD" // Bermudian Dollar
    case bnd = "BND" // Brunei Dollar
    case bob = "BOB" // Bolivian Boliviano
    case brl = "BRL" // Brazilian Real
    case bsd = "BSD" // Bahamian Dollar
    case btn = "BTN" // Bhutanese Ngultrum
    case bwp = "BWP" // Botswanan Pula
    case byn = "BYN" // Belarusian Ruble
    case bzd = "BZD" // Belize Dollar
    case cad = "CAD" // Canadian Dollar
    case cdf = "CDF" // Congolese Franc
    case chf = "CHF" // Swiss Franc
    case clf = "CLF" // Chilean Unit of Account
    case cny = "CNY" // Chinese Yuan
    case cop = "COP" // Colombian Peso
    case crc = "CRC" // Costa Rican Colón
    case cuc = "CUC" // Cuban Convertible Peso
    case cup = "CUP" // Cuban Peso
    case cvd = "CVD" // Cape Verdean Escudo
    case czk = "CZK" // Czech Koruna
    case djf = "DJF" // Djiboutian Franc
    case dkk = "DKK" // Danish Krone
    case dzd = "DZD" // Algerian Dinar
    case egp = "EGP" // Egyptian Pound
    case ern = "ERN" // Eritrean Nakfa
    case etb = "ETB" // Ethiopian Birr
    case fjd = "FJD" // Fijian Dollar
    case fkp = "FKP" // Falkland Islands Pound
    case gbp = "GBP" // British Pound Sterling
    case gel = "GEL" // Georgian Lari
    case gjd = "GJD" // Guernsey Pound
    case gmd = "GMD" // Gambian Dalasi
    case gnf = "GNF" // Guinean Franc
    case grr = "GRR" // Gibraltar Pound
    case gtq = "GTQ" // Guatemalan Quetzal
    case gwp = "GWP" // Guinea-Bissau Peso
    case hkd = "HKD" // Hong Kong Dollar
    case huf = "HUF" // Hungarian Forint
    case idr = "IDR" // Indonesian Rupiah
    case ils = "ILS" // Israeli New Shekel
    case imp = "IMP" // Isle of Man Pound
    case inr = "INR" // Indian Rupee
    case iqd = "IQD" // Iraqi Dinar
    case irr = "IRR" // Iranian Rial
    case isk = "ISK" // Icelandic Króna
    case jmd = "JMD" // Jamaican Dollar
    case jpy = "JPY" // Japanese Yen
    case kes = "KES" // Kenyan Shilling
    case kgs = "KGS" // Kyrgyzstani Som
    case khr = "KHR" // Cambodian Riel
    case kmf = "KMF" // Comorian Franc
    case kpw = "KPW" // North Korean Won
    case krw = "KRW" // South Korean Won
    case kwd = "KWD" // Kuwaiti Dinar
    case kyd = "KYD" // Cayman Islands Dollar
    case kzt = "KZT" // Kazakhstani Tenge
    case lak = "LAK" // Laotian Kip
    case lbp = "LBP" // Lebanese Pound
    case lkr = "LKR" // Sri Lankan Rupee
    case lrd = "LRD" // Liberian Dollar
    case lsl = "LSL" // Lesotho Loti
    case ltl = "LTL" // Lithuanian Litas
    case mad = "MAD" // Moroccan Dirham
    case mdl = "MDL" // Moldovan Leu
    case mga = "MGA" // Malagasy Ariary
    case mkd = "MKD" // Macedonian Denar
    case mmk = "MMK" // Myanmar Kyat
    case mop = "MOP" // Macanese Pataca
    case mro = "MRO" // Mauritanian Ouguiya
    case mru = "MRU" // Mauritanian Ouguiya (new)
    case mtl = "MTL" // Maltese Lira
    case mtn = "MTN" // Montserrat Dollar
    case mur = "MUR" // Mauritian Rupee
    case mxn = "MXN" // Mexican Peso
    case myr = "MYR" // Malaysian Ringgit
    case nad = "NAD" // Namibian Dollar
    case ngn = "NGN" // Nigerian Naira
    case nio = "NIO" // Nicaraguan Córdoba
    case nok = "NOK" // Norwegian Krone
    case npr = "NPR" // Nepalese Rupee
    case nzd = "NZD" // New Zealand Dollar
    case omr = "OMR" // Omani Rial
    case pab = "PAB" // Panamanian Balboa
    case pen = "PEN" // Peruvian Nuevo Sol
    case pgk = "PGK" // Papua New Guinean Kina
    case php = "PHP" // Philippine Peso
    case pkr = "PKR" // Pakistani Rupee
    case pln = "PLN" // Polish Zloty
    case pyg = "PYG" // Paraguayan Guarani
    case qar = "QAR" // Qatari Rial
    case ron = "RON" // Romanian Leu
    case rsd = "RSD" // Serbian Dinar
    case rwf = "RWF" // Rwandan Franc
    case sar = "SAR" // Saudi Riyal
    case sbd = "SBD" // Solomon Islands Dollar
    case scr = "SCR" // Seychellois Rupee
    case sdg = "SDG" // Sudanese Pound
    case sek = "SEK" // Swedish Krona
    case sgd = "SGD" // Singapore Dollar
    case shp = "SHP" // Saint Helena Pound
    case sll = "SLL" // Sierra Leone Leone
    case sos = "SOS" // Somali Shilling
    case srd = "SRD" // Surinamese Dollar
    case syp = "SYP" // Syrian Pound
    case szl = "SZL" // Swazi Lilangeni
    case thb = "THB" // Thai Baht
    case tjs = "TJS" // Tajikistani Somoni
    case tmt = "TMT" // Turkmenistani Manat
    case tnd = "TND" // Tunisian Dinar
    case top = "TOP" // Tongan Paʻanga
    case trylira = "TRY" // Turkish Lira
    case twd = "TWD" // New Taiwan Dollar
    case tzs = "TZS" // Tanzanian Shilling
    case ugx = "UGX" // Ugandan Shilling
    case uyu = "UYU" // Uruguayan Peso
    case uzs = "UZS" // Uzbekistani Som
    case vef = "VEF" // Venezuelan Bolívar
    case vnd = "VND" // Vietnamese Dong
    case vuv = "VUV" // Vanuatu Vatu
    case wst = "WST" // Samoan Tala
    case xaf = "XAF" // Central African CFA Franc
    case xag = "XAG" // Silver Ounce
    case xau = "XAU" // Gold Ounce
    
    // Метод для получения эмодзи для валюты
    var emoji: String {
        switch self {
        case .usd: return "🇺🇸"
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
        case .ars: return "🇦🇷"
        case .bgn: return "🇧🇬"
        case .huf: return "🇭🇺"
        case .lkr: return "🇱🇰"
        case .pkr: return "🇵🇰"
        case .ron: return "🇷🇴"
        case .sar: return "🇸🇦"
        case .syp: return "🇸🇾"
        case .vef: return "🇻🇪"
        case .aed: return "🇦🇪"
        case .afn: return "🇦🇫"
        case .all: return "🇦🇱"
        case .amd: return "🇦🇲"
        case .ang: return "🇧🇶"
        case .aoa: return "🇦🇴"
        case .azn: return "🇦🇿"
        case .bam: return "🇧🇦"
        case .bbd: return "🇧🇧"
        case .bdt: return "🇧🇩"
        case .bhd: return "🇧🇭"
        case .bif: return "🇧🇮"
        case .bmd: return "🇧🇲"
        case .bnd: return "🇧🇳"
        case .bob: return "🇧🇴"
        case .bsd: return "🇧🇸"
        case .btn: return "🇧🇹"
        case .bwp: return "🇧🇼"
        case .byn: return "🇧🇾"
        case .bzd: return "🇧🇿"
        case .cdf: return "🇨🇩"
        case .clf: return "🇨🇱"
        case .cop: return "🇨🇴"
        case .crc: return "🇨🇷"
        case .cuc: return "🇨🇺"
        case .cup: return "🇨🇺"
        case .cvd: return "🇨🇻"
        case .djf: return "🇩🇯"
        case .dzd: return "🇩🇿"
        case .egp: return "🇪🇬"
        case .ern: return "🇪🇷"
        case .etb: return "🇪🇹"
        case .fjd: return "🇫🇯"
        case .fkp: return "🇫🇰"
        case .gel: return "🇬🇪"
        case .gjd: return "🇬🇩"
        case .gmd: return "🇬🇲"
        case .gnf: return "🇬🇳"
        case .grr: return "🇬🇷"
        case .gtq: return "🇬🇹"
        case .gwp: return "🇬🇼"
        case .ils: return "🇮🇱"
        case .imp: return "🇮🇲"
        case .iqd: return "🇮🇶"
        case .irr: return "🇮🇷"
        case .isk: return "🇮🇸"
        case .jmd: return "🇯🇲"
        case .kes: return "🇰🇪"
        case .kgs: return "🇰🇬"
        case .khr: return "🇰🇭"
        case .kmf: return "🇰🇲"
        case .kpw: return "🇰🇵"
        case .krw: return "🇰🇷"
        case .kwd: return "🇰🇼"
        case .kyd: return "🇰🇾"
        case .kzt: return "🇰🇿"
        case .lak: return "🇱🇰"
        case .lbp: return "🇱🇧"
        case .lrd: return "🇱🇷"
        case .lsl: return "🇱🇸"
        case .ltl: return "🇱🇹"
        case .mdl: return "🇲🇩"
        case .mga: return "🇲🇬"
        case .mkd: return "🇲🇰"
        case .mmk: return "🇲🇲"
        case .mop: return "🇲🇴"
        case .mro: return "🇲🇷"
        case .mru: return "🇲🇷"
        case .mtl: return "🇲🇹"
        case .mtn: return "🇲🇹"
        case .mur: return "🇲🇺"
        case .nad: return "🇳🇦"
        case .ngn: return "🇳🇬"
        case .nio: return "🇳🇮"
        case .npr: return "🇳🇵"
        case .omr: return "🇴🇲"
        case .pab: return "🇵🇦"
        case .pen: return "🇵🇪"
        case .pgk: return "🇵🇬"
        case .pyg: return "🇵🇾"
        case .qar: return "🇶🇦"
        case .rsd: return "🇷🇸"
        case .rub: return "🇷🇺"
        case .rwf: return "🇷🇼"
        case .sbd: return "🇸🇧"
        case .scr: return "🇸🇨"
        case .sdg: return "🇸🇩"
        case .shp: return "🇱🇸"
        case .sll: return "🇸🇱"
        case .sos: return "🇸🇴"
        case .srd: return "🇸🇷"
        case .szl: return "🇸🇿"
        case .tjs: return "🇹🇯"
        case .tmt: return "🇹🇲"
        case .tnd: return "🇹🇳"
        case .top: return "🇹🇴"
        case .trylira: return "🇹🇷"
        case .twd: return "🇹🇼"
        case .tzs: return "🇹🇿"
        case .ugx: return "🇺🇬"
        case .uyu: return "🇺🇾"
        case .uzs: return "🇺🇿"
        case .vuv: return "🇻🇺"
        case .wst: return "🇼🇸"
        case .xaf: return "🇪🇺"
        case .xag: return "🇪🇺"
        case .xau: return "🇪🇺"
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
