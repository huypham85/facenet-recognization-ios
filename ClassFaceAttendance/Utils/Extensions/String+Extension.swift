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
            print("Formatted Time in Vietnam: \(formattedTime)")
        } else {
            return nil
        }
    }
}
