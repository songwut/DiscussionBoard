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
            if let jsonResult = result as? [String: Any?],
               let postPage = DiscussionBoardPageResult(JSON: jsonResult) {
                print("jsonResult: \(jsonResult)")
                self.postList = postPage.list
                
                self.pinIndex = self.getPinIndex()
                complete()
            }
        }
    }
    var pinIndex: Int?
    func getPinIndex() -> Int? {
        let index = self.postList.firstIndex { (item) -> Bool in
            return item.isPinned == true
        }
        return index
    }
    
    func post(html:String, complete: ( _ post: DiscussionPostResult) -> ()) {
        if let post = DiscussionPostResult.with(["body" : html]) {
            if let index = self.pinIndex {
                let i = index + 1
                if i == self.postList.count {
                    self.postList.append(post)
                } else {
                    self.postList.insert(post, at: i)
                }
                complete(post)
            } else {//no pin add in first object
                self.postList.insert(post, at: 0)
                complete(post)
            }
            
        }
    }
    
    func reply(html:String, post:DiscussionPostResult, complete: ( _ reply: DiscussionReplyResult) -> ()) {
        if let reply = DiscussionReplyResult.with(["body" : html]) {
            post.replyList.append(reply)
            complete(reply)
        }
    }
    
    func replyList(post:DiscussionPostResult , complete: ( _ replyList: [DiscussionReplyResult]) -> ()) {
        JSON.read("reply_list") { (result) in
            if let jsonResult = result as? [String: Any?],
               let reply = DiscussionReplyListResult(JSON: jsonResult as [String : Any]) {
                print("jsonResult: \(jsonResult)")
                
                post.replyList = reply.list
                complete(reply.list)
            }
        }
    }
}
