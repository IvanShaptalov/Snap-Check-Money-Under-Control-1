//
//  ExpenseManagerViewModel.swift
//  visionToText
//
//  Created by PowerMac on 04.11.2024.
//

import Foundation
import SwiftData
import Foundation
import SwiftUI

class ExpenseManagerViewModel: ObservableObject {
    private let expenseManager = ExpenseDataManager()
    
    enum ExpenseDateRange {
        case all
        case currentMonth
        case currentYear
    }

    func loadExpenses(modelContext: ModelContext, dateRange: ExpenseDateRange) -> [ExpenseData] {
        let calendar = Calendar.current
        let startDate: Date
        let endDate = Date() // По умолчанию до текущей даты

        switch dateRange {
        case .all:
            startDate = Date.distantPast
        case .currentMonth:
            let components = calendar.dateComponents([.year, .month], from: Date())
            startDate = calendar.date(from: components) ?? Date.distantPast
        case .currentYear:
            let components = calendar.dateComponents([.year], from: Date())
            startDate = calendar.date(from: components) ?? Date.distantPast
        }

        do {
            return try expenseManager.fetchExpenses(from: startDate, to: endDate, context: modelContext)
        } catch {
            print("Ошибка загрузки расходов: \(error)")
            return []
        }
    }
    
    // Добавление или обновление расходов
    func addOrUpdateExpense(_ newExpenses: [ExpenseData], modelContext: ModelContext) {
        do {
            for expense in newExpenses {
                try expenseManager.addOrUpdateExpense(data: expense, context: modelContext)
            }
        } catch {
            print("Ошибка при добавлении или обновлении расходов: \(error)")
        }
    }
    
    // Удаление расхода по ID
    func deleteExpense(by id: String, modelContext: ModelContext) {
        do {
            try expenseManager.deleteExpense(byId: id, context: modelContext)
        } catch {
            print("Ошибка удаления расхода: \(error)")
        }
    }
}
