//
//  CustomNavigation.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 12/10/2023.
//

import Foundation

protocol CustomNavigation { }


// MARK: - Title View

extension CustomNavigation where Self: UIViewController {
    
}


// MARK: - Background

extension CustomNavigation where Self: UIViewController {
    
}


// MARK: - Back Button
extension CustomNavigation where Self: UIViewController{
    
    func setNavigationBackBarButtonEmptyTitle() {
        let backBarItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarItem
    }
    
    func setNavigationItemsColor(color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
    
}
