//
//  DCStyle.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 24/1/2564 BE.
//

import UIKit

class DCStyle {
    class func disable() -> UIColor {
        return .primary_75()
    }
    
    class func active() -> UIColor {
        return .primary()
    }
    
    class func editEnd() -> UIColor {
        return UIColor(hex: "D7D8D9")
    }
    
    class func editStart() -> UIColor {
        return .primary()
    }
}
