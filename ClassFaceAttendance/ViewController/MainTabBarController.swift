//
//  MainTabBarController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create view controllers for each tab
        let homeViewController = BaseNavigationController(rootViewController: CalendarHomeViewController())
        let viewLogViewController = ViewLogViewController.create()
        let registerFaceViewController = HomeViewController.create()
        let profileViewController = StudentDetailViewController()

        // Create an array of view controllers
        let viewControllers = [
            homeViewController,
            viewLogViewController,
            registerFaceViewController,
            profileViewController,
        ]

        // Set the view controllers for the tab bar
        self.viewControllers = viewControllers

        // Optionally, customize the tab bar appearance
        // You can set titles, images, and more for each tabBarItem.
        homeViewController.tabBarItem = UITabBarItem(
            title: "Hôm nay",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.bounce")
        )
        viewLogViewController.tabBarItem = UITabBarItem(
            title: "Lịch sử",
            image: UIImage(systemName: "clock"),
            selectedImage: UIImage(systemName: "clock.bounce")
        )
        
        registerFaceViewController.tabBarItem = UITabBarItem(
            title: "Đăng ký",
            image: UIImage(systemName: "faceid"),
            selectedImage: UIImage(systemName: "faceid")
        )
        profileViewController.tabBarItem = UITabBarItem(
            title: "Cá nhân",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        tabBar.backgroundColor = .white
        // Optionally, set the default selected tab
        selectedIndex = 0
    }
}
