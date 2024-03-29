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
    @IBOutlet private var checkInButton: UIButton!
    @IBOutlet private var subjectLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet private var checkedInLabel: UILabel!
    var session: Session?
    private var pickerIsShowing = false

    private lazy var dateTimePicker: DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_reload"),
            style: .plain,
            target: self,
            action: #selector(refreshData)
        )
        setup()
        navigationItem.largeTitleDisplayMode = .never
    }

    override func closeKeyboard() {
        view.endEditing(true)
        if globalUser?.role == .teacher {
            if pickerIsShowing {
                pickerIsShowing = false
                validateNewCheckInTime(
                    startDate: dateTimePicker.selectedStartDate,
                    endDate: dateTimePicker.selectedEndDate
                )
                print("\(dateTimePicker.selectedStartDate) \(dateTimePicker.selectedEndDate)")
            }
        }
    }

    private func validateNewCheckInTime(startDate: Date, endDate: Date) {
        if endDate < startDate || endDate < Date() {
            showAlertViewController(title: "Cài đặt thời gian không hợp lệ", actions: [], cancel: "OK")
        } else {
            guard let session = session else { return }
            ProgressHelper.showLoading()
            firebaseManager.updateCheckInTime(startTime: startDate.toCheckInString(),
                                              endTime: endDate.toCheckInString(),
                                              session: session)
            { [weak self] startTime, endTime in
                self?.checkInTimeLabel.text = "\(startTime.removeDateComponent()) - \(endTime)"
                ProgressHelper.hideLoading()
                self?.showAlertViewController(
                    title: "Cập nhật thời gian điểm danh thành công",
                    actions: [],
                    cancel: "OK"
                )
            }
        }
    }

    private func setup() {
        setupView()
    }

    private func setupView() {
        guard let session = session else { return }
        ProgressHelper.showLoading()
        firebaseManager.getSessionById(date: session.date, sessionId: session.id) { [weak self] session in
            self?.session = session
            self?.subjectLabel.text = session.courseName
            self?.sessionTimeLabel.text = "\(session.startTime) - \(session.endTime) \(session.date)"
            self?.checkInTimeLabel
                .text = "\(session.startCheckInTime.removeDateComponent()) - \(session.endCheckInTime)"
            self?.roomLabel.text = session.roomNo
            self?.teacherNameLabel.text = session.teacherName
            ProgressHelper.hideLoading()
            if globalUser?.role == .student {
                self?.checkAttendance()
            } else {
                self?.checkInButton.isHidden = true
                self?.checkedInLabel.isHidden = true
            }
        }
        if globalUser?.role == .teacher {
            textField.inputView = dateTimePicker.inputView
            textField.delegate = self
        } else {
            textField.isHidden = true
        }
    }

    private func checkAttendance() {
        checkedInLabel.isHidden = true
        guard let session = session else { return }
        ProgressHelper.showLoading()
        firebaseManager.getSessionAttendanceOfStudent(sessionId: session.id) { [weak self] attendance in
            guard let self else { return }
            if let attendance = attendance {
                if let dateString = attendance.checkInTime.convertIsoStringToDateHour() {
                    self.checkedInLabel.isHidden = false
                    self.checkedInLabel.text = "Bạn đã điểm danh lúc \(dateString)"
                    self.checkInButton.isHidden = true
                }
            } else {
                // in check-in time
                if self.isCurrentTimeInRange(startTime: session.startCheckInTime, endTime: session.endCheckInTime) {
                    self.checkInButton.isHidden = false
                    self.checkedInLabel.isHidden = true
                } else if Date().isOverSessionTime(dateString: "\(session.endTime) \(session.date)") {
                    // over session time
                    self.checkInButton.isHidden = true
                    self.checkedInLabel.isHidden = false
                    self.checkedInLabel.text = "Vắng mặt"
                    self.checkedInLabel.textColor = .systemRed
                } else {
                    self.checkInButton.isHidden = false
                    self.checkedInLabel.isHidden = true
                }
            }
            ProgressHelper.hideLoading()
        }
    }

    @objc private func refreshData() {
        setup()
    }

    @IBAction func checkInAction(_: Any) {
        if let globalUser = globalUser, globalUser.role == .student {
            ProgressHelper.showLoading()
            firebaseManager.checkStudentFaceStatus(studentId: globalUser.id) { [weak self] status in
                guard let self, let session = self.session else { return }
                switch status {
                case let .hadFace(faceURL):
                    if self.isCurrentTimeInRange(startTime: session.startCheckInTime,
                                                 endTime: session.endCheckInTime)
                    {
                        self.setupCheckIn()
                    } else {
                        self.showAlertViewController(title: "Ngoài thời gian điểm danh",
                                                     actions: [],
                                                     cancel: "OK",
                                                     cancelHandler: {
                                                         self.dismiss(animated: true)
                                                     })
                    }
                case .notRegister:
                    self.showAlertRegisterFace()
                case .requesting:
                    self.showAlertViewController(title: "Gương mặt của bạn chưa được duyệt",
                                                 actions: [],
                                                 cancel: "OK",
                                                 cancelHandler: {
                                                     self.dismiss(animated: true)
                                                 })
                }
                ProgressHelper.hideLoading()
            }
        }
        
//        firebaseManager.isStudentRegisteredFace(completion: { [weak self] in
//            guard let self,
//                  let session = self.session
//            else { return }
//            if $0 {
//                if self.isCurrentTimeInRange(startTime: session.startCheckInTime,
//                                             endTime: session.endCheckInTime)
//                {
//                    self.setupCheckIn()
//                } else {
//                    self.showAlertViewController(title: "Ngoài thời gian điểm danh",
//                                                 actions: [],
//                                                 cancel: "OK",
//                                                 cancelHandler: {
//                                                     self.dismiss(animated: true)
//                                                 })
//                }
//            } else {
//                self.showAlertRegisterFace()
//            }
//        })
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
                                cancel: "Để lúc khác")
        { [weak self] index in
            if index == 0 {
                let vc = RecordVideoViewController.create()
                self?.present(vc, animated: true)
            }
        } cancelHandler: { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    func isCurrentTimeInRange(startTime: String, endTime: String) -> Bool {
        formatter.dateFormat = "HH:mm yyyy-MM-dd"
//        formatter.locale = Locale(identifier: "vi_VN")
        formatter.timeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")

        if let startDate = formatter.date(from: startTime),
           let endDate = formatter.date(from: endTime)
        {
            let currentTime = Date()

            return currentTime >= startDate && currentTime <= endDate
//            return true
        }

        return false
    }

    private func setupCheckIn() {
        showAlertViewController(title: "Điểm danh",
                                message: "Điểm danh ngay bây giờ?",
                                actions: ["OK"],
                                cancel: "Để lúc khác")
        { [weak self] index in
            if index == 0 {
                self?.loadVectorFromDB()
            }
        } cancelHandler: { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func loadVectorFromDB() {
        if NetworkChecker.isConnectedToInternet {
            ProgressHUD.show()
            kMeanVectors.removeAll()
            firebaseManager.loadAllKMeansVector(session: session) { [weak self] result in
                guard let self else { return }
                kMeanVectors = result
                print("Number of k-Means vectors: \(kMeanVectors.count)")
                // save to local data
                try! realm.write {
                    realm.deleteAll()
                }
                for vector in kMeanVectors {
                    vectorHelper.saveVector(vector)
                }
                firebaseManager.getTeacher(with: self.session?.teacherId ?? "") { teacher in
                    if let teacherDeviceId = teacher?.deviceId {
                        let vc = FrameViewController.create(session: self.session, teacherDeviceId: teacherDeviceId)
                        self.present(vc, animated: true)
                    } else {
                        self.showAlertViewController(
                            title: "Giảng viên môn học này chưa đăng nhập vào app. Vui lòng đợi!",
                            actions: [],
                            cancel: "OK"
                        )
                    }
                    ProgressHUD.dismiss()
                }
            }
        } else {
            // for local data
            let result = realm.objects(SavedVector.self)
            print(result.count)
            kMeanVectors = []
            for vector in result {
                let v = Vector(
                    name: vector.name,
                    vector: stringToArray(string: vector.vector),
                    distance: vector.distance
                )
                kMeanVectors.append(v)
            }
        }
    }
}

extension SessionDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            pickerIsShowing = true
        }
        return true // Return true to allow the text field to become first responder.
    }
}
