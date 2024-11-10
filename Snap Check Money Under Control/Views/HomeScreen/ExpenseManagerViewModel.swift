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
    
    private func addTutorialExpenses(modelContext: ModelContext) {
        if UserOnboarder.isOnboarded() {
            // Пользователь уже прошел онбординг, не добавляем учебные расходы
        } else {
            // Добавляем учебные расходы
            let tutorialExpenses: [ExpenseData] = [
                ExpenseData(title: "1. use + to snap check", date: Date().addingTimeInterval(-20400), amount: 4, currency: AppConfig.mainCurrency, category: "Snap"),
                ExpenseData(title: "2. tap expense for editing", date: Date().addingTimeInterval(-86400), amount: 3, currency: AppConfig.mainCurrency, category: "Edit"),
                ExpenseData(title: "3. use share menu for export", date: Date().addingTimeInterval(-86400 * 2), amount: 2, currency: AppConfig.mainCurrency, category: "Export"),
                ExpenseData(title: "4. swipe left to remove something", date: Date().addingTimeInterval(-86400 * 3), amount: 1, currency: AppConfig.mainCurrency, category: "Remove"),
                ExpenseData(title: "6. enjoy 😋", date: Date().addingTimeInterval(-86400 * 5), amount: 4, currency: AppConfig.mainCurrency, category: "Enjoy"),
                ExpenseData(title: "5. set your categories in settings ⚙️", date: Date().addingTimeInterval(-86400 * 4), amount: 4, currency: AppConfig.mainCurrency, category: "Customize"),
                ExpenseData(title: "ps. tap twice Expenses in \(DateFormatterService.getCurrentYear()) 😉", date: Date().addingTimeInterval(-86400 * 6), amount: 1, currency: AppConfig.mainCurrency, category: "Tutorial"),
            ]
            addOrUpdateExpense(tutorialExpenses, modelContext: modelContext)
            UserOnboarder.setOnboarded()
        }
    }
    
    func loadExpenses(modelContext: ModelContext, dateRange: ExpenseDateRange) -> [ExpenseData] {
        let calendar = Calendar.current
        let startDate: Date
        let endDate = Date() // По умолчанию до текущей даты
        addTutorialExpenses(modelContext: modelContext)
        
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
