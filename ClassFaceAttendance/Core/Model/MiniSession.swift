//
//  MiniSession.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 14/10/2023.
//

import Foundation

struct MiniSession {
    var sessionId: String
    var date: String
    
    init?(sessionId: String, date: String) {
        self.sessionId = sessionId
        self.date = date
    }
}
