import Foundation
import SwiftData


struct ExpenseData: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var date: Date
    var amount: Double
    var currency: Currency
    var category: String
}


@Model
class ExpenseEntity: Identifiable {
    @Attribute(.unique) var id: String = UUID().uuidString
    var title: String
    var date: Date
    var amount: Double
    var currencyString: String // Хранение как строку для совместимости с SwiftData
    var category: String

    init(from data: ExpenseData) {
        self.id = data.id
        self.title = data.title
        self.date = data.date
        self.amount = data.amount
        self.currencyString = data.currency.rawValue
        self.category = data.category
    }
    
    func toDataModel() -> ExpenseData {
        return ExpenseData(
            id: id,
            title: title,
            date: date,
            amount: amount,
            currency: Currency.from(string: currencyString),
            category: category
        )
    }
}
