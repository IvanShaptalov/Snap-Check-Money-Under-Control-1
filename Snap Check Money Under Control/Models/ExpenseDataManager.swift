import SwiftData
import Foundation

class ExpenseDataManager {
    
    // Добавление новой записи или обновление, если запись с данным ID уже существует
    func addOrUpdateExpense(data: ExpenseData, context: ModelContext) throws {
        let descriptor = FetchDescriptor<ExpenseEntity>(predicate: #Predicate<ExpenseEntity> { $0.id == data.id })
        
        // Пытаемся найти существующую запись с тем же ID
        if let existingExpense = try context.fetch(descriptor).first {
            // Если запись существует, обновляем её данные
            existingExpense.title = data.title
            existingExpense.date = data.date
            existingExpense.amount = data.amount
            existingExpense.currencyString = data.currency.rawValue
            existingExpense.category = data.category
        } else {
            // Если запись не найдена, создаем новую
            let newExpense = ExpenseEntity(from: data)
            context.insert(newExpense)
        }
        
        try context.save()
    }
    
    // Получение записи по ID
    func fetchExpense(byId id: String, context: ModelContext) throws -> ExpenseData? {
        let descriptor = FetchDescriptor<ExpenseEntity>(predicate: #Predicate<ExpenseEntity> { $0.id == id })
        
        // Ищем запись с заданным ID и конвертируем в ExpenseData, если она найдена
        if let expense = try context.fetch(descriptor).first {
            return expense.toDataModel()
        }
        return nil // Возвращаем nil, если запись не найдена
    }
    
    // Удаление записи по ID
    func deleteExpense(byId id: String, context: ModelContext) throws {
        let descriptor = FetchDescriptor<ExpenseEntity>(predicate: #Predicate<ExpenseEntity> { $0.id == id })
        
        // Ищем запись с заданным ID и удаляем её, если найдена
        if let expense = try context.fetch(descriptor).first {
            context.delete(expense)
            try context.save()
        }
    }
    
    // Получение всех записей в определенном диапазоне дат
    func fetchExpenses(from startDate: Date, to endDate: Date, context: ModelContext) throws -> [ExpenseData] {
        let descriptor = FetchDescriptor<ExpenseEntity>(predicate: #Predicate<ExpenseEntity> { expense in
            expense.date >= startDate && expense.date <= endDate
        })
        
        // Выполняем выборку и конвертируем результаты в [ExpenseData]
        let results = try context.fetch(descriptor)
        return results.map { $0.toDataModel() }
    }
}
