//
//  Date+Extensions.swift
//  DailyApp
//
//  Created by Ebrar Gül on 21.06.2024.
//

/*import Foundation

extension Date {
    
    func toDayFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func toReadableFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func toReadableFormatWithoutYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}
*/
