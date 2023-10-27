//
//  ReusableView.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 28/10/2023.
//

import Foundation

protocol ReusableView: AnyObject { }

extension ReusableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static var reuseIdentifier: String {
        return nibName
    }
    
}

extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }
