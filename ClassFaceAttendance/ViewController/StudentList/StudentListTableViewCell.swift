//
//  StudentListTableViewCell.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 15/10/2023.
//

import UIKit
import SDWebImage

class StudentListTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var checkInTimeLabel: UILabel!
    @IBOutlet weak var studentImageView: UIImageView!
    
    private var miniStudent: MiniStudent?
    private var session: Session?
    
    var showAttendanceInfo: ((StudentAttendance) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkInTimeLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        checkInTimeLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped() {
        fetchAttendanceOfStudent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        studentImageView.image = UIImage(systemName: "person.circle.fill")
    }
    
    func setData(student: MiniStudent?, session: Session) {
        self.session = session
        self.miniStudent = student
        studentIdLabel.text = student?.id
        studentNameLabel.text = student?.name
        if let imageURL = URL(string: student?.photo ?? "") {
            studentImageView.sd_setImage(with: imageURL)
        }
        if globalUser?.role == .student {
            checkInTimeLabel.isHidden = true
        } else {
            let checkInTime = session.students.first {
                $0.studentId == student?.id
            }
            if let checkInTime = checkInTime {
                checkInTimeLabel.isHidden = false
                checkInTimeLabel.text = checkInTime.checkedInTime.convertIsoStringToDateHour()
            } else {
                checkInTimeLabel.isHidden = true
            }
        }
        
    }
    
    private func fetchAttendanceOfStudent() {
        guard let session, let miniStudent else { return }
        firebaseManager.getSessionAttendanceOfStudent(sessionId: session.id, studentId: miniStudent.id) { [weak self] attendance in
            guard let attendance = attendance else { return }
            self?.showAttendanceInfo?(attendance)
        }
    }
}
