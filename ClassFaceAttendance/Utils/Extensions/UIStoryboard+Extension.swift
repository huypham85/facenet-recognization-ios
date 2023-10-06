//
//  UIStoryboard+Extension.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 07/10/2023.
//

import UIKit

protocol StoryboardLoadable {}

enum Storyboard: String {
    case main = "Main"
}

extension StoryboardLoadable where Self: UIViewController {
    static func loadStoryboard(_ name: Storyboard) -> Self {
        return UIStoryboard(name: "\(name.rawValue)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

extension UIViewController: StoryboardLoadable {}
