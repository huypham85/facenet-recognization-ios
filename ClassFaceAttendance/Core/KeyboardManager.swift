//
//  KeyboardManager.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 15/10/2023.
//

import Foundation
import IQKeyboardManagerSwift

struct KeyboardManager {
    static func setup() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 16
    }
}
