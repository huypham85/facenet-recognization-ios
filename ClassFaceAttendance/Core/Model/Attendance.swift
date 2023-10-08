
import Foundation
import RealmSwift

//local user
struct Attendance {
    var name: String
    var image: UIImage
    var time: String
    //var confidence: String
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
