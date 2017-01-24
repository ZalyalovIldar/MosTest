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
    dynamic var nextFrom: String = ""
    
    let items    = List<Item>()
    let groups   = List<Group>()
    let profiles = List<Profile>()
    
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["items"] as? Array<Any> else {return nil}
        self.init()
    }
    
}

extension NewsFeed: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.nextFrom   <- map["next_from"]
        self.groups     <- map["groups"]
        self.profiles   <- map["profiles"]
        self.items      <- map["items"]
    }
}

