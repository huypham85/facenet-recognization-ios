//
//  MainViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import UIKit

class MainViewController: UIViewController {
    let mainTabBarController = MainTabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserRole()
        addChild(mainTabBarController)
        view.addSubview(mainTabBarController.view)
        mainTabBarController.didMove(toParent: self)

        // Add Auto Layout constraints
        mainTabBarController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTabBarController.view.topAnchor.constraint(equalTo: view.topAnchor),
            mainTabBarController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTabBarController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTabBarController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    private func checkUserRole() {
        firebaseManager.checkUserRole { role in
            switch role {
            case .student:
                break
            case .teacher:
                break
            }
        }
    }
}
