//
//  AllCoursesViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 26/10/2023.
//

import UIKit

class AllCoursesViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    private var courses: [Course] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCourse()
    }

    private func setupTableView() {
        tableView.registerCell(CourseTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    private func fetchCourse() {
        switch globalUser?.role {
        case .student:
            firebaseManager.getCourseOfStudent(studentId: globalUser?.id ?? "") { [weak self] courses in
                print(courses)
                self?.courses = courses
                self?.tableView.reloadData()
            }
        case .teacher:
            firebaseManager.getCoursesForTeacher(teacherId: globalUser?.id ?? "") { [weak self] courses in
                print(courses)
                self?.courses = courses
                self?.tableView.reloadData()
            }
        case .none:
            break
        }
    }
}

extension AllCoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.cellId) as? CourseTableViewCell else {
            return UITableViewCell()
        }
        if let course = courses[safe: indexPath.row] {
            cell.setData(course: course)
        }
        return cell
    }
}
