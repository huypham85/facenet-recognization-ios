
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage
import Foundation
import SDWebImage

class FirebaseManager {
    init() {
        FirebaseApp.configure()
    }
    
    func uploadAllVectors(vectors: [Vector], completionHandler: @escaping () -> Void) {
        for i in 0..<vectors.count {
            let vector = vectors[i]
            let dict: [String: Any] = [
                "name": vector.name,
                "vector": arrayToString(array: vector.vector),
                "distance": vector.distance
            ]
            let childString = "\(vector.name) - \(i)"
            Database.database().reference().child(STUDENT_CHILD).child(globalUser?.id ?? "").child(ALL_VECTOR).child(childString).updateChildValues(dict, withCompletionBlock: {
                error, _ in
                if error == nil {
                    print("uploaded vector")
                }
            })
        }
        completionHandler()
    }

    func uploadKMeanVectors(vectors: [Vector], completionHandler: @escaping () -> Void) {
        for i in 0..<vectors.count {
            let vector = vectors[i]
            let dict: [String: Any] = [
                "name": vector.name,
                "vector": arrayToString(array: vector.vector),
                "distance": vector.distance
            ]
            let childString = "\(vector.name) - \(i)"
            Database.database().reference().child(STUDENT_CHILD).child(globalUser?.id ?? "").child(KMEAN_VECTOR).child(childString).updateChildValues(dict, withCompletionBlock: {
                error, _ in
                if error == nil {
                    print("uploaded vector")
                }
            })
        }
        completionHandler()
    }
    
