//
//  AttendanceInforViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 28/10/2023.
//

import PanModal
import SDWebImage
import UIKit

class AttendanceInforViewController: UIViewController, PanModalPresentable {
    var panScrollable: UIScrollView?

    var shortFormHeight: PanModalHeight {
        return .contentHeight(400)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }

    @IBOutlet var checkInTimeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var studentIdLabel: UILabel!
    @IBOutlet var studentNameLabel: UILabel!
    var attendance: StudentAttendance?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        guard let attendance = attendance else { return }
        studentNameLabel.text = attendance.name
        studentIdLabel.text = attendance.id
        checkInTimeLabel.text = attendance.checkInTime.convertIsoStringToHour()
        dateLabel.text = attendance.sessionStartTime
        imageView.sd_setImage(with: URL(string: attendance.photo))
    }
}
