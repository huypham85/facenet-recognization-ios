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
    
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = TabBarItemTitle.course
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        fetchCourse()
    }

    private func setupTableView() {
        tableView.registerCell(CourseTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        // Setup Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        fetchCourse()
    }

    private func fetchCourse() {
        ProgressHelper.showLoading()
        switch globalUser?.role {
        case .student:
            firebaseManager.getCourseOfStudent(studentId: globalUser?.id ?? "") { [weak self] courses in
                print(courses)
                self?.courses = courses
                self?.tableView.reloadData()
                ProgressHelper.hideLoading()
                self?.refreshControl.endRefreshing()
            }
        case .teacher:
            firebaseManager.getCoursesForTeacher(teacherId: globalUser?.id ?? "") { [weak self] courses in
                print(courses)
                self?.courses = courses
                self?.tableView.reloadData()
                ProgressHelper.hideLoading()
                self?.refreshControl.endRefreshing()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let course = courses[safe: indexPath.row] {
            let vc = AllSessionsViewController()
            vc.course = course
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
