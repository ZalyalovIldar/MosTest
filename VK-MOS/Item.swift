//
//  Item.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class Item: Object {
    dynamic var type: String = ""
    dynamic var sourceId: Int = 0
    dynamic var date: NSNumber  = 0
    dynamic var postId: Int = 0
    dynamic var text: String = ""
    dynamic var comments: Comment?
    dynamic var likes: Like?
    dynamic var reposts: Repost?
    let attachments = List<Attachment>()
    dynamic var geo: Geo?
    
    var postedDate: String{
        let date = Date(timeIntervalSince1970: self.date.doubleValue)
        return date.getElapsedInterval()
    }
    
    override static func primaryKey() -> String? {
        return "sourceId"
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["source_id"] as? Int else {return nil}
        self.init()
    }
    
}

extension Item: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.type        <- map["type"]
        self.sourceId    <- map["source_id"]
        self.postId      <- map["post_id"]
        self.text        <- map["text"]
        self.comments    <- map["comments"]
        self.likes       <- map["likes"]
        self.reposts     <- map["reposts"]
        self.attachments <- map["attachments"]
        self.geo         <- map["geo"]
        self.date        <- map["date"]
    }
}
