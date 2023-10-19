//
//  ProgressHelper.swift
//  ClassFaceAttendance
//
//  Created by HuyPT3 on 19/10/2023.
//

import Foundation
import ProgressHUD

class ProgressHelper {
    static func showLoading(text: String = "Loading") {
        ProgressHUD.colorProgress = .darkGreen
        ProgressHUD.colorStatus = .darkGreen
        ProgressHUD.colorAnimation = .darkGreen
        
        ProgressHUD.show(text, interaction: false)
    }
    
    static func hideLoading() {
        ProgressHUD.dismiss()
    }
}
