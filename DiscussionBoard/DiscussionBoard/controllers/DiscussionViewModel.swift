//
//  DiscussionViewModel.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import Foundation
import RxSwift
import RxCocoa

let DBMaxHeightReply = 224
let maxReplyList = 2

class DiscussionViewModel {
    /*
    var postList: [DiscussionPostResult] = [
            DiscussionPostResult.with(["body" : "text html", "reply_list": ""])!,
            DiscussionPostResult.with(["body" : "text html", "reply_list": ""])!,
            DiscussionPostResult.with(["body" : "text html", "reply_list": ""])!
        ]
    */
    var currentMenu:DiscussionMenuType?
    var postList = [DiscussionPostResult]()
    
    func myProfile() -> ProfileResult? {
        //TODO:change profile to type profile result
        let profile = ProfileResult(JSON: ["image" : "https://gravatar.com/avatar/91e77ea2e99a0bf7d73d04ac2739860d?s=400&d=mp&r=x"])
        return profile
    }
    
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
    
    func edit(html:String, item:Any?, complete:@escaping ( _ content: Any?) -> ()) {
        if let post = item as? DiscussionPostResult {
            post.body = html
        } else if let reply = item as? DiscussionReplyResult {
            reply.body = html
        }
        complete(item)
        /*
        
        let request = DiscussionUpdateRequest()
        request.contentId = self.contentId
        request.contentType = self.contentType
        request.commentId = post.id
        request.body = html
        API.request(request) { (responseBody: ResponseBody?, replyResult: DiscussionReplyResult?, isCache, error) in
            if let reply = replyResult {
                post.replyList.append(reply)
                complete(reply)
            }
        }
        */
    }
    
    func delete(view:Any?, complete:@escaping ( _ done: Bool?) -> ()) {
        if let postView = view as? DCPostView,
           let post = postView.post {
            
            
        } else if let pinView = view as? DCPinView,
                  let pin = pinView.post  {
            
        } else if let replyView = view as? DCReplyView,
                  let reply = replyView.reply  {
            
        }
        complete(true)
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
    
    func reaction(item:Any?, complete:@escaping ( _ reaction: DiscussionReactionResult?,  _ isLiked: Bool) -> ()) {
        var reaction:DiscussionReactionResult?
        var isLiked = false
        if let post = item as? DiscussionPostResult {
            isLiked = !post.isLiked
            let count = isLiked ? (post.countLikes + 1) : (post.countLikes - 1)
            post.isLiked = isLiked
            post.countLikes = count
            reaction = DiscussionReactionResult(JSON: ["count_likes" : count])
        } else if let reply = item as? DiscussionReplyResult {
            isLiked = !reply.isLiked
            let count = isLiked ? (reply.countLikes + 1) : (reply.countLikes - 1)
            reply.isLiked = isLiked
            reply.countLikes = count
            reaction = DiscussionReactionResult(JSON: ["count_likes" : count])
        }
        complete(reaction, isLiked)
    }
}
