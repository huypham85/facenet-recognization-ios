
import Foundation
import RealmSwift

// local user
struct Attendance {
    var session: Session?
    /// student's id
    var name: String
    var image: UIImage
    /// student's full name
    var fullName: String = userFullName ?? ""
    /// check in time
    var time: String
    var sessionStartTime: String
}

struct ManualAttendance {
    var session: Session?
    /// student's id
    var name: String
    /// student's full name
    var fullName: String
    /// check in time
    var time: String = {
        formatter.dateFormat = DATE_FORMAT
        return formatter.string(from: Date())
    }()
    var sessionStartTime: String
}

/// response from attendance DB
struct StudentAttendance {
    var sessionId: String?
    /// student's id
    var id: String
    var photo: String
    var name: String = userFullName ?? ""
    var checkInTime: String
    var sessionStartTime: String
    var sessionStartDate: Date?

    init(sessionId: String, id: String, photo: String, name: String, checkInTime: String, sessionStartTime: String) {
        self.sessionId = sessionId
        self.id = id
        self.photo = photo
        self.name = name
        self.checkInTime = checkInTime
        self.sessionStartTime = sessionStartTime
        formatter.dateFormat = "yyyy-MM-dd"
        self.sessionStartDate = formatter.date(from: sessionStartTime) ?? Date()
    }

    init?(dictionary: [String: Any], sessionId: String) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let checkInTime = dictionary["checkInTime"] as? String,
            let sessionStartTime = dictionary["sessionStartTime"] as? String
        else {
            return nil
        }
        
        if let photo = dictionary["photo"] as? String {
            self.photo = photo
        } else {
            self.photo = ""
        }


        self.name = name
        self.id = id
        self.checkInTime = checkInTime
        self.sessionId = sessionId
        self.sessionStartTime = sessionStartTime
        formatter.dateFormat = "HH:mm yyyy-MM-dd"
        self.sessionStartDate = formatter.date(from: sessionStartTime)
    }
}

// upload user
struct Attendances: Codable {
    var name: String
    var imageURL: String
    var time: String
}

class SavedVector: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var vector: String = ""
    @objc dynamic var distance: Double = 0
}
