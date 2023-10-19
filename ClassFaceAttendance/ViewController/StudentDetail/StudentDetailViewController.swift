//
//  StudentDetailViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 15/10/2023.
//

import UIKit

class StudentDetailViewController: BaseViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var currentCourseLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var logOutView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
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
                Application.shared.changeRootViewMainWindow(viewController: LoginViewController.create(),animated: true)
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
    }
    
    private func setupCourseAttendance() {
        currentCourseLabel.isHidden = false
        tableView.isHidden = false
    }
    
    private func fetchCourse() {
        if let sessionId = session?.courseId {
            firebaseManager.getCourseFromSession(courseId: sessionId) { [weak self] course in
                self?.course = course
//                let sessionIds = course.sessions.map { $0.sessionId }
                for session in course.sessions {
                    firebaseManager.getAttendanceOfSession(sessionId: session.sessionId, studentId: self?.student?.id ?? "") { attendance in
                        if let attendance = attendance {
                            
                        } else {
                            
                        }
                    }
                }
                self?.tableView.reloadData()
            }
        }
    }

}
