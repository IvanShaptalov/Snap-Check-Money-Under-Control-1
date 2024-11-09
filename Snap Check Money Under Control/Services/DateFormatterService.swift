import Foundation


class DateFormatterService {
    
    static func getCurrentDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Set the desired format
        let currentDate = Date.now // Get the current date
        return dateFormatter.string(from: currentDate) // Format the date
    }
    
    static func getCurrentYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy" // Set the desired format
        let currentDate = Date.now // Get the current date
        return dateFormatter.string(from: currentDate) // Format the date
    }
}
