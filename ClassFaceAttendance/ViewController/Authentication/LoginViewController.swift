//
//  LoginViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 07/10/2023.
//

import FirebaseAuth
import FirebaseCore
import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkHasLoggedIn()
        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginAction(_: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }
        ProgressHelper.showLoading()
        firebaseManager.login(email: email, password: password) { [weak self] result in
            guard let self = self, result != nil else {
                self?.showDialog(message: "Invalid email or password!")
                ProgressHelper.hideLoading()
                return
            }
            ProgressHelper.hideLoading()
            self.navigateToHome()
        }
    }

    @IBAction func forgotPasswordAction(_: Any) {
        let vc = ForgotPasswordViewController()
        present(vc, animated: true)
    }

    private func checkHasLoggedIn() {
        firebaseManager.hasLogInSession { [weak self] in
            if $0 {
                self?.navigateToHome()
            }
        }
    }

    private func navigateToHome() {
        ProgressHelper.showLoading()
        firebaseManager.checkUserRole { [weak self] role in
            guard role != nil else {
                self?.showAlertViewController(title: "Tài khoản đã bị vô hiệu hoá hoặc đã có lỗi xảy ra",
                                              actions: [],
                                              cancel: "OK",
                                              cancelHandler: { [weak self] in
                                                  self?.dismiss(animated: true)
                                              })
                ProgressHelper.hideLoading()
                firebaseManager.logOut()
                firebaseManager.hasLogInSession {
                    if !$0 {
                        globalUser = nil
                        userFullName = nil
                        Application.shared.changeRootViewMainWindow(
                            viewController: LoginViewController.create(),
                            animated: false
                        )
                    }
                }
                return
            }
            if globalUser.isNotNil {
                let vc = MainViewController()
                Application.shared.changeRootViewMainWindow(viewController: vc, animated: true) {
                    ProgressHelper.hideLoading()
                }
            } else {
                ProgressHelper.hideLoading()
                self?.showAlertViewController(title: "Tài khoản đã bị vô hiệu hoá hoặc đã có lỗi xảy ra",
                                              actions: [],
                                              cancel: "OK",
                                              cancelHandler: { [weak self] in
                                                  self?.dismiss(animated: true)
                                              })
            }
        }
    }
}

extension LoginViewController {
    static func create() -> LoginViewController {
        let vc = LoginViewController.loadStoryboard(.main)
        return vc
    }
}
