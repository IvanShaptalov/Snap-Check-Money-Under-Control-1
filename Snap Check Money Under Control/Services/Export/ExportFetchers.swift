//
//  ExportFetchers.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 18.11.2024.
//

import Foundation
import SwiftData

enum ExportErrors: Error {
    case failedToConvertData
    case failedToSaveData
    case unknownError
}


protocol ExporterProtocol {
    var expenseExport: ExpenseExport { get }
    func export(context: ModelContext) throws -> URL?
}


// NumbersExporter implementation
class ExpenseExportManager: ExporterProtocol {
  
    var expenseExport: ExpenseExport

    init(expenseExport: ExpenseExport) {
        self.expenseExport = expenseExport
    }

    // Method to export data
    func export(context: ModelContext) throws -> URL? {
        // Fetch expenses from the database
        do {
            let expenses = try fetchExpensesFromDatabase(context: context)
            
            // Sort expenses by date
            let sortedExpenses = expenses.sorted { $0.date < $1.date }
            
            // Convert expenses to JSON format
            let jsonExpenses = convertExpensesToJSON(sortedExpenses)
            
            // Create filename with the specified format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM_dd_yyyy" // Format: month_day_year
            let dateStr = dateFormatter.string(from: Date())
            let fileName = "\(expenseExport.reportName)_\(dateStr)"
            var targetUrl: URL?
            // Switch based on the desired export format
            switch expenseExport.exportFormat {
            case .pdf:
                let pdfManager = JsonToPDFManager()
                guard let pdfData = pdfManager.convertJsonToPDF(json: jsonExpenses) else {
                    throw ExportErrors.failedToConvertData
                }
                guard let pdfURL = pdfManager.savePDFFile(data: pdfData, fileName: fileName) else {
                    throw ExportErrors.failedToSaveData
                }
                targetUrl = pdfURL
                print("PDF file saved at: \(pdfURL)")
                
            case .numbers:
                let numbersManager = JsonToNumbersManager()
                guard let numbersData = numbersManager.convertJsonToNumbers(json: jsonExpenses) else {
                    throw ExportErrors.failedToConvertData
                }
                guard let numbersURL = numbersManager.saveNumbersFile(data: numbersData, fileName: fileName) else {
                    throw ExportErrors.failedToSaveData
                }
                targetUrl = numbersURL

                print("Numbers file saved at: \(numbersURL)")
                
            case .excel:
                let csvManager = JsonToExcelManager()
                guard let csvData = csvManager.convertJsonToExcel(json: jsonExpenses) else {
                    throw ExportErrors.failedToConvertData
                }
                guard let csvURL = csvManager.saveExcelFile(data: csvData, fileName: fileName) else {
                    throw ExportErrors.failedToSaveData
                }
                targetUrl = csvURL

                print("CSV file saved at: \(csvURL)")
            }
            return targetUrl
            
        } catch ExportErrors.failedToConvertData {
            throw ExportErrors.failedToConvertData
        } catch ExportErrors.failedToSaveData {
            throw ExportErrors.failedToSaveData
        } catch {
            print("Unknown error: \(error)")
            throw ExportErrors.unknownError
        }
        
    }

    // Method to fetch expenses in a given date range
    private func fetchExpensesFromDatabase(context: ModelContext) throws -> [ExpenseData] {
        return try ExpenseDataManager().fetchExpenses(from: expenseExport.reportStartDate,
                                                      to: expenseExport.reportFinishDate,
                                                      context: context)
    }

    // Method to convert expenses to JSON
    private func convertExpensesToJSON(_ expenses: [ExpenseData]) -> [String: Any] {
        var totalExpense = 0.0
        let currency = expenses.first?.currency.rawValue ?? "USD"
        var months: [String: Any] = [:]
        
        // Group expenses by month
        let groupedByMonth = Dictionary(grouping: expenses) { (expense) -> String in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM" // Month name
            return formatter.string(from: expense.date)
        }

        for (month, expensesInMonth) in groupedByMonth {
            var monthTotalExpense = 0.0
            var categories: [[String: Any]] = []
            
            // Group expenses by category
            let groupedByCategory = Dictionary(grouping: expensesInMonth) { $0.category }
            
            for (category, items) in groupedByCategory {
                var categoryTotalExpense = 0.0
                var itemsArray: [[String: Any]] = []
                
                if expenseExport.sortType == .items {
                    // Sort items by amount if needed
                    itemsArray = items.map {
                        categoryTotalExpense += $0.amount
                        return [
                            "item_id": UUID().uuidString,
                            "date": ISO8601DateFormatter().string(from: $0.date),
                            "item_name": $0.title,
                            "expense_amount": $0.amount,
                            "currency": $0.currency
                        ]
                    }
                }
                
                monthTotalExpense += categoryTotalExpense
                categories.append([
                    "category_name": category,
                    "items": itemsArray,
                    "total_category_price": categoryTotalExpense
                ])
            }
            
            totalExpense += monthTotalExpense
            months[month.lowercased()] = [
                "categories": categories,
                "total_expense": monthTotalExpense
            ]
        }

        return [
            "total_expense": totalExpense,
            "currency": currency,
            "months": months
        ]
    }
}
