//
//  BaseViewController.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 12/10/2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    deinit {
        Log.info(NSStringFromClass(classForCoder) + "." + #function)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        Log.info(NSStringFromClass(classForCoder) + "." + #function)
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        Log.info(NSStringFromClass(classForCoder) + "." + #function)
        super.viewWillAppear(animated)
        setNavigationBackBarButtonEmptyTitle()
        setNavigationItemsColor(color: .white)
    }

    @objc func closeKeyboard() {
        view.endEditing(true)
    }

    func showAlertViewController(title: String?,
                                 message: String? = nil,
                                 actions: [String],
                                 cancel: String?,
                                 actionHandler: ((Int) -> Void)? = nil,
                                 cancelHandler: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        actions.enumerated().forEach { index, text in
            let action = UIAlertAction(title: text, style: .default) { _ in
                actionHandler?(index)
            }
            alertViewController.addAction(action)
        }

        if let cancel = cancel {
            let cancelAction = UIAlertAction(title: cancel, style: .cancel) { _ in
                cancelHandler?()
            }
            alertViewController.addAction(cancelAction)
        }

        present(alertViewController, animated: true)
    }

    func showToast(message: String) {
        view.viewWithTag(9999)?.removeFromSuperview()
        let toastLabel = UILabel().with {
            $0.text = message
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            $0.textColor = .white
            $0.sizeToFit()
            $0.alpha = 0
            $0.frame = CGRect(x: 0, y: 0, width: $0.frame.width + 10, height: $0.frame.height + 10)
            $0.textAlignment = .center
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
        toastLabel.tag = 9999
        toastLabel.center = view.center
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            toastLabel.alpha = 1
        } completion: { _ in
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                UIView.animate(withDuration: 0.25, animations: {
                    toastLabel.alpha = 0
                }, completion: { _ in
                    toastLabel.removeFromSuperview()
                })
            })
        }
    }

    func createCloseBarButtonItem(target: Any?, action: Selector) -> UIBarButtonItem {
        let backButtonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

        let backImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        backImage.image = UIImage(named: "ic_back_camera")
        backImage.tintColor = UIColor.black
        backImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backButtonContainerView.addSubview(backImage)

        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        backButtonContainerView.addGestureRecognizer(tapGesture)

        let closeBarButtonItem = UIBarButtonItem(customView: backButtonContainerView)
        return closeBarButtonItem
    }
}

extension BaseViewController: CustomNavigation {}
