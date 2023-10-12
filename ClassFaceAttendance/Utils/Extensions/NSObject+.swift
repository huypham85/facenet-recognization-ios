//
//  NSObject+.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 12/10/2023.
//

import Foundation

protocol WithCreation: AnyObject {}

extension NSObject: WithCreation {}

extension WithCreation where Self: NSObject {
    @discardableResult
    func with(_ closure: @escaping (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        return self != nil
    }
}

extension NSObject {
    @nonobjc var className: String {
        return String(describing: type(of: self))
    }

    @nonobjc class var className: String {
        return String(describing: self)
    }
}
