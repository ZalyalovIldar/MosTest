//
//  NewsFeed.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsFeed: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var items: Array<Item> = []
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["id"] as? Int else {return nil}
        self.init()
    }
    
}

extension NewsFeed: Mappable{
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
    }
}
