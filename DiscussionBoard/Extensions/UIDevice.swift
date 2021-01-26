//
//  UIDevice.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 27/1/2564 BE.
//

import Foundation
import UIKit

extension UIDevice {
    class func isIpad() -> Bool {
        return UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    class func isiOS13() -> Bool {
        if #available(iOS 13.0, *) {
            return true
        } else {
            return false
        }
    }
    
    static var isPhoneX: Bool {
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        let height = screenSize.height
        return min(width, height) == 375 && max(width, height) == 812
    }
    
    static var isiPhoneXR: Bool {
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width
        let height = screenSize.height
        return min(width, height) == 414 && max(width, height) == 896
    }
    
    static var isiPhoneXUpper: Bool {
        let screenSize = UIScreen.main.nativeBounds
        let width = screenSize.width
        let height = screenSize.height
        return max(width, height) >= 2436
    }
    
    static var isNotch: Bool {
        return UIDevice.isiPhoneXUpper || UIDevice.isiPhoneXR
    }
}
