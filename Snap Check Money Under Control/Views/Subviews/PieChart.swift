//
//  PieChart.swift
//  visionToText
//
//  Created by PowerMac on 02.11.2024.
//

import SwiftUI
import Charts


struct PieChart: View {
    let expenses: [ExpenseData]
    
    var body: some View {
        // Group expenses by category
        let groupedExpenses = Dictionary(grouping: expenses, by: { $0.category })
        
        // Create an array of totals for each category
        let categoryExpenses = groupedExpenses.map { (category, expenses) in
            let totalAmount = expenses.reduce(0) { $0 + $1.amount }
            // Use Date() for the current date or any specific date you want
            return ExpenseData(title: category, date: Date(), amount: totalAmount, currency: .usd, category: category)
        }
        
        return Chart(categoryExpenses) { expense in
            SectorMark(
                angle: .value("Amount", expense.amount),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .foregroundStyle(by: .value("category", expense.category))
            .annotation(position: .overlay) {
                VStack(spacing: 4) {
                    Text("\(String(format: "%.2f", expense.amount))")
                        .foregroundColor(.white)
                        .font(.caption2)
                        .fontWeight(.regular)
                }
                .padding(4)
                .background(Color.black.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}
let mockexpenses = [
    ExpenseData(title: "Burger", date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 12, hour: 18, minute: 30))!, amount: 6.7, currency: .usd, category: "Groceries"),
    ExpenseData(title: "Pastrami", date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 11, hour: 12, minute: 30))!, amount: 10.0, currency: .usd, category: "Groceries"),
    ExpenseData(title: "Coffee", date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 10, hour: 10, minute: 0))!, amount: 5.0, currency: .usd, category: "Drinks"),
    ExpenseData(title: "Beer", date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 9, hour: 20, minute: 0))!, amount: 7.5, currency: .usd, category: "Drinks")
]
#Preview {
    PieChart(expenses: mockexpenses)
}
