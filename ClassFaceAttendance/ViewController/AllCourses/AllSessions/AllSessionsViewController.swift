//
//  AllSessionsViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 27/10/2023.
//

import UIKit

class AllSessionsViewController: BaseViewController {
    @IBOutlet private var teacherNameLabel: UILabel!
    @IBOutlet private var courseIdLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var courseNameLabel: UILabel!
    var course: Course?
    var student: Student?
    private var teacher: Teacher?
    private var studentAttendances: [StudentAttendance] = []
    private var sessions: [Session] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        fetchData()
        navigationItem.largeTitleDisplayMode = .never
    }

    private func setupView() {
        courseNameLabel.text = course?.name
        courseIdLabel.text = course?.id
        ProgressHelper.showLoading()
        firebaseManager.getTeacher(with: course?.teacherId ?? "") { [weak self] teacher in
            if let teacher = teacher {
                self?.teacher = teacher
                self?.teacherNameLabel.text = "Giảng viên: \(teacher.name)"
            }
            ProgressHelper.hideLoading()
        }
        teacherNameLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        teacherNameLabel.addGestureRecognizer(tapGesture)
    }

    @objc func labelTapped() {
        let vc = TeacherInforViewController()
        vc.teacher = teacher
        presentPanModal(vc)
    }

    private func setupCollectionView() {
        let cell = UINib(nibName: "AllSessionCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: AllSessionCollectionViewCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        fetchData()
    }

    private func fetchData() {
        ProgressHelper.showLoading()
        if globalUser?.role == .student {
            fetchAttendanceOfSessions()
        } else {
            fetchAllSessions()
        }
    }

    private func fetchAllSessions() {
        guard let course = course else { return }
        let dispatchGroup = DispatchGroup()
        sessions.removeAll()
        for miniSession in course.sessions {
            dispatchGroup.enter()
            firebaseManager.getSessionById(date: miniSession.date, sessionId: miniSession.sessionId) { [weak self] session in
                self?.sessions.append(session)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.sessions.sort {
                $0.date.convertStringToDate() ?? Date() < $1.date.convertStringToDate() ?? Date()
            }
            self.collectionView.reloadData()
            ProgressHelper.hideLoading()
            self.refreshControl.endRefreshing()
        }
    }

    private func fetchAttendanceOfSessions() {
        guard let course = course, let globalUser = globalUser else { return }
        let dispatchGroup = DispatchGroup()
        studentAttendances.removeAll()
        for miniSession in course.sessions {
            dispatchGroup.enter()
            firebaseManager
                .getSessionAttendanceOfStudent(sessionId: miniSession.sessionId, studentId: student?.id ?? globalUser.id) { [weak self] attendance in
                    guard let self else { return }
                    if let attendance = attendance {
                        self.studentAttendances.append(attendance)
                    } else {
                        // create empty attendance
                        let newAttendance = StudentAttendance(
                            sessionId: miniSession.sessionId,
                            id: self.student?.id ?? globalUser.id,
                            photo: "",
                            name: (self.student?.name ?? userFullName) ?? "",
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
            ProgressHelper.hideLoading()
            self.refreshControl.endRefreshing()
        }
    }
}

extension AllSessionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if globalUser?.role == .student {
            return studentAttendances.count
        } else {
            return sessions.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AllSessionCollectionViewCell.cellId,
            for: indexPath
        ) as? AllSessionCollectionViewCell else {
            return UICollectionViewCell()
        }
        if globalUser?.role == .student {
            let attendance = studentAttendances[indexPath.item]
            cell.setAttendance(attendance: attendance)
        } else {
            let session = sessions[indexPath.item]
            cell.setAttendanceSession(session: session)
        }
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if globalUser?.role == .student {
            if let attendance = studentAttendances[safe: indexPath.item] {
                let vc = AttendanceInforViewController()
                vc.attendance = attendance
                presentPanModal(vc)
            }
        } else {
            if let session = sessions[safe: indexPath.item] {
                let vc = StudentListViewController()
                vc.session = session
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension AllSessionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        let width = 100
        let height = 100
        return
            CGSize(width: width, height: height)
    }
}
