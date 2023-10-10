//
//  UINib+Extension.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import Foundation

extension UINib {
    static func register<T: AnyObject>(_ type: T.Type) -> UINib {
        let name = String(describing: T.self)
        return UINib(nibName: name, bundle: nil)
    }
}
