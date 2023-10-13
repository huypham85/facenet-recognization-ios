//
//  User.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 09/10/2023.
//

import Foundation
enum UserRole: String {
    case student = "student"
    case teacher = "teacher"
}

struct User {
    let email: String
    let uid: String
    let id: String
    let role: UserRole

    init?(dict: [String: Any]) {
        guard let email = dict["email"] as? String,
              let uid = dict["uid"] as? String,
              let id = dict["id"] as? String,
              let role = dict["role"] as? String
        else {
            return nil
        }

        self.email = email
        self.uid = uid
        self.id = id
        self.role = UserRole(rawValue: role) ?? .student
    }
}
