import SwiftUI


// ViewModel для ExportView
class ExportViewModel: ObservableObject {
    @Published var showActionSheet = false
    @Published var showDateSelectionSheet = false
    @Published var showCategorySelectionSheet = false
    @Published var reportName: String = ""
    @Published var selectedSortType: ExportSortType = .items
    @Published var selectedCategories: [String] = AppConfig.getBasicCategories()
    @Published var startDate: Date = {
        let calendar = Calendar.current
        let currentDate = Date()
        // Получаем первое число текущего месяца
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        return firstDayOfMonth
    }()
    @Published var endDate: Date = Date()

    var categories: [String] {
        AppConfig.getBasicCategories()
    }

    func toggleCategory(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }

    // Метод для установки диапазона дат по пресету
    func setDatePreset(_ preset: DatePreset) {
        let calendar = Calendar.current
        let now = Date()

        switch preset {
        case .thisWeek:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            startDate = startOfWeek
            endDate = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        case .thisMonth:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
            endDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        case .thisYear:
            startDate = calendar.date(from: calendar.dateComponents([.year], from: now))!
            endDate = calendar.date(byAdding: .year, value: 1, to: startDate)!
            endDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        case .lastWeek:
            if let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: now),
               let lastWeekEnd = calendar.date(byAdding: .day, value: 6, to: lastWeekStart) {
                startDate = calendar.startOfDay(for: lastWeekStart)
                endDate = calendar.startOfDay(for: lastWeekEnd)
            }
        case .lastMonth:
            if let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) {
                startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: lastMonth))!
                endDate = calendar.date(byAdding: .day, value: -1, to: calendar.date(from: calendar.dateComponents([.year, .month], from: now))!)!
            }
        case .lastQuarter:
            let currentMonth = calendar.component(.month, from: now)
            let quarter = (currentMonth - 1) / 3 + 1
            let lastQuarter = quarter - 1
            let year = calendar.component(.year, from: now) - (lastQuarter == 0 ? 1 : 0)
            let quarterStartMonth = (lastQuarter == 0 ? 9 : (lastQuarter - 1) * 3 + 1)
            let startOfLastQuarter = calendar.date(from: DateComponents(year: year, month: quarterStartMonth))!
            startDate = startOfLastQuarter
            endDate = calendar.date(byAdding: .month, value: 3, to: startOfLastQuarter)!
            endDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        case .lastYear:
            startDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: now) - 1))!
            endDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: now)))!
            endDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        case .all:
            startDate = Date.distantPast
            endDate = Date.distantFuture
        }
    }
}

// Перечисление для пресетов дат
enum DatePreset: String, CaseIterable {
    case all = "All"
    case lastYear = "Last Year"
    case lastQuarter = "Last Quarter"
    case lastMonth = "Last Month"
    case thisYear = "This Year"
    case thisMonth = "This Month"
    case lastWeek = "Last Week"
    case thisWeek = "This Week"
}
