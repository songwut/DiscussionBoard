//
//  Results.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 16/1/2564 BE.
//

import Foundation
import ObjectMapper

class BaseResult:Mappable {

    var id = 0
    var idString = ""
    var name = ""
    var title = ""
    var desc = ""
    var image = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        idString  <- map["id"]
        id        <- map["id"]
        title     <- map["title"]
        name      <- map["name"]
        desc      <- map["desc"]
        image     <- map["image"]
        
    }
}

class PageConfig: BaseResult {
    
    var datetimeUpdate = ""
    var type = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        datetimeUpdate <- map["datetime_update"]
        type           <- map["type"]
    }
}

class PageResult: BaseResult {
    
    var config: PageConfig?
    var previous = ""
    var next: Int?
    //var filters = [FilterSectionObj]()
    //var filterList = [FilterResult]()
    var pageSize = 0
    var count = 0
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        config           <- map["config"]
        previous         <- map["previous"]
        next             <- map["next"]
        //filterList       <- map["filter_list"]
        //filters          <- map["filter_list"]
        pageSize         <- map["page_size"]
        count            <- map["count"]
    }
}
