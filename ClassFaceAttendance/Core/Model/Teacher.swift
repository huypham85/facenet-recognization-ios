//
//  Teacher.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 09/10/2023.
//

import Foundation

struct Teacher {
    var id: String
    var name: String
    var gender: String
    var email: String
    var photo: String
    var courseIds: [String]
    var deviceId: String?
    
    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let gender = dictionary["gender"] as? String,
            let coursesDict = dictionary["courses"] as? [String: Bool]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.email = email
        self.gender = gender
        self.courseIds = Array(coursesDict.keys)
        if let photo = dictionary["photo"] as? String {
            self.photo = photo
        } else {
            self.photo = ""
        }
        let deviceId = dictionary["deviceId"] as? String
        self.deviceId = deviceId
    }
}
