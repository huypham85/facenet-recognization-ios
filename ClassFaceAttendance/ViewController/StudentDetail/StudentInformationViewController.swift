//
//  StudentInformationViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 15/10/2023.
//

import UIKit

class StudentInformationViewController: BaseViewController {
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var currentCourseLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    var studentId: String?
    var session: Session?
    private var student: Student?
    private var course: Course?
    private var studentAttendances: [StudentAttendance] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getInformation()
    }

    private func getInformation() {
        if let id = studentId {
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
        nameLabel.text = student.name
        idLabel.text = "ID: \(student.id)"
        emailLabel.text = student.email
        genderLabel.text = student.gender
        profileImageView.sd_setImage(with: URL(string: student.photo))
        classLabel.text = "Lớp: \(student.mainClass)"
        dobLabel.text = student.dob
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
                        .getSessionAttendanceOfStudent(sessionId: miniSession.sessionId,
                                                studentId: student.id) { attendance in

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

extension StudentInformationViewController: UITableViewDelegate, UITableViewDataSource {
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
