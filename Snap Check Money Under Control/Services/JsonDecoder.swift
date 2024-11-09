import Foundation


class JsonDecoder {
    func decodeExpenses<T: Codable>(_ data: Data) -> [T]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([T].self, from: data)
            return decodedData
        } catch {
            print("Ошибка декодирования: \(error)")
            return nil
        }
    }
}


