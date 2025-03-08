import CoreXLSX
import Foundation
import CoreGraphics
import UIKit
import Collections



// MARK: - JsonToNumbersManager
class JsonToNumbersManager {
    
    func convertExpensesToNumbers(expenses: [ExpenseData], expenseExport: ExpenseExport) -> Data? {
        var data: Data?
        let includedCategories = expenseExport.includedCategories
        switch expenseExport.sortType {
        
        case .category:
            data = convertAsCategories(expenses, includedCategories: includedCategories)
        case .items:
            data = convertAsItems(expenses, includedCategories: includedCategories)
        }
        
        return data
    }
    // MARK: - AS CATEGORIES
    func convertAsCategories(_ expenses: [ExpenseData], includedCategories: [String]) -> Data? {
        let sortedExpenses = expenses.sorted(by: {$0.date > $1.date})
        // Словарь для хранения данных по месяцам и категориям
        var monthlyData: OrderedDictionary<String, OrderedDictionary<String, Double>> = [:]
 // Ключ - месяц, Значение - категории и суммы
        
        
        // Перебираем все расходы и группируем по месяцам и категориям
        for expense in sortedExpenses {
            // Получаем месяц в формате "YYYY-MM"
            let month = getMonthAndYearString(from: expense.date)
            
            // Инициализация словаря для месяца, если его еще нет
            if monthlyData[month] == nil {
                monthlyData[month] = [:]
            }
            
            // Если категория включена, добавляем сумму
            if includedCategories.contains(expense.category) {
                monthlyData[month]?[expense.category, default: 0] += expense.amount
            }
        }
        
        // Создаем заголовок с месяцем и категориями
        let header: [String] = ["Month"] + includedCategories + ["Total"]
        
        // Массив строк для таблицы, первая строка — это заголовки
        var rows: [[String: Any]] = [header.reduce(into: [:]) { $0[$1] = nil }]
        
        
        // Перебираем данные по месяцам
        for (month, categories) in monthlyData {
            var row: [String: Any] = ["Month": month]
            var total: Double = 0
            
            // Заполняем строки для каждой категории
            for category in includedCategories {
                let amount = categories[category] ?? 0
                row[category] = amount
                total += amount
            }
            
            // Добавляем сумму по всем категориям в последнюю колонку
            row["Total"] = total
            
            rows.append(row)
        }
        
        // Преобразуем строки в CSV или другой формат
        return convertRowsToData(header: header, rows: rows)
    }
    
    // MARK: - AS ITEMS
    private func convertAsItems(_ expenses: [ExpenseData], includedCategories: [String]) -> Data? {
        // Словарь для хранения данных по месяцам и расходам
        var monthlyData: [String: [ExpenseData]] = [:]
        

        // Группируем все расходы по месяцам, фильтруя по включенным категориям
        for expense in expenses {
            // Проверяем, включена ли категория
            if includedCategories.contains(expense.category) {
                // Получаем месяц в формате "MMMM"
                let month = getMonthAndYearString(from: expense.date)
                monthlyData[month, default: []].append(expense)
            }
        }

        // Создаем заголовок
        let header: [String] = ["Month", "Date", "Item", "Item Price", "Total"]

        // Массив строк для таблицы, первая строка — это заголовки
        var rows: [[String: Any]] = [header.reduce(into: [:]) { $0[$1] = "" }]
        
        let sortedMonthlyData = monthlyData.sorted { (first, second) in
            guard let firstExpenseDate = first.value.first?.date,
                  let secondExpenseDate = second.value.first?.date else {
                return false
            }
            return firstExpenseDate > secondExpenseDate
        }
        
        // Перебираем данные по месяцам
        for (month, expenses) in sortedMonthlyData {
            var total: Double = 0

            // Сортируем расходы по дате в порядке возрастания
            let sortedExpenses = expenses.sorted { $0.date > $1.date }

            // Добавляем строку с названием месяца и пустыми значениями для других столбцов
            rows.append(["Month": month, "Date": " ", "Item": " ", "Item Price": " ", "Total": " "])

            // Перебираем все расходы в этом месяце
            for expense in sortedExpenses {
                let itemDateString = getItemDateString(from: expense.date)
                let dayOfWeek = getDayOfWeek(from: expense.date)

                // Формируем строку даты и дня недели, заменяя запятые на пробелы (или любой другой символ)
                let formattedDate = "\(itemDateString) \(dayOfWeek)".replacingOccurrences(of: ",", with: " ")

                let itemRow: [String: Any] = [
                    "Month": "".replacingOccurrences(of: ",", with: " "),
                    "Date": formattedDate.replacingOccurrences(of: ",", with: " "), // Замененная строка
                    "Item": expense.title.replacingOccurrences(of: ",", with: " "),
                    "Item Price": String(format: "%.2f", expense.amount).replacingOccurrences(of: ",", with: " "),
                    "Total": "".replacingOccurrences(of: ",", with: " ")
                ]
                rows.append(itemRow)
                total += expense.amount
            }

            // Добавляем строку с итоговой суммой и пустыми значениями для других столбцов
            rows.append(["Month": "", "Date": "-", "Item": "-", "Item Price": "-", "Total": String(format: "%.2f", total)])
        }

        // Преобразуем строки в CSV или другой формат
        return convertRowsToData(header: header, rows: rows)
    }

    
    // MARK: - HELPING METHODS

    // Вспомогательная функция для получения дня недели
    private func getDayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Краткий формат дня недели, например: "Tue", "Wed"
        return formatter.string(from: date)
    }

    // Вспомогательная функция для получения дня месяца
    private func getItemDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Формат дня месяца: "10", "11", и т.д.
        return formatter.string(from: date)
    }

    // Вспомогательная функция для получения месяца и года
    private func getMonthAndYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // Формат месяца и года: "November 2024"
        return formatter.string(from: date)
    }

    
    

    func convertRowsToData(header: [String], rows: [[String: Any]]) -> Data? {
        var csvString = header.joined(separator: ",") + "\n"
        
        for row in rows {
            let rowString = header.map { key in
                if let value = row[key] as? Double {
                    return String(format: "%.2f", value)
                } else {
                    return "\(row[key] ?? "")"
                }
            }.joined(separator: ",")
            csvString.append(rowString + "\n")
        }
        
        return csvString.data(using: .utf8)
    }
    
    func saveNumbersFile(data: Data, fileName: String) -> URL? {
        return saveFile(data: data, fileName: fileName, fileExtension: "csv")
    }
    
    private func saveFile(data: Data, fileName: String, fileExtension: String) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentURL = urls.first {
            let fileURL = documentURL.appendingPathComponent("\(fileName).\(fileExtension)")
            
            do {
                try data.write(to: fileURL)
                print("\(fileExtension.capitalized) file saved successfully at \(fileURL)")
                return fileURL
            } catch {
                print("Failed to save \(fileExtension.capitalized) file: \(error)")
            }
        }
        return nil
    }
}
