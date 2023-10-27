//
//  AllSessionCollectionViewCell.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 27/10/2023.
//

import UIKit
import SDWebImage

class AllSessionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var checkInImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(attendance: StudentAttendance) {
        dateLabel.text = attendance.sessionStartTime
        checkInImageView.sd_setImage(with: URL(string: attendance.photo))
        timeLabel.text = attendance.checkInTime.convertIsoStringToHour()
    }

}
