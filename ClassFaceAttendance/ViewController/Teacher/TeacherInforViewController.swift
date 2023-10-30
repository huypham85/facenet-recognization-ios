//
//  TeacherInforViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 28/10/2023.
//

import PanModal
import SDWebImage
import UIKit

class TeacherInforViewController: BaseViewController, PanModalPresentable {
    var panScrollable: UIScrollView?

    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }

    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var teacherMailLabel: UILabel!
    @IBOutlet var teacherGenderLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    var teacher: Teacher?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        guard let teacher = teacher else { return }
        teacherNameLabel.text = "Giảng viên: \(teacher.name)"
        teacherMailLabel.text = teacher.email
        teacherGenderLabel.text = teacher.gender
        profileImageView.sd_setImage(with: URL(string: teacher.photo ))
    }
}
