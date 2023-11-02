//
//  ReAuthenticateViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 02/11/2023.
//

import FirebaseAuth
import UIKit

class ReAuthenticateViewController: BaseViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLoginAction(_: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              !password.isEmpty
        else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        // Re-authenticate the user
        ProgressHelper.showLoading()
        user?.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                ProgressHelper.hideLoading()
                self?.showAlertViewController(title: error.localizedDescription,
                                              actions: [],
                                              cancel: "OK")
            } else {
                ProgressHelper.hideLoading()
                let vc = ChangePasswordViewController()
                vc.credential = credential
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
