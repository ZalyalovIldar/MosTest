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
    dynamic var nextFrom: String = "" //using for pagination
    
    let items    = List<Item>() //the body of post
    let groups   = List<Group>() // Head of post (include name, avatar_photo, etc) only Users
    let profiles = List<Profile>() // Head of post (include name, avatar_photo, etc) only Groups
    
    override static func primaryKey() -> String? {
        return "nextFrom"
    }
    
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

