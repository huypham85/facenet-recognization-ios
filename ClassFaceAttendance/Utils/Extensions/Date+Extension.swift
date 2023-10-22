//
//  Date+Extension.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 10/10/2023.
//

import Foundation

extension Date {
    func toDateString() -> String {
        calendar.timeZone = timeZone ?? .current
        let dateComponents = calendar.dateComponents(in: timeZone ?? .current, from: self)

        if let day = dateComponents.day,
           let month = dateComponents.month,
           let year = dateComponents.year {
            let dateString = "\(year)-\(month)-\(day)"
            return dateString
        } else {
            return ""
        }
    }
    
    func toString(withFormat format: String? = "yyyy/MM/dd HH:mm") -> String {
        let dateFormat = DateFormatter()
        dateFormat.calendar = Calendar(identifier: .gregorian)
        dateFormat.dateFormat = format
        return dateFormat.string(from: self as Date)
    }
    
    func toCheckInString(withFormat format: String? = "HH:mm yyyy/MM/dd") -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "vi_VN")
        dateFormat.dateFormat = format
        return dateFormat.string(from: self as Date)
    }
    
    func toIsoString(withFormat format: String? = "yyyy-MM-dd'T'HH:mm:ss") -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US_POSIX")
        dateFormat.dateFormat = format
        return dateFormat.string(from: self as Date)
    }
    
    func isOverSessionTime(dateString: String) -> Bool {
        formatter.dateFormat = "HH:mm yyyy-MM-dd"
        if let targetDate = formatter.date(from: dateString) {
            if self > targetDate {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
