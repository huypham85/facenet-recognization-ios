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
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    private func fetchData() {
        guard let globalUser = globalUser else { return }
        ProgressHelper.showLoading()
        firebaseManager.getStudent(with: globalUser.id) { [weak self] student in
            self?.faceImageView.sd_setImage(with: URL(string: student.currentFace ?? ""))
            ProgressHelper.hideLoading()
        }
    }

    @IBAction func changeFaceAction(_ sender: Any) {
        
    }
}
