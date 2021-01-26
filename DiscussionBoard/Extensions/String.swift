//
//  String.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 19/1/2564 BE.
//

import Foundation
extension String {
    
    var removeHtml: String {
          return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func dateTimeAgo() -> String {
        return self
    }
    
    func localized() -> String {
        return self
        /*
        if isLocalizeOnline {
            return Localized.shared.string(forKey: self) // localize with API
        } else {
            return Localized.localized(text: self) // localize in local
        }
        */
    }
}
