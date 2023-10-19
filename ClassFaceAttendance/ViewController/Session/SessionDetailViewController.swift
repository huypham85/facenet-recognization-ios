//
//  SessionDetailViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 11/10/2023.
//

import ProgressHUD
import RealmSwift
import UIKit

class SessionDetailViewController: BaseViewController {
    @IBOutlet private var teacherNameLabel: UILabel!
    @IBOutlet private var roomLabel: UILabel!
    @IBOutlet private var checkInTimeLabel: UILabel!
    @IBOutlet private var sessionTimeLabel: UILabel!
    @IBOutlet private weak var checkInButton: UIButton!
    @IBOutlet private var subjectLabel: UILabel!
    @IBOutlet private weak var checkedInLabel: UILabel!
    var session: Session?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if globalUser?.role == .student {
            checkAttendance()
        }
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        guard let session = session else { return }
        subjectLabel.text = session.courseName
        sessionTimeLabel.text = "\(session.startTime) - \(session.endTime)"
        checkInTimeLabel.text = "\(session.startCheckInTime) - \(session.endCheckInTime)"
        roomLabel.text = session.roomNo
        teacherNameLabel.text = session.teacherName
    }
    
    private func checkAttendance() {
        checkedInLabel.isHidden = true
        guard let session = session else { return }
        ProgressHelper.showLoading()
        firebaseManager.getAttendanceOfSession(sessionId: session.id) { [weak self] attendance in
            if let attendance = attendance {
                if let dateString = attendance.checkInTime.convertIsoStringToDateHour() {
                    self?.checkedInLabel.isHidden = false
                    self?.checkedInLabel.text = "Bạn đã điểm danh lúc \(dateString)"
                    self?.checkInButton.isHidden = true
                }
            } else {
                if Date().isOverSessionTime(dateString: "\(session.endTime) \(session.date)") {
                    self?.checkInButton.isHidden = true
                    self?.checkedInLabel.isHidden = false
                    self?.checkedInLabel.text = "Vắng mặt"
                    self?.checkedInLabel.textColor = .systemRed
                } else {
                    self?.checkInButton.isHidden = false
                    self?.checkedInLabel.isHidden = true
                }
            }
            ProgressHelper.hideLoading()
        }
    }

    @IBAction func checkInAction(_: Any) {
        firebaseManager.isStudentRegisteredFace(completion: { [weak self] in
            guard let self,
                  let session = self.session
            else { return }
            if $0 {
                if self.isCurrentTimeInRange(startTime: "\(session.startTime) \(session.date)",
                                             endTime: "\(session.endTime) \(session.date)") {
                    self.setupCheckIn()
                } else {
                    self.showAlertViewController(title: "Ngoài thời gian điểm danh",
                                                 actions: [],
                                                 cancel: "OK",
                                                 cancelHandler: {
                                                     self.dismiss(animated: true)
                                                 })
                }
            } else {
                self.showAlertRegisterFace()
            }
        })
    }

    @IBAction func studentsAction(_: Any) {
        let vc = StudentListViewController()
        vc.session = session
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showAlertRegisterFace() {
        showAlertViewController(title: "Bạn chưa đăng ký gương mặt",
                                message: "Đăng ký ngay bây giờ?",
                                actions: ["OK"],
                                cancel: "Để lúc khác") { [weak self] index in
            if index == 0 {
                let vc = RecordVideoViewController.create()
                self?.present(vc, animated: true)
            }
        } cancelHandler: { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    func isCurrentTimeInRange(startTime: String, endTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "vi_VN")

        if let startDate = dateFormatter.date(from: startTime),
           let endDate = dateFormatter.date(from: endTime) {
            let currentTime = Date()

            return currentTime >= startDate && currentTime <= endDate
//            return true
        }

        return false
    }

    private func setupCheckIn() {
        loadVectorFromDB()
    }

    func loadVectorFromDB() {
        if NetworkChecker.isConnectedToInternet {
            ProgressHUD.show()
            firebaseManager.loadAllKMeansVector { [weak self] result in
                kMeanVectors = result
                print("Number of k-Means vectors: \(kMeanVectors.count)")
                // save to local data
                try! realm.write {
                    realm.deleteAll()
                }
                for vector in kMeanVectors {
                    vectorHelper.saveVector(vector)
                }
                ProgressHUD.dismiss()
                let vc = FrameViewController.create(session: self?.session)
                self?.present(vc, animated: true)
            }
        } else {
            // for local data
            let result = realm.objects(SavedVector.self)
            print(result.count)
            kMeanVectors = []
            for vector in result {
                let v = Vector(name: vector.name, vector: stringToArray(string: vector.vector), distance: vector.distance)
                kMeanVectors.append(v)
            }
        }
    }
}
