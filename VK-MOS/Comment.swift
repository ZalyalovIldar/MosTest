//
//  Comment.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment: Object {
    dynamic var count: Int = 0
    dynamic var canPost: Bool = false
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["count"] as? Int32 else {return nil}
        self.init()
    }
}

extension Comment: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.count   <- map["count"]
        self.canPost <- map["can_post"]
    }
}
