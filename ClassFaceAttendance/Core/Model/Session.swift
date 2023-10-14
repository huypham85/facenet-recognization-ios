//
//  Session.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 08/10/2023.
//

import Foundation

struct Session {
    var id: String
    var date: String
    var startTime: String
    var endTime: String
    var startCheckInTime: String
    var endCheckInTime: String
    var roomNo: String
    var courseId: String
    var courseName: String
    var teacherName: String
    var teacherId: String
    var students: [String: Int]
    var startTimeDate: Date?
}

extension Session {
    init?(dictionary: [String: Any]) {
        guard let courseId = dictionary["courseId"] as? String,
              let courseName = dictionary["courseName"] as? String,
              let date = dictionary["date"] as? String,
              let roomNo = dictionary["roomNo"] as? String,
              let startTime = dictionary["startTime"] as? String,
              let startCheckInTime = dictionary["startCheckInTime"] as? String,
              let endCheckInTime = dictionary["endCheckInTime"] as? String,
              let id = dictionary["id"] as? String,
              let endTime = dictionary["endTime"] as? String,
              let students = dictionary["students"] as? [String: Int],
              let teacherId = dictionary["teacherId"] as? String,
              let teacherName = dictionary["teacherName"] as? String else {
            return nil
        }

        self.courseId = courseId
        self.courseName = courseName
        self.date = date
        self.roomNo = roomNo
        self.startTime = startTime
        self.startCheckInTime = startCheckInTime
        self.endCheckInTime = endCheckInTime
        self.id = id
        self.endTime = endTime
        self.students = students
        self.teacherName = teacherName
        self.teacherId = teacherId
        formatter.dateFormat = "HH:mm"
        self.startTimeDate = formatter.date(from: startTime)
    }
}
