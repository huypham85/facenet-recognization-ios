//
//  MiniSession.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 14/10/2023.
//

import Foundation

struct MiniSession {
    var name: String
    var date: String
    
    init?(dictionary: [String: Any], date: String) {
        guard
            let name = dictionary["name"] as? String
        else {
            return nil
        }
        self.name = name
        self.date = date
    }
}
