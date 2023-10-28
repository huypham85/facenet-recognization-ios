//
//  AllSessionCollectionViewCell.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 27/10/2023.
//

import SDWebImage
import UIKit

class AllSessionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(attendance: StudentAttendance) {
        dateLabel.text = attendance.sessionStartTime
        timeLabel.text = attendance.checkInTime.convertIsoStringToHour()
        if attendance.sessionStartDate ?? Date() < Date() && attendance.checkInTime.isEmpty {
            bgView.backgroundColor = .red400
        } else if !attendance.checkInTime.isEmpty {
            bgView.backgroundColor = .lightGreen
        } else {
            bgView.backgroundColor = .lightGray
        }
    }
}
