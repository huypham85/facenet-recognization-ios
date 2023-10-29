//
//  StudentListViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 14/10/2023.
//

import UIKit

class StudentListViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private let refreshControl = UIRefreshControl()
    
    var session: Session?
    private var students: [MiniStudent] = []
    private var filteredStudents: [MiniStudent] = [] {
        didSet {
            filteredStudents.sort {
                let words1 = $0.name.split(separator: " ")
                let words2 = $1.name.split(separator: " ")
                    
                if let lastWord1 = words1.last, let lastWord2 = words2.last {
                    return lastWord1 < lastWord2
                }
                    
                return false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
        fetchStudents()
    }
    
    private func setupView() {
        title = session?.courseName
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.registerCell(StudentListTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        // Setup Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        fetchStudents()
    }

    
    private func fetchStudents() {
        guard let session = session else { return }
        ProgressHelper.showLoading()
        firebaseManager.getSessionById(date: session.date, sessionId: session.id) { [weak self] session in
            self?.session = session
            firebaseManager.getCourseFromSession(courseId: session.courseId) { [weak self] course in
                self?.students = course.students
                self?.filteredStudents = self?.students ?? []
                self?.tableView.reloadData()
                ProgressHelper.hideLoading()
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

extension StudentListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredStudents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentListTableViewCell.cellId) as? StudentListTableViewCell else {
            return UITableViewCell()
        }
        if let session = session {
            cell.setData(student: filteredStudents[safe: indexPath.row], session: session)
        }
        cell.showAttendanceInfo = { [weak self] attendance in
            let vc = AttendanceInforViewController()
            vc.attendance = attendance
            self?.presentPanModal(vc)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let student = filteredStudents[safe: indexPath.row] {
            let manualCheckInAction = UIAlertAction(title: "Điểm danh thủ công", style: .default) { [weak self] _ in
                self?.manualCheckIn(student: student)
            }
            let viewStudentInfoAction = UIAlertAction(title: "Xem thông tin sinh viên", style: .default) { [weak self] _ in
                self?.navigateToStudentInfor(student: student)
            }
            var actions: [UIAlertAction] = [viewStudentInfoAction]
            let checkInTime = session?.students.first {
                $0.studentId == student.id
            }
            if checkInTime?.checkedInTime.isEmpty ?? true && globalUser?.role == .teacher {
                actions += [manualCheckInAction]
            }
            actions += [
                .init(title: "Cancel", style: .cancel),
            ]
            self.displayAlert(actions: actions, style: .actionSheet, completion: nil)
        }
    }
}

extension StudentListViewController {
    private func manualCheckIn(student: MiniStudent) {
        guard let session = session else { return }
        formatter.dateFormat = DATE_FORMAT
        let manualAttendance = ManualAttendance(session: session, name: student.id, fullName: student.name, time: formatter.string(from: Date()), sessionStartTime: session.date)
        firebaseManager.uploadManualCheckIn(attendance: manualAttendance) { [weak self] error in
            if error == nil {
                self?.showAlertViewController(title: "Điểm danh thủ công thành công", actions: [], cancel: "OK")
                self?.fetchStudents()
            }
        }
        
    }
    
    private func navigateToStudentInfor(student: MiniStudent) {
        let vc = StudentInformationViewController()
        vc.session = session
        vc.studentId = student.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StudentListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStudents = searchText.isEmpty ? students : students.filter { student in
            student.name.lowercased().contains(searchText.lowercased())
        }

        tableView.reloadData()
    }
}
