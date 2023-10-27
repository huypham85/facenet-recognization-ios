//
//  UICollectionView+Extension.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 27/10/2023.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(cellClass: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: bundle ?? Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    public func dequeueCell<T: UICollectionViewCell>(ofType cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }

    func register<C: UICollectionViewCell>(
        type: C.Type,
        forCellWithReuseIdentifier identifier: String = C.reuseIdentifier
    ) {
        register(type, forCellWithReuseIdentifier: identifier)
    }
}
