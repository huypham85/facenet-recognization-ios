//
//  CalendarHomeViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import UIKit

class CalendarHomeViewController: BaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    var totalSquares = [Date]()
    var sessions: [Session] = []
    var selectedDate = Date() {
        didSet {
            datePicker.setDate(selectedDate, animated: true)
            getSessionAtDate(date: selectedDate)
        }
    }
    @IBOutlet var datePicker: UIDatePicker!
    
    private let refreshControl = UIRefreshControl()
    private var itemSpacing = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        title = TabBarItemTitle.classCalendar
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
        setupCollectionView()
        setupTableView()
        setCellsView()
        setWeekView()
        setupDatePicker()
    }

    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "vi_VN")
        datePicker.subviews[0].subviews.compactMap { $0 as? UILabel }.forEach { label in
            label.textAlignment = .center
        }
        datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
    }
    
    private func setupView() {
    }

    private func setupCollectionView() {
        let calendarCell = UINib(nibName: "CalendarCollectionViewCell", bundle: nil)
        collectionView.register(calendarCell, forCellWithReuseIdentifier: CalendarCollectionViewCell.cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupTableView() {
        tableView.registerCell(SessionTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        // Setup Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

    }

    @IBAction func previousWeek(_: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
    }

    @IBAction func nextWeek(_: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
    }
    
    @objc func onDateChanged() {
        selectedDate = datePicker.date
        setWeekView()
    }
    
    @objc private func refreshData() {
        getSessionAtDate(date: selectedDate)
    }

    func setCellsView() {}

    func setWeekView() {
        totalSquares.removeAll()

        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)

        while current < nextSunday {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        datePicker.setDate(selectedDate, animated: true)
        collectionView.reloadData()
        tableView.reloadData()
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setWeekView()
    }
}

extension CalendarHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        totalSquares.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.cellId,
            for: indexPath
        ) as? CalendarCollectionViewCell else {
            return UICollectionViewCell()
        }

        let date = totalSquares[indexPath.item]
        cell.config(date: date)

        if date == selectedDate {
            cell.backgroundColor = UIColor.red200
        } else {
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(itemSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        getSessionAtDate(date: selectedDate)
        collectionView.reloadData()
    }
    
    private func getSessionAtDate(date: Date) {
        print("Select date: \(date.toDateString())")
        ProgressHelper.showLoading()
        firebaseManager.getSessionsAtDate(date: date.toDateString()) { [weak self] sessions in
            var sortedSessions =  sessions
            sortedSessions.sort(by: { $0.startTimeDate ?? Date() < $1.startTimeDate ?? Date() })
            self?.sessions = sortedSessions
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
            ProgressHelper.hideLoading()
        }
    }
}

extension CalendarHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize
    {
        let width = collectionView.frame.size.width / 7 - CGFloat(itemSpacing)
        let height = collectionView.frame.size.height
        return
            CGSize(width: width, height: height)
    }
}

extension CalendarHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.cellId) as? SessionTableViewCell else {
            return UITableViewCell()
        }
        cell.setData(session: sessions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let session = sessions[safe: indexPath.row]
        let vc = SessionDetailViewController()
        vc.session = session
        navigationController?.pushViewController(vc, animated: true)
    }
}

