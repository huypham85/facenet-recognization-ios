
import UIKit
import CoreML
import RealmSwift
//import KDTree

//Machine Learning Model
let fnet = FaceNet()
let fDetector = FaceDetector()

var vectorHelper = VectorHelper()


let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let trainingDataset = ImageDataset(split: .train)
let testingDataset = ImageDataset(split: .test)

var currentLabel = UNKNOWN

var numberOfFramesDeteced = 0 //number frames detected
let validFrames = 3 //after getting 5 frames, users have been verified

var attendList: [Attendances] = [] //load from firebase
var localUserList: [Attendance] = [] //copy of attenList, use it to ignore appended users
var userDict = [String: Int]()

//Save User Local List
let defaults = UserDefaults.standard
var savedUserList = defaults.stringArray(forKey: SAVED_USERS) ?? [String]()


//Realm
let realm = try! Realm()
let firebaseManager  = FirebaseManager()

//KMeans to reduce number  of vectors
let KMeans = KMeansSwift.sharedInstance
var kMeanVectors = [Vector]()

//date time formatter
let formatter = DateFormatter()
let timeZone = TimeZone(identifier: "Asia/Bangkok")
var calendar = Calendar(identifier: .gregorian)

var current: CGImage?

// User
var globalUser: User?
var userFullName: String?
