//
//  CourseTableViewCell.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 26/10/2023.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var courseIdLabel: UILabel!
    @IBOutlet weak var courseName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(course: Course) {
        creditLabel.text = "\(String(course.numberCredits)) tín"
        courseIdLabel.text = course.id
        courseName.text = course.name
    }
    
}
