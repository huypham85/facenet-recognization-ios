//
//  StudentDetailViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 15/10/2023.
//

import UIKit

class StudentDetailViewController: BaseViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        firebaseManager.logOut()
        firebaseManager.hasLogInSession {
            if !$0 {
                Application.shared.changeRootViewMainWindow(viewController: LoginViewController.create(),animated: true)
            }
        }
    }
    
    private func setupView() {
        guard let student = student else { return }
        profileImageView.sd_setImage(with: URL(string: student.photo))
        nameLabel.text = student.name
        idLabel.text = "MSV: \(student.id)"
        classLabel.text = "Lớp: \(student.mainClass)"
        emailLabel.text = student.email
        dobLabel.text = student.dob
        genderLabel.text = student.gender
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
