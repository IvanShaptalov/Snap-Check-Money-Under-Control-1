import Foundation


class Assing {
    static func number(_ to: inout Int, _ from: Int?) {
        guard let from = from else {
            return
        }
        
        to = from
        NSLog("assined value: \(to)")
    }
    
    static func string(_ to: inout String,_ from: String?) {
        guard let from = from, !from.isEmpty else {
            NSLog("Parsed string nil - leave old: \(to)")
            return
        }
        to = from
        NSLog("assined value: \(to)")
    }
    
    static func list(_ to: inout [String],_ from: String?) {
        guard let from = from else {
            NSLog("Parsed list nil, leave old: \(to)")
            return
        }
        
        let splitted = from.components(separatedBy: ",")
        
        guard !splitted.isEmpty else {
            NSLog("Parsed list empty, leave old: \(to)")
            return
        }
        NSLog("assined value: \(to)")
        to = splitted
    }
    
    static func url(_ to: inout URL,_ from: String?) {
        guard let from = from else {
            NSLog("🔗 link not provided, old value: \(to.absoluteString)")
            return
        }
        guard let newUrl = URL.init(string: from) else {
            NSLog("🔗 link could not be created, old value: \(to.absoluteString)")
            return
        }
        to = newUrl
        NSLog("assined value: \(newUrl)")
    }
}
