import Foundation

struct ExpenseReport: Codable {
    let store: String
    let totalPrice: Double
    let currency: String
    let items: [Item]
    let date: Date
    
    struct Item: Codable {
        let title: String
        let price: Double
        let category: String
    }
    
    // Custom date decoding to handle a specific date format
    private enum CodingKeys: String, CodingKey {
        case store, totalPrice, currency, items, date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        store = try container.decode(String.self, forKey: .store)
        totalPrice = try container.decode(Double.self, forKey: .totalPrice)
        currency = try container.decode(String.self, forKey: .currency)
        items = try container.decode([Item].self, forKey: .items)

        do {
            let dateString = try container.decode(String.self, forKey: .date)
            let dateFormatter = DateFormatter()
            
            // Set the date format according to your needs
            dateFormatter.dateFormat = AppConfig.dateFormat
            
            // Try to decode the date
            if let decodedDate = dateFormatter.date(from: dateString) {
                date = decodedDate
            } else {
                // If the date string is invalid, use the current date
                date = Date()
            }
        } catch {
            // In case of any error, default to current date
            date = Date()
        }
    }
}
