//
//  DiscussionBoardPageResult.swift
//  LEGO
//
//  Created by Songwut Maneefun on 14/1/2564 BE.
//  Copyright © 2564 conicle. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class DiscussionBoardPageResult: PageResult {
    
    var list = [DiscussionPostResult]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        list             <- map["results"]
    }
}

class DiscussionReplyListResult: BaseResult {
    
    var list = [DiscussionReplyResult]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        list             <- map["results"]
    }
}

// MARK: - DiscussionPostResult
class DiscussionPostResult: BaseResult {
    
    var body = ""
    var parent: Int?
    var isEdited = false
    var isDeletable = false
    var isEditable = false
    var isPinned = false
    var isLiked = false
    var countLikes = 0
    var countReplies = 0
    var datetimeCreate = ""
    var datetimeUpdate = ""
    var authorRole = ""
    var author: AuthorResult?
    var replyList = [DiscussionReplyResult]()
    
    //var mentionedList: [List]
    //var imageList: [List]
    
    func isReplyFull() -> Bool {
        return self.replyList.count == self.countReplies
    }

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        replyList         <- map["reply_list"]
        body              <- map["body"]
        parent            <- map["parent"]
        isEdited          <- map["is_edited"]
        isDeletable       <- map["is_deletable"]
        isEditable        <- map["is_editable"]
        isPinned          <- map["is_pinned"]
        isLiked           <- map["is_liked"]
        countLikes        <- map["count_likes"]
        countReplies      <- map["count_replies"]
        datetimeCreate    <- map["datetime_create"]
        datetimeUpdate    <- map["datetime_update"]
        authorRole        <- map["author_role"]
        author            <- map["author"]
    }
    
    class func with(_ dict: [String : Any]) -> DiscussionPostResult? {
        let item = Mapper<DiscussionPostResult>().map(JSON: dict)
        return item
    }
}

class DiscussionReplyResult: DiscussionPostResult {
    override class func with(_ dict: [String : Any]) -> DiscussionReplyResult? {
        let item = Mapper<DiscussionReplyResult>().map(JSON: dict)
        return item
    }
}



// MARK: - AuthorResult
class AuthorResult: BaseResult {

    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
    }
}
