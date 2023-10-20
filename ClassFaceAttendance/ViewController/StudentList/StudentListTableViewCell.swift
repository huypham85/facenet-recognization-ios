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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
    
    func setData(student: MiniStudent?, session: Session) {
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
    
}
