//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 04.11.2024.
//

import UIKit
import ProgressHUD

final class UIProfileBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.showProgress("Loading...", 0.5)
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
