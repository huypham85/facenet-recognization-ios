//
//  StudentDetailViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 15/10/2023.
//

import UIKit
import Photos
import PhotosUI

class StudentDetailViewController: BaseViewController {
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var dobView: UIView!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var logOutView: UIView!
    @IBOutlet var nameLabel: UILabel!
    var studentId: String?
    private var student: Student?
    private var teacher: Teacher?

    override func viewDidLoad() {
        super.viewDidLoad()
        getInformation()
    }
    
    @objc private func refreshData() {
        getInformation()
    }

    @IBAction func logOutAction(_: Any) {
        firebaseManager.logOut()
        firebaseManager.hasLogInSession {
            if !$0 {
                Application.shared.changeRootViewMainWindow(
                    viewController: LoginViewController.create(),
                    animated: false
                )
            }
        }
    }
    @IBAction func changePasswordAction(_ sender: Any) {
        let vc = ReAuthenticateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            DispatchQueue.main.async { [weak self] in
                self?.presentImagePicker()
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                guard let self = self else { return }
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.presentImagePicker()
                    }
                }
            }
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func getInformation() {
        if let globalUser = globalUser {
            switch globalUser.role {
            case .teacher:
                ProgressHelper.showLoading()
                firebaseManager.getTeacher(with: globalUser.id) { [weak self] teacher in
                    self?.teacher = teacher
                    self?.setupView()
                    ProgressHelper.hideLoading()
                }
            case .student:
                ProgressHelper.showLoading()
                firebaseManager.getStudent(with: globalUser.id) { [weak self] student in
                    if let student = student {
                        self?.student = student
                        self?.setupView()
                    }
                    ProgressHelper.hideLoading()
                }
            }
        }
    }

    private func setupView() {
        if globalUser?.role == .student {
            guard let student = student else { return }
            nameLabel.text = student.name
            idLabel.text = "ID: \(student.id)"
            emailLabel.text = student.email
            genderLabel.text = student.gender
            profileImageView.sd_setImage(with: URL(string: student.photo),
                                         placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
            classLabel.text = "Lớp: \(student.mainClass)"
            dobLabel.text = student.dob
        } else {
            guard let teacher = teacher else { return }
            nameLabel.text = teacher.name
            idLabel.text = "ID: \(teacher.id)"
            emailLabel.text = teacher.email
            genderLabel.text = teacher.gender
            profileImageView.sd_setImage(with: URL(string: teacher.photo),
                                         placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
            classLabel.isHidden = true
            dobView.isHidden = true
        }
    }
}

extension StudentDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage,
              let user = globalUser
        else { return }
        ProgressHelper.showLoading(text: "Đang cập nhật ảnh đại điện")
        firebaseManager.updateProfilePicture(name: user.id, image: image) { [weak self] error in
            if error != nil {
                self?.showAlertViewController(title: error?.localizedDescription, actions: [], cancel: "OK")
            } else {
                self?.profileImageView.image = image
            }
            ProgressHelper.hideLoading()
        }
        dismiss(animated: true)
    }
}
