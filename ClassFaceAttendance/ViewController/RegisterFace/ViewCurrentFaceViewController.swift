//
//  ViewCurrentFaceViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 31/10/2023.
//

import UIKit
import SDWebImage
import PanModal

class ViewCurrentFaceViewController: BaseViewController, PanModalPresentable {
    
    var panScrollable: UIScrollView?

    var shortFormHeight: PanModalHeight {
        return .contentHeight(400)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }

    @IBOutlet weak var changeFaceButton: UIButton!
    @IBOutlet weak var faceImageView: UIImageView!
    var studentId: String?
    var isChangeFaceButtonHidden: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        changeFaceButton.isHidden = isChangeFaceButtonHidden
    }
    
    private func fetchData() {
        guard let studentId = studentId else { return }
        ProgressHelper.showLoading()
        firebaseManager.getStudent(with: studentId) { [weak self] student in
            self?.faceImageView.sd_setImage(with: URL(string: student.currentFace ?? ""))
            ProgressHelper.hideLoading()
        }
    }

    @IBAction func changeFaceAction(_ sender: Any) {
        let vc = RecordVideoViewController.create()
        self.present(vc, animated: true)
    }
}
