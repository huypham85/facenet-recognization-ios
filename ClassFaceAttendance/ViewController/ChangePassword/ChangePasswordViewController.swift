//
//  ChangePasswordViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 02/11/2023.
//

import FirebaseAuth
import UIKit

class ChangePasswordViewController: BaseViewController {
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var changePasswordButton: UIButton!
    @IBOutlet var newPasswordTextField: UITextField!
    var credential: AuthCredential?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changePasswordAction(_: Any) {
        let user = Auth.auth().currentUser
        if let newPassword = newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !newPassword.isEmpty,
           let confirmPassword = confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !confirmPassword.isEmpty,
           let credential = credential
        {
            if confirmPassword == newPassword {
                ProgressHelper.showLoading()
                user?.reauthenticate(with: credential) { [weak self] _, error in
                    if let error = error {
                        ProgressHelper.hideLoading()
                        self?.showAlertViewController(title: error.localizedDescription,
                                                      actions: [],
                                                      cancel: "OK")
                    } else {
                        user?.updatePassword(to: newPassword) { [weak self] error in
                            if let error = error {
                                ProgressHelper.hideLoading()
                                self?.showAlertViewController(
                                    title: error.localizedDescription,
                                    actions: ["OK"],
                                    cancel: nil, actionHandler: { [weak self] index in
                                        if index == 0 {
                                            self?.navigationController?.popToRootViewController(animated: true)
                                        }
                                    }
                                )
                            } else {
                                ProgressHelper.hideLoading()
                                self?.showAlertViewController(
                                    title: "Thay đổi mật khẩu thành công",
                                    actions: ["OK"],
                                    cancel: nil, actionHandler: { [weak self] index in
                                        if index == 0 {
                                            self?.navigationController?.popToRootViewController(animated: true)
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            } else {
                showAlertViewController(title: "Xác nhận mật khẩu không khớp", actions: [], cancel: "OK")
            }
        }
    }
}
