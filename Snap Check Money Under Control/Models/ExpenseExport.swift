//
//  ExpenseExport.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 17.11.2024.
//

import Foundation

enum ExportSortType {
    case item,
    category
}

enum ExportFormat {
    case pdf,
    numbers,
    csv
}


struct ExpenseExport {
    var reportName: String
    var reportStartDate: Date
    var reportFinishDate: Date
    var sortType: ExportSortType
    var exportFormat: ExportFormat
    
    var includedCategories: [String]
}
