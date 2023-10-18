//
//  SessionTableViewCell.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 10/10/2023.
//

import UIKit

class SessionTableViewCell: UITableViewCell {
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var teacherLabel: UILabel!
    @IBOutlet var courseIdLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var backgroundSessionView: UIView!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var startTime: UILabel!
    private var session: Session?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(session: Session) {
        self.session = session
        roomLabel.text = session.roomNo
        teacherLabel.text = session.teacherName
        startTime.text = session.startTime
        endTime.text = session.endTime
        courseIdLabel.text = session.courseId
        subjectLabel.text = session.courseName

        setCheckedInStatus()
    }

    private func setCheckedInStatus() {
        if globalUser?.role == .student {
            if let attendance = session?.students.first(where: {
                $0.studentId == globalUser?.id
            }),
                attendance.checkedInTime != ""
            {
                backgroundSessionView.backgroundColor = .lightGreen
            }
        }
    }
}
