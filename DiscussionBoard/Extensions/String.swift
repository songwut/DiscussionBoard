//
//  String.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 19/1/2564 BE.
//

import Foundation
extension String {
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
