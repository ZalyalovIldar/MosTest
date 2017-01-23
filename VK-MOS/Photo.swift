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
    dynamic var pid: Int32 = 0
    dynamic var ownerId: Int32 = 0
    dynamic var aid: Int32 = 0
    dynamic var srcBig: String = ""
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["pid"] as? String else {return nil}
        self.init()
    }
}

extension Photo: Mappable{
    func mapping(map: ObjectMapper.Map) {
        self.pid <- map["pid"]
        self.ownerId <- map["owner_id"]
        self.aid <- map["aid"]
        self.srcBig <- map["scr_big"]
    }
}
