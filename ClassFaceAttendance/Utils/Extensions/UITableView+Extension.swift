//
//  UITableView+Extension.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import Foundation

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        self.register(UINib.register(T.self), forCellReuseIdentifier: T.cellId)
    }
}

extension UITableViewCell {
   static var cellId: String {
        return String(describing: self.self)
    }
}

extension UICollectionViewCell {
   static var cellId: String {
        return String(describing: self.self)
    }
}
