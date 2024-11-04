//
//  UICartBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Konstantin on 01.11.2024.
//

import UIKit
import ProgressHUD

final class UICartBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
