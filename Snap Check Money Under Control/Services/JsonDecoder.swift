import Foundation


class JsonDecoder {
    func decodeExpenses<T: Codable>(_ data: Data) -> [T]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([T].self, from: data)
            return decodedData
        } catch {
            NSLog("Ошибка декодирования: \(error)")
            return nil
        }
    }
    
    static func cleanJSON(_ data: Data) -> Data? {
            // Преобразуем Data в строку
            guard let text = String(data: data, encoding: .utf8) else {
                return nil
            }
            
            var cleanedText = text
            
            // Убираем "```json" и "```" с обеих сторон
            if let jsonRange = cleanedText.range(of: "```json") {
                cleanedText.removeSubrange(jsonRange) // Удаляем "```json"
                NSLog("'''json deleted 🤌")
            }
            
            if let endRange = cleanedText.range(of: "```", options: .backwards) {
                cleanedText.removeSubrange(endRange) // Удаляем последнее "```"
                NSLog("''' deleted 🤌")

            }
            
            // Убираем лишние пробелы и переносы строк
            cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Преобразуем очищенную строку обратно в Data и возвращаем
            return cleanedText.data(using: .utf8)
        }
}


