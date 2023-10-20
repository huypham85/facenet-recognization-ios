//
//  SessionAttendanceTableViewCell.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 20/10/2023.
//

import UIKit

class SessionAttendanceTableViewCell: UITableViewCell {

    @IBOutlet weak var sessionCheckInTime: UILabel!
    @IBOutlet weak var sessionDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(studentAttendance: StudentAttendance) {
        sessionCheckInTime.text = studentAttendance.checkInTime.convertIsoStringToHour()
        sessionDate.text = studentAttendance.sessionStartTime
    }
    
}
