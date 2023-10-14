//
//  MiniStudent.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 14/10/2023.
//

import Foundation

struct MiniStudent {
    var name: String
    var id: String
    var photo: String

    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let photo = dictionary["photo"] as? String
        else {
            return nil
        }
        self.id = id
        self.name = name
        self.photo = photo
    }
}
