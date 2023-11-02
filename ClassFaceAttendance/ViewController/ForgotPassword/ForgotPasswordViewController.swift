//
//  ForgotPasswordViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 01/11/2023.
//

import FirebaseAuth
import UIKit

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func sendEmail(_: Any) {
        let auth = Auth.auth()
        if let email = emailTextField.text, !email.isEmpty {
            auth.sendPasswordReset(withEmail: email) { [weak self] error in
                if let error = error {
                    self?.showAlertViewController(title: error.localizedDescription, actions: [], cancel: "OK")
                    return
                }
                self?.showAlertViewController(
                    title: "Email reset password has been sent",
                    actions: ["OK"],
                    cancel: nil,
                    actionHandler: { [weak self] index in
                        if index == 0 {
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                )
            }
        }
    }
}
