//
//  MainTabBarController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import UIKit

struct TabBarItemTitle {
    static let classCalendar = "Lịch học"
    static let course = "Lớp tín chỉ"
    static let faceRegister = "Đăng ký"
    static let profile = "Cá nhân"
}

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create view controllers for each tab
        let homeViewController = BaseNavigationController(rootViewController: CalendarHomeViewController())
        let viewLogViewController = BaseNavigationController(rootViewController: AllCoursesViewController())
        let registerFaceViewController = BaseNavigationController(rootViewController: RegisterFaceViewController())
        let profileViewController = BaseNavigationController(rootViewController: StudentDetailViewController())

        // Create an array of view controllers
        let studentTabbar = [
            homeViewController,
            viewLogViewController,
            registerFaceViewController,
            profileViewController,
        ]
        
        let teacherTabbar = [
            homeViewController,
            viewLogViewController,
            profileViewController,
        ]
        
        let viewControllers = (globalUser?.role == .student) ? studentTabbar : teacherTabbar

        // Set the view controllers for the tab bar
        self.viewControllers = viewControllers

        // Optionally, customize the tab bar appearance
        // You can set titles, images, and more for each tabBarItem.
        homeViewController.tabBarItem = UITabBarItem(
            title: TabBarItemTitle.classCalendar,
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.bounce")
        )
        viewLogViewController.tabBarItem = UITabBarItem(
            title: TabBarItemTitle.course,
            image: UIImage(systemName: "books.vertical"),
            selectedImage: UIImage(systemName: "books.vertical")
        )
        
        registerFaceViewController.tabBarItem = UITabBarItem(
            title: TabBarItemTitle.faceRegister,
            image: UIImage(systemName: "faceid"),
            selectedImage: UIImage(systemName: "faceid")
        )
        profileViewController.tabBarItem = UITabBarItem(
            title: TabBarItemTitle.profile,
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )
        
        tabBar.backgroundColor = .backgroundColor
        tabBar.tintColor = .red600
        // Optionally, set the default selected tab
        selectedIndex = 0
    }
}
