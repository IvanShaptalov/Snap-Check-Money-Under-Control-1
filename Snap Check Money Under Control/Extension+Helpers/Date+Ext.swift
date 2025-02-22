//
//  DateExtension.swift
//  visionToText
//
//  Created by PowerMac on 04.11.2024.
//

import Foundation


// Функция форматирования даты
extension Date {
    private var calendar: Calendar { Calendar.current }
    
    // Форматирование даты для отображения в списке
    func formattedForExpenseList() -> String {
        let formatter = DateFormatter()
        let components = calendar.dateComponents([.day], from: self)
        
        if components.day == 1 {
            formatter.dateFormat = "MMMM, d" // Первое число месяца
        } else {
            formatter.dateFormat = "E, d" // Обычные дни
        }
        return formatter.string(from: self)
    }
    
    // Проверка, является ли дата выходным
    var isWeekend: Bool {
        calendar.isDateInWeekend(self)
    }
    
    static func currentYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }
    
    /// Функция проверяет, является ли переданная дата будущей.
    /// Если дата в будущем, она заменяется на текущий момент.
    /// В противном случае возвращается без изменений.
    func changeFromFutureToNow(_ date: Date) -> Date {
        let now = Date()
        return date > now ? now : date
    }
    
    /// Функция проверяет, является ли переданная дата будущей.
    /// Если дата в будущем, она заменяется на текущий момент.
    /// В противном случае возвращается без изменений.
    func changeFromFutureToNow() -> Date {
        let now = Date()
        return self > now ? now : self
    }
}
