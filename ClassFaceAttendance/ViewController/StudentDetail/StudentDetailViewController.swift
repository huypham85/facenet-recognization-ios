//
//  StudentDetailViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 15/10/2023.
//

import UIKit

class StudentDetailViewController: BaseViewController {
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var currentCourseLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var logOutView: UIView!
    @IBOutlet var nameLabel: UILabel!
    var studentId: String?
    private var student: Student?
    private var course: Course?
    var session: Session?
    var navigateFromSession = true
    private var studentAttendances: [StudentAttendance] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudent()
        if globalUser?.role == .teacher {
            setupCourseAttendance()
        } else {
            currentCourseLabel.isHidden = true
            tableView.isHidden = true
        }
    }

    @IBAction func logOutAction(_ sender: Any) {
        firebaseManager.logOut()
        firebaseManager.hasLogInSession {
            if !$0 {
                Application.shared.changeRootViewMainWindow(viewController: LoginViewController.create(), animated: true)
            }
        }
    }

    private func getStudent() {
        let id = navigateFromSession ? studentId : globalUser?.id
        if let id = id {
            ProgressHelper.showLoading()
            firebaseManager.getStudent(with: id) { [weak self] student in
                self?.student = student
                self?.setupView()
                ProgressHelper.hideLoading()
            }
        }
    }

    private func setupView() {
        guard let student = student else { return }
        profileImageView.sd_setImage(with: URL(string: student.photo))
        nameLabel.text = student.name
        idLabel.text = "MSV: \(student.id)"
        classLabel.text = "Lớp: \(student.mainClass)"
        emailLabel.text = student.email
        dobLabel.text = student.dob
        genderLabel.text = student.gender
        if navigateFromSession {
            logOutView.isHidden = true
        }
        if globalUser?.role == .teacher {
            setupCourseAttendance()
        } else {
            currentCourseLabel.isHidden = true
            tableView.isHidden = true
        }
    }

    private func setupCourseAttendance() {
        currentCourseLabel.isHidden = false
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        fetchCourse()
    }

    private func fetchCourse() {
        if let sessionId = session?.courseId {
            firebaseManager.getCourseFromSession(courseId: sessionId) { [weak self] course in
                self?.course = course
                let dispatchGroup = DispatchGroup()

                for session in course.sessions {
                    dispatchGroup.enter()

                    firebaseManager.getAttendanceOfSession(sessionId: session.sessionId, studentId: self?.student?.id ?? "") { [weak self] attendance in
                        if let attendance = attendance {
                            self?.studentAttendances.append(attendance)
                        } else {
                            let newAttendance = StudentAttendance(sessionId: sessionId, id: self?.studentId ?? "", photo: "", name: self?.student?.name ?? "", checkInTime: "")
                            self?.studentAttendances.append(newAttendance)
                        }

                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension StudentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
}
