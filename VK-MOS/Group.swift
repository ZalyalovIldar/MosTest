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
    dynamic var gid: Int = 0 //gid
    dynamic var name: String = "" //name
    dynamic var screenName: String = "" //screen_name
    dynamic var isClosed: Bool = true //is_closed
    dynamic var type: String = "" //type
    dynamic var isAdmin: Bool = false //is_admin
    dynamic var photo: URL? //photo
    dynamic var photoMedium: URL? //photo_medium
    dynamic var photoBig: URL? //photo_big
    
    override static func primaryKey() -> String? {
        return "gid"
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["gid"] as? Int else {return nil}
        self.init()
    }
}

extension Group: Mappable{
    func mapping(map: Map) {
        self.gid <- map["gid"]
        self.name <- map["name"]
        self.screenName <- map["screen_name"]
        self.isClosed <- map["is_closed"]
        self.type <- map["type"]
        self.isAdmin <- map["is_admin"]
        self.photo <- map["photo"]
        self.photoMedium <- map["photo_medium"]
        self.photoBig <- map["photo_big"]
    }
}
