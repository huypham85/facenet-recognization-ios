//
//  BaseNavigationController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 14/10/2023.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override var shouldAutorotate: Bool {
        return viewControllers.last?.shouldAutorotate ?? false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }

    static func create(rootViewController: UIViewController) -> BaseNavigationController {
        let viewController = BaseNavigationController(rootViewController: rootViewController)
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .red600
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        changeColor(.backgroundColor, isHideBorderShadow: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    private func changeColor(_ color: UIColor, isHideBorderShadow: Bool = true) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = color
        navigationBar.standardAppearance = appearance
        
        if #available(iOS 15, *) {
            navigationBar.scrollEdgeAppearance = appearance
        }
        
        if color != .clear {
            view.backgroundColor = color
        }
        
//        navigationBar.setBackgroundImage(color.as1ptImage(), for: .default)
        let isHideShadow = color == .clear || isHideBorderShadow
        navigationBar.setValue(isHideShadow, forKey: "hidesShadow")
    }
}

