
import Foundation
import RealmSwift

//local user
struct Attendance {
    var session: Session?
    /// student's id
    var name: String
    var image: UIImage
    /// student's full name
    var fullName: String = userFullName ?? ""
    var time: String
}

struct StudentAttendance {
    var sessionId: String?
    var id: String
    var photo: String
    var name: String = userFullName ?? ""
    var checkInTime: String
    
    init?(dictionary: [String: Any], sessionId: String) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let checkInTime = dictionary["checkInTime"] as? String,
            let photo = dictionary["photo"] as? String
        else {
            return nil
        }

        self.name = name
        self.id = id
        self.checkInTime = checkInTime
        self.photo = photo
        self.sessionId = sessionId
    }
}

//upload user
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
