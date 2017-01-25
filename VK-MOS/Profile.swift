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

    dynamic var id: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var photoSmall: String = ""
    dynamic var photoOriginal: String = ""
    dynamic var screenName: String = ""
    
    var phtoUrl: URL?{
        guard self.photoSmall != "" else {return nil}
        return self.photoSmall.fs_toURL()!
    }
    
    var fullname: String {
        return firstName + " " + lastName
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["id"] as? Int else {return nil}
        self.init()
    }
    

}

extension Profile: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.id             <- map["id"]
        self.firstName      <- map["first_name"]
        self.lastName       <- map["last_name"]
        self.screenName     <- map["screen_name"]
        self.photoSmall     <- map["photo_100"]
        self.photoOriginal  <- map["photo_medium_rec"]
    }
}
