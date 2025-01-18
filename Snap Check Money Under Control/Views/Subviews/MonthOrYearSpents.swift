import Foundation
import SwiftUI


struct MonthOrYearSpents : View {
    @Binding var isShowYear: Bool
    var totalSpent: Double
    @Binding var currentYear: Int
    var body: some View {
        VStack {
            HStack {
                Text("Expenses \(isShowYear ? "in " + "\(AppConfig.selectedShowYear)" : "on " + DateFormatterService.getCurrentDateFormatted())")
                    .font(.title)
                    .padding()
                    .onTapGesture {
                        isShowYear.toggle() // Меняем состояние при нажатии
                        
                    }
                if isShowYear {
                    Spacer().frame(width: 10)
                    
                    HStack {
                        Button("⬅️") {
                            AppConfig.selectedShowYear -= 1
                            currentYear = AppConfig.selectedShowYear
                        }
                        
                        Spacer().frame(width: 10)
                        
                        Button("➡️") {
                            AppConfig.selectedShowYear += 1
                            currentYear = AppConfig.selectedShowYear
                        }
                    }
                        
                }
            }
            Text("Total Spent: \(totalSpent, specifier: "%.2f") \(AppConfig.mainCurrency.description)") // Отображаем общую сумму расходов
                .font(.headline)
                .padding()
        }
    }
}
