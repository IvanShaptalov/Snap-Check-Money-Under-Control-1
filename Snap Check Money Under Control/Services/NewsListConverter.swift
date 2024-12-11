//
//  NewsListConverter.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 11.12.2024.
//

import Foundation


func convertToNewsItems(from strings: [String]) -> [(String, String?)] {
    var result: [(String, String?)] = []
    
    for i in stride(from: 0, to: strings.count, by: 2) {
        let text = strings[i] // Текст новости (нечетный элемент)
        let linkString = (i + 1 < strings.count) ? strings[i + 1] : nil
        
        // Проверка, если ссылка корректная
        let link = linkString.flatMap { URL(string: $0) } // Если ссылка невалидная, вернётся nil
        
        result.append((text, link?.absoluteString)) // Добавляем ссылку как строку, если она валидна
    }
    
    return result
}
