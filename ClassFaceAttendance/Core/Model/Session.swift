//
//  Session.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 08/10/2023.
//

import Foundation

struct Session {
    var id: String
    var startTime: String
    var endTime: String
    var roomNo: String
    var courseId: String
    var courseName: String
    var teacherName: String
    var students: [String: Int]
}

extension Session {
    init?(dictionary: [String: Any]) {
        guard let courseId = dictionary["courseId"] as? String,
              let courseName = dictionary["courseName"] as? String,
              let roomNo = dictionary["roomNo"] as? String,
              let startTime = dictionary["startTime"] as? String,
              let id = dictionary["id"] as? String,
              let endTime = dictionary["endTime"] as? String,
              let students = dictionary["students"] as? [String: Int],
              let teacherName = dictionary["teacherName"] as? String else {
            return nil
        }

        self.courseId = courseId
        self.courseName = courseName
        self.roomNo = roomNo
        self.startTime = startTime
        self.id = id
        self.endTime = endTime
        self.students = students
        self.teacherName = teacherName
    }
}
