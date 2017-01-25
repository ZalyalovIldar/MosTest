//
//  Photo.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo: Object {
    dynamic var id: Int = 0
    dynamic var ownerId: Int = 0
    dynamic var photo130: String = ""
    dynamic var text: String = ""
    
    var phtoUrl: URL?{
        guard self.photo130 != "" else {return nil}
        return self.photo130.fs_toURL()
    }
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["id"] as? Int else {return nil}
        self.init()
    }
    
}

extension Photo: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.id       <- map["id"]
        self.ownerId  <- map["owner_id"]
        self.photo130 <- map["photo_604"]
        self.text     <- map["text"]
    }
}
