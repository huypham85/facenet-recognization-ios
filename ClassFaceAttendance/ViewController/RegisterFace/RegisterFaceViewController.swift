//
//  RegisterFaceViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import UIKit
import PanModal

class RegisterFaceViewController: BaseViewController {

    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var viewFaceButton: UIButton!
    @IBOutlet weak var registerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_reload"), style: .plain, target: self, action: #selector(refreshData))
        title = TabBarItemTitle.faceRegister
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
    }
    
    @objc private func refreshData() {
        setupView()
    }

    private func setupView() {
        if let globalUser = globalUser, globalUser.role == .student {
            ProgressHelper.showLoading()
            firebaseManager.checkStudentFaceStatus(studentId: globalUser.id) { [weak self] status in
                guard let self else { return }
                switch status {
                case let .hadFace(faceURL):
                    self.registerImageView.image = UIImage(named: "ic_face_registered")
                    self.registerLabel.text = "Bạn đã đăng ký gương mặt"
                    self.registerLabel.textColor = .lightGreen
                    self.registerButton.isHidden = true
                    self.viewFaceButton.isHidden = false
                case .notRegister:
                    self.registerImageView.image = UIImage(named: "ic_face_unregistered")
                    self.registerButton.isHidden = false
                    self.viewFaceButton.isHidden = true
                    self.registerLabel.text = "Bạn chưa đăng ký gương mặt"
                    self.registerLabel.textColor = .black
                case .requesting:
                    self.registerImageView.image = UIImage(named: "ic_face_unregistered")
                    self.registerButton.isHidden = true
                    self.viewFaceButton.isHidden = true
                    self.registerLabel.text = "Gương mặt đang được kiểm duyệt"
                    self.registerLabel.textColor = .orange
                }
                ProgressHelper.hideLoading()
            }
        }
        
    }
    @IBAction func viewFaceAction(_ sender: Any) {
        let vc = ViewCurrentFaceViewController()
        vc.studentId = globalUser?.id
        self.presentPanModal(vc)
    }
    
    @IBAction func registerFaceAction(_ sender: Any) {
        let vc = RecordVideoViewController.create()
        self.present(vc, animated: true)
    }
}
