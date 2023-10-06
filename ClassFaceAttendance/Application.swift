//
//  Application.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 07/10/2023.
//

import Foundation

class Application {
    static let shared = Application()
    func changeRootViewMainWindow(viewController: UIViewController,
                                  animated: Bool = true,
                                  completion: (() -> Void)? = nil) {
        guard let mainWindow = AppDelegate.shared?.window else { return }
        UIView.transition(
            with: mainWindow,
            duration: animated ? 0.5 : 0.0,
            options: .transitionCrossDissolve,
            animations: nil) { _ in
                mainWindow.rootViewController = viewController
                mainWindow.makeKeyAndVisible()
                completion?()
            }
    }
}
