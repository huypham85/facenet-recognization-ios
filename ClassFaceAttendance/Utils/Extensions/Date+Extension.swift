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
}
