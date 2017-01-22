//
//  Profile.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import UIKit
import ObjectMapper

class Profile: Object {

    dynamic var uid: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var photo: URL?
    dynamic var photoMediumRec: URL?
    dynamic var sex: Int = 0
    dynamic var isOnline: Bool = false
    dynamic var screenName: String = ""
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["uid"] as? Int else {return nil}
        self.init()
    }

}

extension Profile: Mappable{
    func mapping(map: Map) {
        self.uid <- map["uid"]
        self.firstName <- map["first_name"]
        self.lastName <- map["last_name"]
        self.screenName <- map["screen_name"]
        self.isOnline <- map["is_online"]
        self.sex <- map["sex"]
        self.photo <- map["photo"]
        self.photoMediumRec <- map["photo_medium_rec"]
    }
}
