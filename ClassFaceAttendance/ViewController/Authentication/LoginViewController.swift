//
//  LoginViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 07/10/2023.
//

import FirebaseAuth
import FirebaseCore
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkHasLoggedIn()
        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginAction(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }
        firebaseManager.login(email: email, password: password) { [weak self] result in
            guard let self = self, result != nil else {
                self?.showDialog(message: "Invalid email or password!")
                return
            }
            self.navigateToHome()
        }
    }

    private func checkHasLoggedIn() {
        firebaseManager.hasLogInSession { [weak self] in
            if $0 {
                self?.navigateToHome()
            }
        }
    }

    private func navigateToHome() {
        let vc = HomeViewController.create()
        Application.shared.changeRootViewMainWindow(viewController: vc,animated: true)
    }
}

extension LoginViewController {
    static func create() -> LoginViewController {
        let vc = LoginViewController.loadStoryboard(.main)
        return vc
    }
}
