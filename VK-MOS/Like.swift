//
//  Like.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import ObjectMapper

class Like: Object {
    
    dynamic var count: Int = 0
    dynamic var userLikes: Bool = false
    dynamic var canLike: Bool = false
    dynamic var canPublish: Bool = false
    
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["count"] as? Int32 else {return nil}
        self.init()
    }
}

extension Like: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.count      <- map["count"]
        self.userLikes  <- map["user_likes"]
        self.canLike    <- map["can_like"]
        self.canPublish <- map["can_publish"]
    }
}
