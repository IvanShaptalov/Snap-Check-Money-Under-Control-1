import Foundation
import SwiftUI


struct MonthOrYearSpents : View {
    @Binding var isShowYear: Bool
    var totalSpent: Double
    var body: some View {
        VStack {
            Text("Expenses \(isShowYear ? "in " + DateFormatterService.getCurrentYear() : "on " + DateFormatterService.getCurrentDateFormatted())")
                .font(.title)
                .padding()
                .onTapGesture {
                    isShowYear.toggle() // Меняем состояние при нажатии
                    
                }
            Text("Total Spent: \(totalSpent, specifier: "%.2f") \(AppConfig.mainCurrency.description)") // Отображаем общую сумму расходов
                .font(.headline)
                .padding()
        }
    }
}
