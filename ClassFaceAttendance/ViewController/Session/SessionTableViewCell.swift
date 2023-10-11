//
//  SessionTableViewCell.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 10/10/2023.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var courseIdLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(session: Session) {
        roomLabel.text = session.roomNo
        teacherLabel.text = session.teacherName
        startTime.text = session.startTime
        endTime.text = session.endTime
        courseIdLabel.text = session.courseId
        subjectLabel.text = session.courseName
    }
    
}
