//
//  CategoryView.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 18.01.2025.
//

import SwiftUI

struct CategoryView: View {
    let expenses: [ExpenseData] // Массив всех расходов
    
    var body: some View {
        // Группировка расходов по категориям
        let groupedExpenses = Dictionary(grouping: expenses, by: { $0.category })
        
        // Создание массива с суммами по категориям
        let categoryExpenses = groupedExpenses.map { (category, expenses) in
            let totalAmount = expenses.reduce(0) { $0 + $1.amount } // Сумма расходов в категории
            return (category: category, totalAmount: totalAmount) // Возвращаем пару: категория и сумма
        }
        
        // Построение представления
        return ScrollView(.horizontal, showsIndicators: false) { // Горизонтальный скролл
            HStack(spacing: 16) { // Ряд с категориями
                ForEach(categoryExpenses, id: \.category) { categoryExpense in
                    CategoryCell(
                        title: categoryExpense.category,
                        amount: categoryExpense.totalAmount
                    )
                }
            }
            .padding()
        }
    }
}



struct CategoryCell: View {
    var title: String // Название категории
    var amount: Double // Сумма категории
    
    var body: some View {
        VStack {
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray) // Цвет для текста сверху
                .padding(.top, 8) // Отступ сверху
            
            Spacer() // Добавляем гибкий отступ между текстом и суммой
            
            Text("\(amount, specifier: "%.0f")") // Отображение суммы
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer() // Гибкий отступ снизу
        }
        .frame(width: 150, height: 90) // Размер ячейки
        .background(Color(.systemGray6)) // Фон ячейки
        .cornerRadius(12) // Закругленные углы
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2) // Добавляем тень
    }
}


#Preview {
    CategoryView(expenses: mockexpenses)
}
