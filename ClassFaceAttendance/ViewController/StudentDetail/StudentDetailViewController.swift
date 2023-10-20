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
    }

    @IBAction func logOutAction(_: Any) {
        firebaseManager.logOut()
        firebaseManager.hasLogInSession {
            if !$0 {
                Application.shared.changeRootViewMainWindow(
                    viewController: LoginViewController.create(),
                    animated: true
                )
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
        tableView.registerCell(SessionAttendanceTableViewCell.self)
        fetchCourse()
    }

    private func fetchCourse() {
        if let courseId = session?.courseId {
            firebaseManager.getCourseFromSession(courseId: courseId) { [weak self] currentCourse in
                guard let self,
                      let student = self.student
                else { return }
                self.course = currentCourse
                self.currentCourseLabel.text = currentCourse.name
                let dispatchGroup = DispatchGroup()
                for miniSession in currentCourse.sessions {
                    dispatchGroup.enter()

                    firebaseManager
                        .getAttendanceOfSession(sessionId: miniSession.sessionId,
                                                studentId: student.id)
                    { attendance in

                        if let attendance = attendance {
                            self.studentAttendances.append(attendance)
                        } else {
                            // create empty attendance
                            let newAttendance = StudentAttendance(
                                sessionId: miniSession.sessionId,
                                id: self.studentId ?? "",
                                photo: "",
                                name: student.name,
                                checkInTime: "",
                                sessionStartTime: "\(miniSession.date)"
                            )
                            self.studentAttendances.append(newAttendance)
                        }

                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.studentAttendances.sort {
                        $0.sessionStartDate ?? Date() < $1.sessionStartDate ?? Date()
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension StudentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentAttendances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionAttendanceTableViewCell.cellId) as? SessionAttendanceTableViewCell else {
            return UITableViewCell()
        }
        if let attendance = studentAttendances[safe: indexPath.row] {
            cell.setData(studentAttendance: attendance)
        }
        return cell
    }
    

 }
