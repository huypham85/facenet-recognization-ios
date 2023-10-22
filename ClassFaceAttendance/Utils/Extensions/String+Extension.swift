//
//  String+Extension.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 18/10/2023.
//

import Foundation

extension String {
    func convertIsoStringToHour() -> String? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        if let date = formatter.date(from: self) {
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
            let formattedTime = formatter.string(from: date)
            return formattedTime
        } else {
            return nil
        }
    }
    
    func convertIsoStringToDateHour() -> String? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        if let date = formatter.date(from: self) {
            formatter.dateFormat = "HH:mm dd/MM/yyyy"
            formatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")
            let formattedTime = formatter.string(from: date)
            return formattedTime
        } else {
            return nil
        }
    }
    
    func removeDateComponent() -> String {
        formatter.dateFormat = "HH:mm yyyy-MM-dd"

        // Parse the input string
        if let date = formatter.date(from: self) {
            // Create a new DateFormatter to extract the time component
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            // Format the date to extract the time as a string
            let timeString = timeFormatter.string(from: date)
            
            return timeString
        } else {
            return self
        }
    }
}
