//
//  Collection+.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 12/10/2023.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension MutableCollection {
    subscript(safe index: Index, update: ((inout Element) -> Void)?) -> Void {
        mutating get {
            if indices.contains(index) {
                update?(&self[index])
            }
        }
    }
}
