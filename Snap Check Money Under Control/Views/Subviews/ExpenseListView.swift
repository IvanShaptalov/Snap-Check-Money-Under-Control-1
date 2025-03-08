import SwiftUI

struct ExpenseListView: View {
    @Binding var expenses: [ExpenseData]
    private let calendar = Calendar.current
    
    var onEditExpense: (ExpenseData) -> Void
    var onDeleteExpense: (ExpenseData) -> Void  // Добавлено замыкание для удаления
    
    var body: some View {
        List {
            ForEach(groupedExpensesByMonth.keys.sorted(by: >), id: \.self) { month in
                // Вычисляем общую сумму трат за месяц
                let totalSpent = groupedExpensesByMonth[month]?.reduce(0) { $0 + $1.amount } ?? 0.0
                
                Section(header: Text("\(monthHeader(for: month))\( AppConfig.showYearFormat ? ": \(String(format: "%.2f", totalSpent))" : "")")
                    .font(.headline)
                    .foregroundColor(.primary)) {
                        ForEach(groupedExpensesByMonth[month] ?? []) { expense in
                            ExpenseRow(expense: expense, onEdit: {
                                onEditExpense(expense)
                            })
                            .listRowBackground(Color.secondary.opacity(0.15))
                        }
                        .onDelete { offsets in
                            // Удаление элементов через замыкание onDeleteExpense
                            if let expenseList = groupedExpensesByMonth[month] {
                                for index in offsets {
                                    let expenseToRemove = expenseList[index]
                                    onDeleteExpense(expenseToRemove)
                                }
                            }
                        }
                    }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(InsetGroupedListStyle())
        
        
    }
    
    // Группируем расходы по месяцам
    private var groupedExpensesByMonth: [Date: [ExpenseData]] {
        return Dictionary(grouping: expenses) { expense in
            let components = calendar.dateComponents([.year, .month], from: expense.date)
            return calendar.date(from: components) ?? Date()
        }
    }
    
    // Возвращает заголовок для месяца
    private func monthHeader(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    // Удаление расхода по ID
    private func removeExpense(withId id: String) {
        if let index = expenses.firstIndex(where: { $0.id == id }) {
            expenses.remove(at: index)
        }
    }
}

// MARK: - Компонент строки расхода

struct ExpenseRow: View {
    let expense: ExpenseData
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)
                Text(expense.date.formattedForExpenseList())
                    .font(.caption2)
                    .foregroundColor(expense.date.isWeekend ? Color.cyan : .primary) // Выделение выходных
                    .fontWeight(.semibold)
            }
            Spacer()
            Text("\(expense.amount, specifier: "%.2f") \(expense.currency.rawValue)")
                .font(.headline)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onEdit)
    }
}
