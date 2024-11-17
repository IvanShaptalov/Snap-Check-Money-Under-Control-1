import SwiftUI


// ViewModel для ExportView
class ExportViewModel: ObservableObject {
    @Published var showActionSheet = false
    @Published var showDateSelectionSheet = false
    @Published var showCategorySelectionSheet = false
    @Published var reportName: String = ""
    @Published var selectedSortType: ExportSortType = .date
    @Published var selectedCategories: [String] = AppConfig.getBasicCategories()
    @Published var startDate: Date = Date()
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
        case .lastWeek:
            if let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: now),
               let lastWeekEnd = calendar.date(byAdding: .day, value: 6, to: lastWeekStart) {
                startDate = calendar.startOfDay(for: lastWeekStart)
                endDate = calendar.startOfDay(for: lastWeekEnd)
            }
        case .thisWeek:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            startDate = startOfWeek
            endDate = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        case .lastMonth:
            if let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) {
                startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: lastMonth))!
                endDate = calendar.date(byAdding: .day, value: -1, to: calendar.date(from: calendar.dateComponents([.year, .month], from: now))!)!
            }
        case .thisMonth:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
            endDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        case .thisQuarter:
            let currentMonth = calendar.component(.month, from: now)
            let quarter = (currentMonth - 1) / 3 + 1
            let quarterStartMonth = (quarter - 1) * 3 + 1
            let startOfQuarter = calendar.date(from: DateComponents(year: calendar.component(.year, from: now), month: quarterStartMonth))!
            startDate = startOfQuarter
            endDate = calendar.date(byAdding: .month, value: 3, to: startOfQuarter)!
            endDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        }
    }
}

// Перечисление для пресетов дат
enum DatePreset: String, CaseIterable {
    case lastWeek = "Last Week"
    case thisWeek = "This Week"
    case lastMonth = "Last Month"
    case thisMonth = "This Month"
    case thisQuarter = "This Quarter"
}
