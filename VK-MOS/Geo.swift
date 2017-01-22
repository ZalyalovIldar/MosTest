//
//  Geo.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class Geo: Object {
    dynamic var type: String = ""
    dynamic var coordinates: String = ""
    dynamic var place: Place?
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["type"] as? String else {return nil}
        self.init()
    }
}

extension Geo: Mappable{
    func mapping(map: Map) {
        self.type <- map["type"]
        self.coordinates <- map["coordinates"]
        self.place <- map["place"]
    }
}
