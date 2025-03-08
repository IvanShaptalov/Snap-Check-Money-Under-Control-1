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
            // Convert expenses to JSON format
            
            // Create filename with the specified format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM_dd_yyyy" // Format: month_day_year
            let dateStr = dateFormatter.string(from: expenseExport.reportStartDate)
            let fileName = "\(expenseExport.reportName)_\(dateStr)"
            var targetUrl: URL?
            // Switch based on the desired export format
            
            let numbersManager = JsonToNumbersManager()
            guard let numbersData = numbersManager.convertExpensesToNumbers(expenses: expenses, expenseExport: expenseExport) else {
                throw ExportErrors.failedToConvertData
            }
            guard let numbersURL = numbersManager.saveNumbersFile(data: numbersData, fileName: fileName) else {
                throw ExportErrors.failedToSaveData
            }
            targetUrl = numbersURL
            
            print("Numbers file saved at: \(numbersURL)")
            
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
    func fetchExpensesFromDatabase(context: ModelContext) throws -> [ExpenseData] {
        return try ExpenseDataManager().fetchExpenses(from: expenseExport.reportStartDate,
                                                      to: expenseExport.reportFinishDate,
                                                      context: context)
    }
}
