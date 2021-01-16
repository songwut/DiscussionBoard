//
//  DiscussionViewModel.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import Foundation
import RxSwift
import RxCocoa

class DiscussionViewModel {
    /*
    var postList: [DiscussionPostResult] = [
            DiscussionPostResult.with(["body" : "text html", "reply_list": ""])!,
            DiscussionPostResult.with(["body" : "text html", "reply_list": ""])!,
            DiscussionPostResult.with(["body" : "text html", "reply_list": ""])!
        ]
    */
    var postList = [DiscussionPostResult]()
    
    func prepareData(complete: () -> ()) {
        var list = [DiscussionPostResult]()
        JSON.read("post") { (result) in
            if let jsonResult = result as? [String: AnyObject?],
               let postPage = DiscussionBoardPageResult(JSON: jsonResult) {
                self.postList = postPage.list
                print("jsonResult: \(jsonResult)")
            }
        }
    }
}
