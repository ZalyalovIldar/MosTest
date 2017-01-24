//
//  Group.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import ObjectMapper

class Group: Object {
    dynamic var id: Int = 0 //gid
    dynamic var name: String = "" //name
    dynamic var screenName: String = "" //screen_name
    dynamic var isClosed: Bool = true //is_closed
    dynamic var type: String = "" //type
    dynamic var isAdmin: Bool = false //is_admin
    dynamic var photoSmall: String = "" //photo 50х50
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["id"] as? Int else {return nil}
        self.init()
    }
    
    var phtoUrl: URL?{
        guard self.photoSmall != "" else {return nil}
        return self.photoSmall.fs_toURL()
    }
    
}

extension Group: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.screenName <- map["screen_name"]
        self.isClosed <- map["is_closed"]
        self.type <- map["type"]
        self.isAdmin <- map["is_admin"]
        self.photoSmall <- map["photo_50"]
    }
}
