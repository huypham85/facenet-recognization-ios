//
//  SessionDetailViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 11/10/2023.
//

import UIKit

class SessionDetailViewController: BaseViewController {
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var checkInTimeLabel: UILabel!
    @IBOutlet var sessionTimeLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    
    var session: Session?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        guard let session = session else { return }
        subjectLabel.text = session.courseName
        sessionTimeLabel.text = "\(session.startTime) - \(session.endTime)"
        checkInTimeLabel.text = "\(session.startCheckInTime) - \(session.endCheckInTime)"
        roomLabel.text = session.roomNo
        teacherNameLabel.text = session.teacherName
    }
    
    @IBAction func checkInAction(_ sender: Any) {
        guard let session else { return }
        if isCurrentTimeInRange(startTime: session.startTime, endTime: session.endTime) {
            if let mainTabBarVc = AppDelegate.shared?.window?.rootViewController as? MainTabBarController {
                mainTabBarVc.selectedIndex = 0
            }
        } else {
            showAlertViewController(title: "Ngoài thời gian điểm danh",
                                    actions: [],
                                    cancel: "OK",
                                    cancelHandler: { [weak self] in
                                        self?.dismiss(animated: true)
                                    })
        }
    }
    @IBAction func studentsAction(_ sender: Any) {
        let vc = StudentListViewController()
        vc.session = session
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func isCurrentTimeInRange(startTime: String, endTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let startDate = dateFormatter.date(from: startTime),
           let endDate = dateFormatter.date(from: endTime) {
            let currentTime = Date()
            
            return currentTime >= startDate && currentTime <= endDate
        }
        
        return false
    }
}
