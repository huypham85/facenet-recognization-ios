//
//  ForgotPasswordViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 01/11/2023.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func sendEmail(_ sender: Any) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailTextField.text ?? "") { error in
            if let error = error {
                print("Error when reset password")
                return
            }
            print("Email has been sent")
        }
    }
}
