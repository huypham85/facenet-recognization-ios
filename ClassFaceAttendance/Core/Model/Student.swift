//
//  Student.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 08/10/2023.
//

import Foundation

struct Student {
    var name: String
    var id: String
    var gender: String
    var mainClass: String
    var email: String
    var dob: String
    var photo: String
    var courseIds: [String?]

    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let gender = dictionary["gender"] as? String,
            let dob = dictionary["dob"] as? String,
            let photo = dictionary["photo"] as? String,
            let mainClass = dictionary["mainClass"] as? String,
            let coursesDict = dictionary["courses"] as? [String: Bool]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.email = email
        self.gender = gender
        self.dob = dob
        self.photo = photo
        self.mainClass = mainClass
        self.courseIds = Array(coursesDict.keys)
    }
}
