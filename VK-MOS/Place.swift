//
//  Place.swift
//  VK-MOS
//
//  Created by Ildar Zalyalov on 22.01.17.
//  Copyright © 2017 com.personal.ildar. All rights reserved.
//

import Foundation
import ObjectMapper

class Place: Object {

    dynamic var placeId: Int32 = 0
    dynamic var title: String = ""
    dynamic var type: Int = 0
    dynamic var countyId: Int32 = 0
    dynamic var cityId: Int32 = 0
    dynamic var address: String = ""
    
    required convenience init?(map: ObjectMapper.Map) {
        guard let _ = map.JSON["place_id"] as? Int32 else {return nil}
        self.init()
    }
    
}

extension Place: Mappable{
    func mapping(map: Map) {
        self.placeId <- map["place_id"]
        self.title <- map["title"]
        self.type <- map["type"]
        self.countyId <- map["county_id"]
        self.address <- map["address"]
    }
}