    func loadLogTimes(completionHandler: @escaping ([Attendances]) -> Void) {
        var attendList: [Attendances] = []
        Database.database().reference().child(LOG_TIME).queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                let values = dataArray.map { $0.1 }
                for dict in values {
                    let item = dict as! NSDictionary
                    guard let name = item["name"] as? String,
                          let imgUrl = item["imageURL"] as? String,
                          let time = item["time"] as? String
                    else {
                        print("Error at get log times.")
                        continue
                    }
                    let object = Attendances(name: name, imageURL: imgUrl, time: time)
                    attendList.append(object)
                }
                completionHandler(attendList.sorted(by: { $0.time > $1.time }))
            }
            else {
                completionHandler(attendList)
            }
            
        }) { error in
            print(error.localizedDescription)
            completionHandler(attendList)
        }
    }
    
    func loadAllKMeansVector(completionHandler: @escaping ([Vector]) -> Void) {
        var vectors = [Vector]()
        Database.database().reference().child(STUDENT_CHILD).child(globalUser?.id ?? "").child(KMEAN_VECTOR).queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { snapshot in
            
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                
                let values = dataArray.map { $0.1 }
                for dict in values {
                    let item = dict as! NSDictionary
                    
                    guard let name = item["name"] as? String,
                          let vector = item["vector"] as? String,
                          let distance = item["distance"] as? Double
                    else {
                        print("Error at get vectors")
                        continue
                    }
                    let object = Vector(name: name, vector: stringToArray(string: vector), distance: distance)
                    vectors.append(object)
                }
            }
            else {
                print("parse json error when load K Means Vector")
            }
            completionHandler(vectors)
            
        }) { error in
            print(error.localizedDescription)
            completionHandler(vectors)
        }
    }
    
    func loadAllVector(name _: String, completionHandler: @escaping ([Vector]) -> Void) {
        var vectors = [Vector]()
        Database.database().reference().child(STUDENT_CHILD).child(globalUser?.id ?? "").child(ALL_VECTOR).queryLimited(toLast: 1000).observeSingleEvent(of: .value, with: { snapshot in
            
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                
                let values = dataArray.map { $0.1 }
                for dict in values {
                    let item = dict as! NSDictionary
                    
                    guard let name = item["name"] as? String,
                          let vector = item["vector"] as? String,
                          let distance = item["distance"] as? Double
                    else {
                        print("Error at get vectors")
                        continue
                    }
                    let object = Vector(name: name, vector: stringToArray(string: vector), distance: distance)
                    vectors.append(object)
                }
            }
            completionHandler(vectors)
            
        }) { error in
            print(error.localizedDescription)
            completionHandler(vectors)
        }
    }
    
    // MARK: Attendances

    func uploadLogTimes(attendance: Attendance, completionHandler: @escaping (Error?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: STORAGE_URL).child("\(attendance.name) - \(attendance.time.dropLast(10))")
        
        let metadata = StorageMetadata()
        
        if let imageData = attendance.image.jpegData(compressionQuality: 1.0),
           let sessionId = attendance.session?.id {
            metadata.contentType = "image/jpg"
            storageRef.putData(imageData, metadata: metadata, completion: {
                _, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(error)
                    return
                }
                else {
                    storageRef.downloadURL(completion: { [weak self] url, error in
                        if let metaImageUrl = url?.absoluteString {
                            let dict: [String: Any] = [
                                "id": attendance.name,
                                "name": attendance.fullName,
                                "photo": metaImageUrl,
                                "checkInTime": attendance.time,
                                "sessionStartTime": attendance.sessionStartTime
                            ]
                            Database.database().reference().child(ATTENDANCES).child(sessionId).child(attendance.name).updateChildValues(dict, withCompletionBlock: {
                                error, _ in
                                if error == nil {
                                    self?.updateAttendanceSession(attendance: attendance) { error in
                                        if error == nil {
                                            completionHandler(nil)
                                        }
                                        else {
                                            completionHandler(error)
                                        }
                                    }
                                }
                                else {
                                    completionHandler(error)
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    func uploadManualCheckIn(attendance: ManualAttendance, completionHandler: @escaping (Error?) -> Void) {
        let dict: [String: Any] = [
            "id": attendance.name,
            "name": attendance.fullName,
            "photo": "",
            "checkInTime": attendance.time,
            "sessionStartTime": attendance.sessionStartTime
        ]
        Database.database().reference().child(ATTENDANCES).child(attendance.session?.id ?? "").child(attendance.name).updateChildValues(dict, withCompletionBlock: { [weak self] error, _ in
            if error == nil {
                self?.updateManualAttendanceSession(attendance: attendance) { error in
                    if error == nil {
                        completionHandler(nil)
                    }
                    else {
                        completionHandler(error)
                    }
                }
            }
            else {
                completionHandler(error)
            }
        })
    }
    
    func updateAttendanceSession(attendance: Attendance, completion: @escaping (Error?) -> Void) {
        guard let session = attendance.session
        else {
            return
        }
        let ref = Database.database().reference().child(SESSIONS).child(session.date)
            .child(session.id).child("students")
        let dict = [attendance.name: attendance.time]
        ref.updateChildValues(dict) { error, _ in
            if error == nil {
                print("Uploaded log time.")
                completion(nil)
            }
            else {
                completion(error)
            }
        }
    }
    
    func updateManualAttendanceSession(attendance: ManualAttendance, completion: @escaping (Error?) -> Void) {
        guard let session = attendance.session
        else {
            return
        }
        let ref = Database.database().reference().child(SESSIONS).child(session.date)
            .child(session.id).child("students")
        let dict = [attendance.name: attendance.time]
        ref.updateChildValues(dict) { error, _ in
            if error == nil {
                print("Uploaded log time.")
                completion(nil)
            }
            else {
                completion(error)
            }
        }
    }
    
    func getSessionAttendanceOfStudent(sessionId: String,
                                studentId: String = globalUser?.id ?? "",
                                completion: @escaping (StudentAttendance?) -> Void) {
        let ref = Database.database().reference().child(ATTENDANCES).child(sessionId).child(studentId)
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let attendanceData = snapshot.value as? [String: Any],
                   let studentAttendance = StudentAttendance(dictionary: attendanceData, sessionId: sessionId)
                {
                    completion(studentAttendance)
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
    func getAttendancesOfSession(sessionId: String,
                                completion: @escaping ([StudentAttendance]) -> Void) {
        let ref = Database.database().reference().child(ATTENDANCES).child(sessionId)
        var attendances: [StudentAttendance] = []
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let attendancesData = snapshot.value as? [String: Any] {
                    for (attendanceName, attendanceData) in attendancesData {
                        if let attendance = attendanceData as? [String: Any],
                        let studentAttendance = StudentAttendance(dictionary: attendance, sessionId: sessionId) {
                            print("Attendance of \(attendanceName)")
                            attendances.append(studentAttendance)
                        }
                    }
                }
            }
            completion(attendances)
        }
    }
    
    func uploadCurrentFace(name: String, image: UIImage, completionHandler: @escaping (Error?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: STORAGE_URL).child("\(name) - \(Date().toIsoString())")

        let metadata = StorageMetadata()

        if let imageData = image.jpegData(compressionQuality: 1.0) {
            metadata.contentType = "image/jpg"
            storageRef.putData(imageData, metadata: metadata, completion: {
                _, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(error)
                    return
                }
                else {
                    storageRef.downloadURL(completion: {
                        url, error in
                        if let metaImageUrl = url?.absoluteString {
                            let dict: [String: Any] = ["currentFace": metaImageUrl]
                            Database.database().reference().child(STUDENT_CHILD).child(globalUser?.id ?? "")
                                .updateChildValues(dict, withCompletionBlock: {
                                    error, _ in
                                    if error == nil {
                                        print("Updated current face")
                                        completionHandler(nil)
                                    }
                                })
                        }
                    })
                }
            })
        }
    }
    
    func hasCurrentFace(studentId: String, completion: @escaping (String?) -> Void) {
        let ref = Database.database().reference().child(STUDENT_CHILD).child(studentId)

        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let studentData = snapshot.value as? [String: Any],
                   let currentFace = studentData["currentFace"] as? String, !currentFace.isEmpty
                {
                    completion(currentFace)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    func loadUsers(completionHandler: @escaping ([String: Int]) -> Void) {
        var userList: [String: Int] = [:]
        Database.database().reference().child(STUDENT_CHILD).queryLimited(toLast: 300).observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? [String: Any] {
                userList = data as! [String: Int]
                completionHandler(userList)
            }
            else {
                completionHandler(userList)
            }
            
        }) { error in
            print(error.localizedDescription)
            completionHandler(userList)
        }
    }

    func uploadUser(name: String, user_id: Int, completionHandler: @escaping () -> Void) {
        let dict = [name: user_id]
        Database.database().reference().child(STUDENT_CHILD).updateChildValues(dict, withCompletionBlock: {
            error, _ in
            if error == nil {
                print("update user.")
            }
            completionHandler()
        })
    }
    
    // MARK: Authen

    func login(email: String, password: String, completion: @escaping (AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil, let result else {
                completion(nil)
                return
            }
            print("User logged in")
            completion(result)
        }
    }
    
    func hasLogInSession(completion: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                // User is signed in.
                print("User is still in session")
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
    
    func checkUserRole(completion: @escaping (UserRole) -> Void) {
        if let userId = Auth.auth().currentUser?.uid {
            let userRef = Database.database().reference().child(USERS).child(userId)
            userRef.observeSingleEvent(of: .value) { snapshot, _ in
                if let userData = snapshot.value as? [String: Any],
                   let user = User(dict: userData) {
                    globalUser = user
                    switch user.role {
                    case .student:
                        print("Student logged in")
                    case .teacher:
                        print("Teacher logged in")
                    }
                    completion(user.role)
                }
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: Courses and Sessions

    func getSessionsAtDate(date: String, completion: @escaping ([Session]) -> Void) {
        let ref = Database.database().reference()

        let sessionsRef = ref.child(SESSIONS).child(date)
        var sessions: [Session] = []
        sessionsRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let sessionsData = snapshot.value as? [String: Any] {
                    // Now you have a dictionary of sessions on the specified date
                    // You can iterate through this dictionary to access individual sessions
                    for (sessionId, sessionData) in sessionsData {
                        if let session = sessionData as? [String: Any] {
                            print("Session ID: \(sessionId)")
                            print("Session Data: \(session)")
                            if let newSession = Session(dictionary: session) {
                                if newSession.students.map({ $0.studentId })
                                    .contains(globalUser?.id ?? "") || newSession.teacherId == globalUser?.id
                                {
                                    sessions.append(newSession)
                                }
                            }
                        }
                    }
                }
            }
            else {
                print("No sessions found for the specified date.")
            }
            completion(sessions)
        }
    }
    
    func getSessionById(date: String, sessionId: String, completion: @escaping (Session) -> Void) {
        let ref = Database.database().reference()

        let sessionsRef = ref.child(SESSIONS).child(date).child(sessionId)
        sessionsRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let sessionsData = snapshot.value as? [String: Any] {
                    print("Session Data: \(sessionsData)")
                    if let newSession = Session(dictionary: sessionsData) {
                        completion(newSession)
                    }
                }
            }
            else {
                print("No sessions found for the specified date and id")
            }
        }
    }
    
    func getCourseFromSession(courseId: String, completion: @escaping (Course) -> Void) {
        let ref = Database.database().reference().child(COURSES)
        let courseRef = ref.child(courseId)
        courseRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let courseData = snapshot.value as? [String: Any] {
                    if let course = Course(dictionary: courseData) {
                        completion(course)
                    }
                }
            }
        }
    }
    
    func getCourseOfStudent(studentId: String, completion: @escaping ([Course]) -> Void) {
        let ref = Database.database().reference().child(COURSES)
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                var courses: [Course] = []
                if let coursesData = snapshot.value as? [String: Any] {
                    for (courseId, courseData) in coursesData {
                        if let course = courseData as? [String: Any] {
                            if let newCourse = Course(dictionary: course) {
                                if newCourse.students.map({ $0.id })
                                    .contains(studentId) {
                                    courses.append(newCourse)
                                }
                            }
                        }
                    }
                }
                completion(courses)
            }
        }
    }
    
    func getCoursesForTeacher(teacherId: String, completion: @escaping ([Course]) -> Void) {
        let ref = Database.database().reference().child(COURSES)
        
        var courses: [Course] = []
        
        // Query the database to find courses with the specified teacherId
        ref.queryOrdered(byChild: "teacherId").queryEqual(toValue: teacherId).observeSingleEvent(of: .value) { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                if let courseData = child.value as? [String: Any] {
                    if let course = Course(dictionary: courseData) {
                        courses.append(course)
                    }
                }
            }
            
            completion(courses)
        }
    }
    
    func updateCheckInTime(startTime: String, endTime: String, session: Session, completion: @escaping (String, String) -> Void) {
        let dict = ["startCheckInTime": startTime, "endCheckInTime": endTime]
        Database.database().reference().child(SESSIONS).child(session.date).child(session.id).updateChildValues(dict, withCompletionBlock: {
            error, _ in
            if error == nil {
                completion(startTime, endTime)
            }
        })
    }
    
    // MARK: Student and Teacher

    func getStudent(with studentId: String, completion: @escaping (Student) -> Void) {
        let ref = Database.database().reference().child(STUDENT_CHILD)
        
        ref.child(studentId).observeSingleEvent(of: .value) { snapshot in
            if let studentData = snapshot.value as? [String: Any],
               let student = Student(dictionary: studentData) {
                completion(student)
            }
        }
    }
    
    func getTeacher(with teacherId: String, completion: @escaping (Teacher) -> Void) {
        let ref = Database.database().reference().child(TEACHER_CHILD)
        
        ref.child(teacherId).observeSingleEvent(of: .value) { snapshot in
            if let teacherData = snapshot.value as? [String: Any],
               let teacher = Teacher(dictionary: teacherData) {
                completion(teacher)
            }
        }
    }
    
    func uploadTeacherDeviceName(deviceName: String, teacherId: String) {
        let dict = ["deviceId": deviceName]
        Database.database().reference().child(TEACHER_CHILD).child(teacherId).updateChildValues(dict, withCompletionBlock: {
            error, _ in
            if error == nil {
                print("update device name.")
            }
        })
    }
    
    func isStudentRegisteredFace(completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child(STUDENT_CHILD).child(globalUser?.id ?? "")

        ref.observeSingleEvent(of: .value) { snapshot in
            if let studentData = snapshot.value as? [String: Any],
               let currentFace = studentData["currentFace"] as? String,
               !currentFace.isEmpty {
                // The student's "currentFace" field exists and has a value
                completion(true)
            }
            else {
                // The student's "currentFace" field does not exist or is empty
                completion(false)
            }
        }
    }
}
