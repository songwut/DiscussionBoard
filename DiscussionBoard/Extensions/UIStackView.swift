//
//  UIStackView.swift
//  Ondemand
//
//  Created by Songwut Maneefun on 8/7/17.
//  Copyright © 2017 Conicle.Co.,Ltd. All rights reserved.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func removeAllArranged() {
        for view in self.arrangedSubviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func removeAllArrangedSubviews(with anyClass: AnyClass) {
        self.arrangedSubviews.forEach { (view) in
            if view.isKind(of: anyClass) {
                view.removeFromSuperview()
            }
        }
    }
}
