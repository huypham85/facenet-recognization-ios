//
//  AllSessionsViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 27/10/2023.
//

import UIKit

class AllSessionsViewController: UIViewController {
    @IBOutlet private var teacherNameLabel: UILabel!
    @IBOutlet private var courseIdLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var courseNameLabel: UILabel!
    var course: Course?
    var student: Student?
    private var studentAttendances: [StudentAttendance] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        fetchAllSessions()
    }

    private func setupView() {
        courseNameLabel.text = course?.name
        courseIdLabel.text = course?.id
        ProgressHelper.showLoading()
        firebaseManager.getTeacher(with: course?.teacherId ?? "") { [weak self] teacher in
            self?.teacherNameLabel.text = teacher.name
            ProgressHelper.hideLoading()
        }
    }

    private func setupCollectionView() {
        let cell = UINib(nibName: "AllSessionCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: AllSessionCollectionViewCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func fetchAllSessions() {
        guard let course = course, let globalUser = globalUser else { return }
        let dispatchGroup = DispatchGroup()
        for miniSession in course.sessions {
            dispatchGroup.enter()
            firebaseManager
                .getAttendanceOfSession(sessionId: miniSession.sessionId,
                                        studentId: student?.id ?? globalUser.id) { [weak self] attendance in
                    guard let self else { return }
                    if let attendance = attendance {
                        self.studentAttendances.append(attendance)
                    } else {
                        // create empty attendance
                        let newAttendance = StudentAttendance(
                            sessionId: miniSession.sessionId,
                            id: self.student?.id ?? globalUser.id,
                            photo: "",
                            name: (student?.name ?? userFullName) ?? "",
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
            self.collectionView.reloadData()
        }
    }
}

extension AllSessionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        studentAttendances.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AllSessionCollectionViewCell.cellId,
            for: indexPath
        ) as? AllSessionCollectionViewCell else {
            return UICollectionViewCell()
        }

        let attendance = studentAttendances[indexPath.item]
        cell.setData(attendance: attendance)

        return cell
    }
}

extension AllSessionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 3 - 8
        let height = width
        return
            CGSize(width: width, height: height)
    }
}
