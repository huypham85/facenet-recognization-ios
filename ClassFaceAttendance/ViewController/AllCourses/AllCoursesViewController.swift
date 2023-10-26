//
//  AllCoursesViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 26/10/2023.
//

import UIKit

class AllCoursesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private var courses: [Course] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Danh sách lớp tín chỉ"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        setupTableView()
        fetchCourse()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(CourseTableViewCell.self)
    }

    private func fetchCourse() {}
}

extension AllCoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.cellId) else {
            return UITableViewCell()
        }
        return cell
    }
}
