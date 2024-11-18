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
        if UserOnboarder.isTutorialOnboarded() {
            // Пользователь уже прошел онбординг, не добавляем учебные расходы
        } else {
            // Добавляем учебные расходы
            let tutorialExpenses: [ExpenseData] = [
                ExpenseData(title: "1. + for to Snap Check", date: Date().addingTimeInterval(-20400), amount: 4, currency: AppConfig.mainCurrency, category: "Clothes"),
                ExpenseData(title: "2. tap Expense for Editing", date: Date().addingTimeInterval(-86400), amount: 3, currency: AppConfig.mainCurrency, category: "Drinks"),
                ExpenseData(title: "3. swipe left to Remove Expense", date: Date().addingTimeInterval(-86400 * 3), amount: 1, currency: AppConfig.mainCurrency, category: "Rent"),
                ExpenseData(title: "ps. tap twice Expenses in \(DateFormatterService.getCurrentYear()) 😉", date: Date().addingTimeInterval(-86400 * 6), amount: 1, currency: AppConfig.mainCurrency, category: "Groceries"),
                ExpenseData(title: "Two view formats: Year, Month", date: Date().addingTimeInterval(-86400 * 32), amount: 1, currency: AppConfig.mainCurrency, category: "Groceries"),
            ]
            addOrUpdateExpense(tutorialExpenses, modelContext: modelContext)
            UserOnboarder.setTutorialOnboarded()
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
            NSLog("Ошибка загрузки расходов: \(error)")
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
            NSLog("Ошибка при добавлении или обновлении расходов: \(error)")
        }
    }
    
    // Удаление расхода по ID
    func deleteExpense(by id: String, modelContext: ModelContext) {
        do {
            try expenseManager.deleteExpense(byId: id, context: modelContext)
        } catch {
            NSLog("Ошибка удаления расхода: \(error)")
        }
    }
}
