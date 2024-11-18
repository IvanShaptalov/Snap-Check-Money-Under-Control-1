//
//  JsonConverters.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 18.11.2024.
//

import Foundation


// MARK: - JsonToNumbersManager
class JsonToNumbersManager {
    
    func convertJsonToNumbers(json: [String: Any]) -> Data? {
        // Conversion logic for Numbers format
        // Placeholder: You need to implement the actual conversion logic
        return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
    
    func saveNumbersFile(data: Data, fileName: String) -> URL? {
        return saveFile(data: data, fileName: fileName, fileExtension: "numbers")
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

// MARK: - JsonToExcelManager
class JsonToExcelManager {
    
    func convertJsonToExcel(json: [String: Any]) -> Data? {
        // Conversion logic for Excel format
        // Placeholder: You need to implement the actual conversion logic
        return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
    
    func saveExcelFile(data: Data, fileName: String) -> URL? {
        return saveFile(data: data, fileName: fileName, fileExtension: "xlsx")
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

// MARK: - JsonToPDFManager
class JsonToPDFManager {
    
    func convertJsonToPDF(json: [String: Any]) -> Data? {
        // Conversion logic for PDF format
        // Placeholder: You need to implement the actual conversion logic
        // For a real PDF conversion, you may need to use PDF generation libraries
        return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
    
    func savePDFFile(data: Data, fileName: String) -> URL? {
        return saveFile(data: data, fileName: fileName, fileExtension: "pdf")
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
