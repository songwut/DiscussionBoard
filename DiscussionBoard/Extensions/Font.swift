//
//  Font.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 22/1/2564 BE.
//

import UIKit

extension UIFont {
    
    class func font(_ size: StyleName, _ font: AppFont) -> UIFont {
        return UIFont(name: font.fontName(), size: size.rawValue)!
    }
}
