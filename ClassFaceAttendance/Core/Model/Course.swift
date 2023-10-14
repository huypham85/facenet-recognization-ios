//
//  Course.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 08/10/2023.
//

import Foundation

struct Course {
    var name: String
    var id: String
    var numberCredits: Int
    var teacherId: String
    var students: [MiniStudent]
    var sessions: [MiniSession]

    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let numberCredits = dictionary["numberCredits"] as? Int,
            let teacherId = dictionary["teacherId"] as? String,
            let studentsDict = dictionary["students"] as? [String: [String: Any]],
            let sessionsDict = dictionary["sessions"] as? [String: [String: Int]]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.numberCredits = numberCredits
        self.teacherId = teacherId

        // Parse students
        var students = [MiniStudent]()
        for (_, studentData) in studentsDict {
            if let student = MiniStudent(dictionary: studentData) {
                students.append(student)
            }
        }
        self.students = students

        // Parse sessions
        var sessions = [MiniSession]()
        for (sessionDate, sessionData) in sessionsDict {
            if let session = MiniSession(dictionary: sessionData, date: sessionDate) {
                sessions.append(session)
            }
        }
        self.sessions = sessions
    }
}
