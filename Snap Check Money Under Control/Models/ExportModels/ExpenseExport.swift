//
//  ExpenseExport.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 17.11.2024.
//

import Foundation

// Замените ExportSortType и другие типы на ваши собственные
enum ExportSortType: String, CaseIterable {
    case category = "Category"
    case items = "Items"
}


struct ExpenseExport {
    
    ///Проверка в didSet для reportStartDate: Если reportStartDate становится больше, чем reportFinishDate, reportStartDate автоматически устанавливается равным reportFinishDate.
    ///•    Проверка в didSet для reportFinishDate: Если reportFinishDate становится меньше, чем reportStartDate, reportFinishDate автоматически устанавливается равным reportStartDate.
    ///•    В инициализаторе также есть проверка: если reportStartDate больше, чем reportFinishDate, обе даты устанавливаются равными reportFinishDate, чтобы сохранить корректность данных при создании объекта.

    
    var reportName: String
    
    var reportStartDate: Date {
        didSet {
            if reportStartDate > reportFinishDate {
                reportStartDate = reportFinishDate
            }
        }
    }
    
    var reportFinishDate: Date {
        didSet {
            if reportFinishDate < reportStartDate {
                reportFinishDate = reportStartDate
            }
        }
    }
    
    var sortType: ExportSortType
    var includedCategories: [String]
    
    init(reportName: String, reportStartDate: Date, reportFinishDate: Date, sortType: ExportSortType, includedCategories: [String]) {
        self.reportName = reportName
        // Валидируем даты в инициализаторе
        if reportStartDate > reportFinishDate {
            self.reportStartDate = reportFinishDate
            self.reportFinishDate = reportFinishDate
        } else {
            self.reportStartDate = reportStartDate
            self.reportFinishDate = reportFinishDate
        }
        self.sortType = sortType
        self.includedCategories = includedCategories
    }
}
