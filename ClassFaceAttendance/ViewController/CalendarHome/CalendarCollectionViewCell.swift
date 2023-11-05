//
//  CalendarCollectionViewCell.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dayOfMonth: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(date: Date) {
        dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
        formatter.dateFormat = "EEE"
        formatter.timeZone = timeZone
        let day = formatter.string(from: date)
        dayOfWeek.text = day
    }

}
