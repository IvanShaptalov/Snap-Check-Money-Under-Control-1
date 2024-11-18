import CoreXLSX
import Foundation
import CoreGraphics
import UIKit



// MARK: - JsonToNumbersManager
class JsonToNumbersManager {
    
    func convertJsonToNumbers(json: [String: Any], sortType: ExportSortType) -> Data? {
        // Проверка, что JSON имеет правильную структуру для конвертации
        print(json)
        guard let months = json["months"] as? [String: Any] else {
            print("Invalid JSON structure.")
            return nil
        }
        
        // Создаем заголовки CSV
        let headers = ["Month", "Year", "Category", "Item ID", "Date", "Item Name", "Expense Amount", "Currency"]
        
        // Создаем строку с заголовками
        var csvString = headers.joined(separator: ",") + "\n"
        
        var totalExpenseAllMonths: Double = 0.0
        
        // Перебираем каждый месяц
        for (month, monthData) in months {
            guard let monthDict = monthData as? [String: Any],
                  let categories = monthDict["categories"] as? [[String: Any]] else {
                continue
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            let monthDate = dateFormatter.date(from: month)
            let monthYearString = dateFormatter.string(from: monthDate ?? Date())
            
            var totalExpenseForMonth: Double = 0.0 // Для каждого месяца

            // Перебираем все категории в месяце
            for category in categories {
                guard let categoryName = category["category_name"] as? String,
                      let items = category["items"] as? [[String: Any]] else {
                    continue
                }
                
                var categoryTotalExpense: Double = 0.0 // Для каждой категории
                
                // Сортировка по элементам (items)
                if sortType == .items {
                    for item in items {
                        guard let itemId = item["item_id"] as? String,
                              let itemDate = item["date"] as? String,
                              let itemName = item["item_name"] as? String,
                              let expenseAmount = item["expense_amount"] as? Double,
                              let currency = item["currency"] as? String else {
                            continue
                        }
                        
                        // Строка для каждого элемента
                        let row = [
                            monthYearString,  // Месяц и год
                            categoryName,     // Категория
                            itemId,           // ID элемента
                            itemDate,         // Дата
                            itemName,         // Название элемента
                            "\(expenseAmount)",// Сумма
                            currency          // Валюта
                        ]
                        
                        // Добавляем строку в CSV
                        csvString += row.joined(separator: ",") + "\n"
                        
                        // Добавляем сумму для категории
                        categoryTotalExpense += expenseAmount
                        totalExpenseForMonth += expenseAmount
                        totalExpenseAllMonths += expenseAmount
                    }
                }
                
                // Сортировка по категориям (categories)
                if sortType == .category {
                    // Для категории total записываем только сумму всех элементов
                    let categoryTotalRow = [
                        monthYearString, // Месяц и год
                        categoryName,    // Категория
                        "total",         // Тотал
                        "",              // ID элемента
                        "",              // Дата
                        "",              // Название элемента
                        "\(categoryTotalExpense)", // Сумма
                        ""               // Валюта
                    ]
                    
                    // Добавляем строку для total категории
                    csvString += categoryTotalRow.joined(separator: ",") + "\n"
                    
                    // Добавляем сумму категории к общей сумме месяца
                    totalExpenseForMonth += categoryTotalExpense
                }
            }
            
            // Добавляем строку для общего итога по месяцу
            let monthTotalRow = [
                monthYearString,  // Месяц и год
                "Total",          // Тотал
                "",               // Категория
                "",               // ID элемента
                "",               // Дата
                "",               // Название элемента
                "\(totalExpenseForMonth)", // Сумма
                ""                // Валюта
            ]
            
            csvString += monthTotalRow.joined(separator: ",") + "\n"
        }
        
        // Добавляем общий итог по всем месяцам в конце
        let allMonthsTotalRow = [
            "All months",     // Название для всех месяцев
            "Total",          // Тотал
            "",               // Категория
            "",               // ID элемента
            "",               // Дата
            "",               // Название элемента
            "\(totalExpenseAllMonths)", // Общая сумма
            ""                // Валюта
        ]
        
        csvString += allMonthsTotalRow.joined(separator: ",") + "\n"
        
        // Преобразуем строку CSV в Data
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
