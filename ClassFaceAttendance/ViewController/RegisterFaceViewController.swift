//
//  RegisterFaceViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import UIKit

class RegisterFaceViewController: BaseViewController {

    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var viewFaceButton: UIButton!
    @IBOutlet weak var registerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }


    private func setupView() {
        if let globalUser = globalUser, globalUser.role == .student {
            ProgressHelper.showLoading()
            firebaseManager.hasCurrentFace(studentId: globalUser.id) { [weak self] face in
                if face != nil {
                    self?.registerImageView.image = UIImage(named: "ic_face_registered")
                    self?.registerLabel.text = "Bạn đã đăng ký gương mặt"
                    self?.registerLabel.textColor = .lightGreen
                    self?.registerButton.isHidden = true
                    self?.viewFaceButton.isHidden = false
                    ProgressHelper.hideLoading()
                } else {
                    self?.registerImageView.image = UIImage(named: "ic_face_unregistered")
                    self?.registerButton.isHidden = false
                    self?.viewFaceButton.isHidden = true
                    self?.registerLabel.text = "Bạn chưa đăng ký gương mặt"
                    self?.registerLabel.textColor = .black
                    ProgressHelper.hideLoading()
                }
            }
        }
        
    }

    @IBAction func registerFaceAction(_ sender: Any) {
        let vc = RecordVideoViewController.create()
        self.present(vc, animated: true)
    }
}
