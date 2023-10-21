//
//  Alert.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 22/10/2023.
//

import UIKit

// MARK: - Display Alert

protocol DisplayAlert {
    func displayAlert(
        customAlertTitle: String?, customAlertMessage: String?,
        actions: [UIAlertAction]?, style: UIAlertController.Style,
        completion: (() -> Void)?
    )
    
}

extension DisplayAlert where Self: UIViewController {
    
    func displayAlert(
        customAlertTitle: String? = nil,
        customAlertMessage: String? = nil,
        actions: [UIAlertAction]? = nil,
        style: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        
        let alertController = UIAlertController(title: customAlertTitle, message: customAlertMessage, preferredStyle: style)
        
        if let actions = actions {
            actions.forEach {
                alertController.addAction($0)
            }
        } else {
            let okAlertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAlertAction)
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = view
                popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        default:
            ()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: completion)
        }
        
    }
    
}

extension UIViewController: DisplayAlert { }

