//
//  MainViewController.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 10/10/2023.
//

import CoreBluetooth
import UIKit

class MainViewController: BaseViewController {
    let mainTabBarController = MainTabBarController()
    var peripheralManager: CBPeripheralManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserRole()
        addChild(mainTabBarController)
        view.addSubview(mainTabBarController.view)
        mainTabBarController.didMove(toParent: self)

        // Add Auto Layout constraints
        mainTabBarController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTabBarController.view.topAnchor.constraint(equalTo: view.topAnchor),
            mainTabBarController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTabBarController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTabBarController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func checkUserRole() {
        guard let globalUser = globalUser else {
            return
        }
        firebaseManager.checkUserRole { [weak self] role in
            guard let role = role else {
                self?.showAlertViewController(title: "Tài khoản đã bị vô hiệu hoá hoặc đã có lỗi xảy ra",
                                              actions: [],
                                              cancel: "OK",
                                              cancelHandler: { [weak self] in
                                                  self?.dismiss(animated: true)
                                              })
                return
            }
            switch role {
            case .student:
                firebaseManager.getStudent(with: globalUser.id) { student in
                    if let student = student {
                        userFullName = student.name
                    }
                }
            case .teacher:
                self?.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
            }
        }
    }
}

extension MainViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            let serviceUUID = CBUUID(string: UUID().uuidString)
            let service = CBMutableService(type: serviceUUID, primary: true)
            peripheralManager?.add(service)

            peripheralManager?.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
                CBAdvertisementDataLocalNameKey: globalUser?.id ?? "teacher device",
            ])
            firebaseManager.uploadTeacherDeviceName(deviceName: globalUser?.id ?? "", teacherId: globalUser?.id ?? "")
        }
        if peripheral.state == .unauthorized {
            showAlertViewController(title: "Không có quyền sử dụng Bluetooth",
                                    message: "Vui lòng cho phép sử dụng Bluetooth trong cài đặt của bạn",
                                    actions: ["Cài đặt"],
                                    cancel: nil) { index in
                if index == 0 {
                    if let bundleId = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&root=Privacy&path=Bluetooth/\(bundleId)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error == nil {
            print("Peripheral is advertising")
            showToast(message: "Đang phát tín hiệu bluetooth!")
        } else {
            print("Error advertising peripheral: \(error!.localizedDescription)")
        }
    }
}
