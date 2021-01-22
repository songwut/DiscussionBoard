//
//  UIButton.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 20/1/2564 BE.
//

import UIKit

extension UIButton {
    
    func setStyleColor(_ isEnabled: Bool, titleColor:UIColor, bgColor:UIColor) {
        self.isEnabled = isEnabled
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
    }

    var titleFont: UIFont {
        get {
            return (self.titleLabel?.font)!
        }
        set {
            self.titleLabel?.font = newValue
        }
    }
    
    func setUnderline(_ text: String?, for state: UIControl.State) {
        self.titleLabel?.text = text
        let color = self.titleLabel?.textColor ?? UIColor.white
        let font = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 14)
        if let _ = self.titleLabel, let titleText = text {
            
            let attributes : [NSAttributedString.Key: Any] = [
                .font : font,
                .foregroundColor : color,
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
            let attributeString = NSMutableAttributedString(string: titleText,
                                                            attributes: attributes)
            self.setAttributedTitle(attributeString, for: .normal)
        }
        
    }
    
    func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    /*
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.count - 1))
            attributedText = attributedString
        }
    }
    */
}
